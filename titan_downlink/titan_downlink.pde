import grafica.*;

String idealSerialLine = "/dev/ttyUSB0"; // Ideal line, if present connected to automatically
boolean individualRequests = false;

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
GPointsArray powerBufferFront = new GPointsArray(graphWidth);
GPointsArray powerBufferRear = new GPointsArray(graphWidth);
GPointsArray powerBufferTotal = new GPointsArray(graphWidth);
GPointsArray cadenceBufferFront = new GPointsArray(graphWidth);
GPointsArray cadenceBufferRear = new GPointsArray(graphWidth);
GPlot speedPlot, powerPlot, cadencePlot;
// We can overlay plots to put two sets of y-axis on the same plot

int frameRateSet = 20; // Frame rate we're setting this to
int requestFreq = 5; // Frequency of requests for data (Hz)
int requestCount = 0; // Count of times requests were sent out
boolean requestData = false; // Are we sending data

// Vehicle variables
int FHR = 0;
int RHR = 0; 
int cadenceFront = 0;
int cadenceRear = 0; 
int powerFront = 0;
int powerRear = 0; 

int batt1 = 0;
int batt2 = 0;

int c02 = 0; 

float brakeFront = 0;
float brakeRear = 0; 

float humidity = 0;
float temperature = 0.0; // Temperature (recieved as (degC * 2) + 50)

float speedEncoder = 0.0; // Speed km/h from encoder
float speedGPS = 0.0;
float distance = 0.0; // Distance in km
float distanceGPS = 0.0;
int rotations = 0; // Wheel rotation count, used to calculate distance
float WHEEL_CIRC = 2.104; // Wheel circumference in m
float KM_TO_MI = 1.0 / 1.604;

BulkDataStruct dataIn = new BulkDataStruct();

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

  wheelSpeedLbl.setFont(bigLabels);
  distLbl.setFont(bigLabels);
  totalPowerLbl.setFont(bigLabels);
  individualPowerLbl.setFont(regLabels);
  cadenceLbl.setFont(bigLabels);
  heartRateLbl.setFont(bigLabels);
  tempHumLbl.setFont(regLabels);
  c02Lbl.setFont(regLabels);
  brakeTempLbl.setFont(bigLabels);

  speedPlot = new GPlot(this);
  speedPlot.setPos(330, 20);
  speedPlot.setMar(10, 0, 0, 0);
  speedPlot.setDim(380, 160);
  speedPlot.setAxesOffset(4);
  speedPlot.setTicksLength(4);
  speedPlot.getYAxis().setAxisLabelText("Speed (mph)");

  powerPlot = new GPlot(this);
  powerPlot.setPos(330, 210);
  powerPlot.setMar(10, 0, 0, 0);
  powerPlot.setDim(380, 160);
  powerPlot.setAxesOffset(4);
  powerPlot.setTicksLength(4);
  powerPlot.getYAxis().setAxisLabelText("Total Power (W)");


  // List serial options
  String listOfSerials[] = Serial.list();
  //String serialLineName = listOfSerials[listOfSerials.length - 1];
  serialSelect.setItems(listOfSerials, 0);
  
  // Check for ideal serial line
  int idealIndex = -1;
  for (int i = 0; i < listOfSerials.length; i++) {
    if (idealSerialLine.equals(listOfSerials[i])) {
      idealIndex = i; // Record idex of ideal
      break;
    }
  }
  
  // If the ideal is found, act on it like if the start button is pressed
  if (idealIndex != -1) {
    bike.line = new Serial(this, idealSerialLine, BAUDRATE);
    requestData = true;
    serialSelect.setEnabled(false); //Disable the serial selector
    serialSelect.setSelected(idealIndex); // Put it to show the selected line
    runButton.setText("STOP");
    runButton.setLocalColorScheme(runButton.RED_SCHEME);
    delay(200); // Wait a bit before using the serial port
  }
  
  frameRate(frameRateSet);
}

public void draw() {

  background(230);

  if (frameCount % (frameRateSet / requestFreq) == 0) {
    long startTime = millis();
    
    // Serial requests, only if connected though
    if (bike.line != null) {
      
      if (!individualRequests) {
        dataIn.readBulkData(bike.line);
        
        FHR = dataIn.fhr;
        RHR = dataIn.rhr;
        cadenceFront = dataIn.fcad;
        cadenceRear = dataIn.rcad;
        powerFront = dataIn.fpwr;
        powerRear = dataIn.rpwr; 
  
        batt1 = dataIn.fBatt;
        batt2 = dataIn.rBatt;
        
        c02 = dataIn.CO2;
        brakeFront = dataIn.frontBrakeT;
        brakeRear = dataIn.rearBrakeT;
        
        humidity = dataIn.humid;
        temperature = dataIn.temp;
        
        distanceGPS = dataIn.gpsDist;
        speedGPS = dataIn.speedGPS;
        speedEncoder = dataIn.speedEncoder;
        rotations = dataIn.rotations;
      }
      else {
        
        //println("============================");
        FHR = int(bike.requestDataTwice('a'));
        RHR = int(bike.requestDataTwice('b'));
        cadenceFront = int(bike.requestDataTwice('c'));
        cadenceRear = int(bike.requestDataTwice('d'));
        powerFront = int(bike.requestDataTwice('e'));
        powerRear = int(bike.requestDataTwice('f')); 
  
        batt1 = int(bike.requestDataTwice('i'));
        batt2 = int(bike.requestDataTwice('j'));
        
        c02 = int(bike.requestDataTwice('k'));
        brakeFront = int(bike.requestDataTwice('w'));
        brakeRear = int(bike.requestDataTwice('x'));
        
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
  
        speedEncoder = float(bike.requestDataTwice('s'));
        rotations = int(bike.requestDataTwice('q'));
      }
      
      // Distance covered to distance remaining in miles
      distance = float(rotations) * WHEEL_CIRC / 1000.0; // Find distance travelled (km)
      distance = 5 - distance * KM_TO_MI;
      
      // Update all the rotating buffers
      while (speedBuffer.getNPoints() > graphWidth) speedBuffer.remove(0); // Remove all extra poiunts
      speedBuffer.add(requestCount, speedEncoder * KM_TO_MI);
      speedPlot.setPoints(speedBuffer);
  
      while (powerBufferFront.getNPoints() > graphWidth) powerBufferFront.remove(0);
      powerBufferFront.add(requestCount, powerFront);
      
      while (powerBufferRear.getNPoints() > graphWidth) powerBufferRear.remove(0);
      powerBufferRear.add(requestCount, powerRear);
      
      while (powerBufferTotal.getNPoints() > graphWidth) powerBufferTotal.remove(0);
      powerBufferTotal.add(requestCount, powerFront + powerRear);
      
      powerPlot.removeLayer("total");
      powerPlot.removeLayer("rear");
      powerPlot.removeLayer("front");
      
      powerPlot.addLayer("total", powerBufferTotal);
      powerPlot.getLayer("total").setLineColor(color(0, 0, 0));
      powerPlot.addLayer("rear", powerBufferRear);
      powerPlot.getLayer("rear").setLineColor(color(255, 0, 0));
      powerPlot.addLayer("front", powerBufferFront);
      powerPlot.getLayer("front").setLineColor(color(0, 0, 255));
  
      // Update the labels
      batt1Lbl.setText(str(batt1));
      batt2Lbl.setText(str(batt2));
      c02Lbl.setText(str(c02));
      distLbl.setText(str(distance));
      wheelSpeedLbl.setText(str(speedEncoder * KM_TO_MI));
      gpsSpeedLbl.setText(str(speedGPS * KM_TO_MI));
      kmhSpeedLbl.setText(str(speedEncoder) + " / " + str(speedGPS));
      totalPowerLbl.setText(str(powerFront + powerRear));
      individualPowerLbl.setText(str(powerFront) + " / " + str(powerRear));
      cadenceLbl.setText(str(cadenceFront) + " / " + str(cadenceRear));
      heartRateLbl.setText(str(FHR) + " / " + str(RHR));
      tempHumLbl.setText(str(temperature) + " / " + str(humidity) + "%");
      brakeTempLbl.setText(str(brakeFront) + " / " + str(brakeRear));
      gpsDistLbl.setText(str(distanceGPS * KM_TO_MI));
      
      // Derive ETAs to 0.1 second
      float ETAwheel = (distance / (speedEncoder / KM_TO_MI)) * 3600.0;
      float ETAgps = (distanceGPS / speedGPS) * 3600.0;
      ETAwheel = floor(ETAwheel * 10) / 10.0;
      ETAgps = floor(ETAgps * 10) / 10.0;
      
      // Zero them if their speed is 0 (ETA is infinity)
      if (speedEncoder == 0) ETAwheel = 0;
      if (speedGPS == 0) ETAgps = 0;
      
      ETALbl.setText(str(ETAwheel) + " / " + str(ETAgps));
  
      requestCount++; // Increase count
      
      long endTime = millis();
      
      
      print("Cycled in " + (endTime - startTime) + "ms, Current frame: " + requestCount);
      println(". Current frame rate is " + frameRate);
    }    
  }

  drawPlot(speedPlot);
  drawPlot(powerPlot);
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}
