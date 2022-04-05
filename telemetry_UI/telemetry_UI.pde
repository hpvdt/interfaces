import grafica.*;

// Need G4P library
import g4p_controls.*;
import java.awt.Font;
java.awt.Font regLabels = new java.awt.Font("SansSerif", java.awt.Font.PLAIN, 16);
java.awt.Font bigLabels = new java.awt.Font("SansSerif", java.awt.Font.PLAIN, 30);

// Communication related stuff
import processing.serial.*;
comms bike = new comms(); // Used to communicate to and from the bike
int BAUDRATE = 115200;

int graphWidth = 300;
GPointsArray speedBuffer = new GPointsArray(graphWidth);
GPointsArray powerBuffer = new GPointsArray(graphWidth);
GPointsArray cadenceBuffer = new GPointsArray(graphWidth);
GPointsArray heartRateBuffer = new GPointsArray(graphWidth);
GPlot speedPlot, powerPlot, cadencePlot, heartRatePlot; // One for each set of y-axis
// We can overlay plots to put two sets of y-axis on the same plot

int frameRateSet = 20; // Frame rate we're setting this to
int requestFreq = 5; // Frequency of requests for data (Hz)
int requestCount = 0; // Count of times requests were sent out
boolean requestData = false; // Are we sending data

// Vehicle variables
int FHR = 0;
int cadence = 0;
int power = 0;

int batt1 = 0;
int batt2 = 0;

float humidity = 0;
float temperature = 0.0; // Temperature (recieved as (degC * 2) + 50)

float speed = 0.0; // Speed km/h
float distance = 0.0; // Distance in km
int rotations = 0; // Wheel rotation count, used to calculate distance
float WHEEL_CIRC = 2.104; // Wheel circumference in m

void drawPlot (GPlot plot) {
  // Draw a given plot
  plot.beginDraw();
  plot.drawBox();
  plot.drawYAxis();
  plot.drawTitle();
  plot.drawLines();
  plot.endDraw();
}

public void setup() {
  size(720, 480, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here

  label1.setText("Speed:\nkm/h / mph");
  label4.setText("Distance:\nkm / mi");

  speedLbl.setFont(bigLabels);
  distLbl.setFont(bigLabels);
  powerLbl.setFont(bigLabels);
  cadenceLbl.setFont(bigLabels);
  heartRateLbl.setFont(bigLabels);

  speedPlot = new GPlot(this);
  speedPlot.setPos(330, 0);
  speedPlot.setMar(10, 0, 0, 0);
  speedPlot.setDim(380, 160);
  speedPlot.setAxesOffset(4);
  speedPlot.setTicksLength(4);
  speedPlot.getYAxis().setAxisLabelText("Speed (km/h)");

  powerPlot = new GPlot(this);
  powerPlot.setPos(330, 160);
  powerPlot.setMar(10, 0, 0, 0);
  powerPlot.setDim(380, 160);
  powerPlot.setAxesOffset(4);
  powerPlot.setTicksLength(4);
  powerPlot.getYAxis().setAxisLabelText("Power (W)");

  heartRatePlot = new GPlot(this);
  heartRatePlot.setPos(330, 320);
  heartRatePlot.setMar(10, 0, 0, 0);
  heartRatePlot.setDim(380, 160);
  heartRatePlot.setAxesOffset(4);
  heartRatePlot.setTicksLength(4);
  heartRatePlot.getYAxis().setAxisLabelText("Heart Rate (BPM)");

  //bike.line = new Serial(this, "/dev/serial0/", BAUDRATE); // Initialize serial line
  // List serial options
  serialSelect.setItems(Serial.list(), 0);
  frameRate(frameRateSet);
}

public void draw() {

  background(230);

  if (frameCount % (frameRateSet / requestFreq) < 2) {
    // Update values periodically
    //FHR = int(60 + 10*noise(frameCount * 0.01));
    //speed = 15 + 10*noise(frameCount * 0.05);
    //power = int(150 + 30*noise(frameCount * 0.1));

    // Serial requests, only if connected though
    if (bike.line != null) {
      //println("============================");
      FHR = int(bike.requestDataTwice('a'));
      cadence = int(bike.requestDataTwice('c'));
      power = int(bike.requestDataTwice('e'));

      batt1 = int(bike.requestDataTwice('i'));
      batt2 = int(bike.requestDataTwice('j'));

      // Since humidity and temp are based off of the value of a single byte 
      // we need to pick out the first character and convert to number
      // To avoid issues need to check for empty strings
      String temporary = bike.requestData('h');
      if (temporary.length() > 0) {
        humidity = float(byte(temporary.charAt(0)));
        humidity /= 2; // Halve to get the real value
      }
      
      temporary = bike.requestData('t');
      if (temporary.length() > 0) {
        temperature = int(byte(temporary.charAt(0)));
        temperature = (temperature / 2) - 50;
      }

      speed = float(bike.requestDataTwice('s'));
      rotations = int(bike.requestDataTwice('q'));
      distance = int(rotations * WHEEL_CIRC); // Find distance travelled (m)
      distance /= 1000.0; // m to km
    }
    
    // Update all the rotating buffers
    while (speedBuffer.getNPoints() > graphWidth) speedBuffer.remove(0); // Remove all extra poiunts
    speedBuffer.add(requestCount, speed);
    speedPlot.setPoints(speedBuffer);

    while (powerBuffer.getNPoints() > graphWidth) powerBuffer.remove(0);
    powerBuffer.add(requestCount, power);
    powerPlot.setPoints(powerBuffer);

    while (heartRateBuffer.getNPoints() > graphWidth) heartRateBuffer.remove(0);
    heartRateBuffer.add(requestCount, FHR);
    heartRatePlot.setPoints(heartRateBuffer);

    // Update the labels
    batt1Lbl.setText(str(batt1));
    batt2Lbl.setText(str(batt2));
    distLbl.setText(str(distance));
    speedLbl.setText(str(speed));
    powerLbl.setText(str(power));
    cadenceLbl.setText(str(cadence));
    heartRateLbl.setText(str(FHR));
    tempHumLbl.setText(str(temperature) + " / " + str(humidity) + "%");

    requestCount++; // Increase count
  }

  drawPlot(speedPlot);
  drawPlot(powerPlot);
  drawPlot(heartRatePlot);
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}
