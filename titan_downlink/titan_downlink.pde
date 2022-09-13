import grafica.*;

String idealSerialLine = "/dev/serial0"; // Ideal line, if present connected to automatically
// 'serial0' is the hardware serial on the RPi
boolean individualRequests = false;

// Need G4P library
import g4p_controls.*;
import java.awt.Font;
java.awt.Font regLabels = new java.awt.Font("SansSerif", java.awt.Font.PLAIN, 16);
java.awt.Font bigLabels = new java.awt.Font("SansSerif", java.awt.Font.PLAIN, 30);

// Communication related stuff
import processing.serial.*;
Serial telemetryLine; // Used to communicate to and from the bike
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
float distance = 0.0; // Distance remaining in km
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
  fullScreen();
  //size(720, 480, JAVA2D);
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
  connectionLbl.setFont(bigLabels);

  speedPlot = new GPlot(this);
  speedPlot.setPos(330, 20);
  speedPlot.setMar(10, 0, 0, 0);
  speedPlot.setDim(450, 160);
  speedPlot.setAxesOffset(4);
  speedPlot.setTicksLength(4);
  speedPlot.getYAxis().setAxisLabelText("Speed (mph)");

  powerPlot = new GPlot(this);
  powerPlot.setPos(330, 210);
  powerPlot.setMar(10, 0, 0, 0);
  powerPlot.setDim(450, 160);
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
    telemetryLine = new Serial(this, idealSerialLine, BAUDRATE);
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
    
    // Update data, only if connected though
    if (telemetryLine != null) {
      
      boolean recievedData = dataIn.readBulkData(telemetryLine);
      
      connectionLbl.setVisible(!recievedData);
      
      if (recievedData == true) {
        // Distance covered to distance remaining in miles
        distance = float(dataIn.rotations) * WHEEL_CIRC / 1000.0; // Find distance travelled (km)
        distance = 5 - distance * KM_TO_MI;
        
        // Update all the rotating buffers
        while (speedBuffer.getNPoints() > graphWidth) speedBuffer.remove(0); // Remove all extra poiunts
        speedBuffer.add(requestCount, dataIn.speedEncoder * KM_TO_MI);
        speedPlot.setPoints(speedBuffer);
    
        while (powerBufferFront.getNPoints() > graphWidth) powerBufferFront.remove(0);
        powerBufferFront.add(requestCount, dataIn.fpwr);
        
        while (powerBufferRear.getNPoints() > graphWidth) powerBufferRear.remove(0);
        powerBufferRear.add(requestCount, dataIn.rpwr);
        
        while (powerBufferTotal.getNPoints() > graphWidth) powerBufferTotal.remove(0);
        powerBufferTotal.add(requestCount, dataIn.fpwr + dataIn.rpwr);
        
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
        batt1Lbl.setText(str(dataIn.fBatt));
        batt2Lbl.setText(str(dataIn.rBatt));
        c02Lbl.setText(str(dataIn.CO2));
        distLbl.setText(str(distance));
        wheelSpeedLbl.setText(str(dataIn.speedEncoder * KM_TO_MI));
        gpsSpeedLbl.setText(str(dataIn.speedGPS * KM_TO_MI));
        kmhSpeedLbl.setText(str(dataIn.speedEncoder) + " / " + str(dataIn.speedGPS));
        totalPowerLbl.setText(str(dataIn.fpwr + dataIn.rpwr));
        individualPowerLbl.setText(str(dataIn.fpwr) + " / " + str(dataIn.rpwr));
        cadenceLbl.setText(str(dataIn.fcad) + " / " + str(dataIn.rcad));
        heartRateLbl.setText(str(dataIn.fhr) + " / " + str(dataIn.rhr));
        tempHumLbl.setText(str(dataIn.temp) + " / " + str(dataIn.humid) + "%");
        brakeTempLbl.setText(str(dataIn.frontBrakeT) + " / " + str(dataIn.rearBrakeT));
        gpsDistLbl.setText(str(dataIn.gpsDist * KM_TO_MI));
        
        // Derive ETAs to 0.1 second
        float ETAwheel = (distance / (dataIn.speedEncoder / KM_TO_MI)) * 3600.0;
        float ETAgps = (dataIn.gpsDist / dataIn.speedGPS) * 3600.0;
        ETAwheel = floor(ETAwheel * 10) / 10.0;
        ETAgps = floor(ETAgps * 10) / 10.0;
        
        // Zero them if their speed is 0 (ETA is infinity)
        if (dataIn.speedEncoder == 0) ETAwheel = 0;
        if (dataIn.speedGPS == 0) ETAgps = 0;
        
        ETALbl.setText(str(ETAwheel) + " / " + str(ETAgps));
      }
      
      requestCount++; // Increase count
      long endTime = millis();
      print("Cycled in " + (endTime - startTime) + "ms, Current frame: " + requestCount);
      println(". Current frame rate is " + frameRate);
    }    
  }

  drawPlot(speedPlot);
  drawPlot(powerPlot);
}

void endComms() {
  // Shut down serial communications properly
  if (telemetryLine != null) telemetryLine.stop(); // Close data line
  telemetryLine = null;
  requestData = false;
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}