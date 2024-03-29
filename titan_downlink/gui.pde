/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void exitBtn_click(GButton source, GEvent event) { //_CODE_:exitBtn:797162:
  //println("exitBtn - GButton >> GEvent." + event + " @ " + millis());
  
  endComms();
  exit();
} //_CODE_:exitBtn:797162:

public void serialSelectClick(GDropList source, GEvent event) { //_CODE_:serialSelect:680077:
  //println("dropList1 - GDropList >> GEvent." + event + " @ " + millis());
  // List serial options, but not after selection
  if (event != GEvent.SELECTED ) serialSelect.setItems(Serial.list(), 0);
} //_CODE_:serialSelect:680077:

public void runButtonClick(GButton source, GEvent event) { //_CODE_:runButton:452403:
  if (requestData == false) {
    // Start sending data because we weren't
    telemetryLine = new Serial(this, serialSelect.getSelectedText(), BAUDRATE);
    requestData = true;
    serialSelect.setEnabled(false); //Disable the serial selector
    runButton.setText("STOP");
    runButton.setLocalColorScheme(runButton.RED_SCHEME);
    delay(2000); // Wait a bit before using the serial port
  }
  else {
    // Stop sending data, free serial line
    endComms();
    serialSelect.setEnabled(true); //Disable the serial selector
    runButton.setText("Start");
    runButton.setLocalColorScheme(runButton.GREEN_SCHEME);
  }
} //_CODE_:runButton:452403:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  G4P.setDisplayFont("Arial", G4P.PLAIN, 16);
  surface.setTitle("Telemetry UI");
  label1 = new GLabel(this, 0, 10, 110, 40);
  label1.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label1.setText("Speed:");
  label1.setOpaque(false);
  label2 = new GLabel(this, 140, 450, 80, 20);
  label2.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label2.setText("Batt. 2:");
  label2.setOpaque(false);
  label3 = new GLabel(this, 140, 430, 80, 20);
  label3.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label3.setText("Batt. 1:");
  label3.setOpaque(false);
  label4 = new GLabel(this, 0, 90, 110, 40);
  label4.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label4.setText("Dist. Rem.:");
  label4.setOpaque(false);
  label5 = new GLabel(this, 0, 220, 110, 40);
  label5.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label5.setText("Power (W):");
  label5.setOpaque(false);
  label6 = new GLabel(this, 0, 280, 110, 40);
  label6.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label6.setText("Cadence (RPM):");
  label6.setOpaque(false);
  label7 = new GLabel(this, 0, 320, 110, 40);
  label7.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label7.setText("Heart Rate (BPM):");
  label7.setOpaque(false);
  label8 = new GLabel(this, 310, 390, 130, 20);
  label8.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label8.setText("Temp. / Hum.:");
  label8.setOpaque(false);
  exitBtn = new GButton(this, 10, 430, 120, 40);
  exitBtn.setText("Exit");
  exitBtn.setLocalColorScheme(GCScheme.RED_SCHEME);
  exitBtn.addEventHandler(this, "exitBtn_click");
  batt1Lbl = new GLabel(this, 220, 430, 80, 20);
  batt1Lbl.setText("batt1lvl");
  batt1Lbl.setOpaque(false);
  batt2Lbl = new GLabel(this, 220, 450, 80, 20);
  batt2Lbl.setText("batt2lvl");
  batt2Lbl.setOpaque(false);
  distLbl = new GLabel(this, 110, 90, 190, 40);
  distLbl.setText("distance");
  distLbl.setOpaque(false);
  wheelSpeedLbl = new GLabel(this, 110, 10, 190, 40);
  wheelSpeedLbl.setText("wheel speed");
  wheelSpeedLbl.setOpaque(false);
  totalPowerLbl = new GLabel(this, 110, 220, 190, 40);
  totalPowerLbl.setText("total power");
  totalPowerLbl.setOpaque(false);
  cadenceLbl = new GLabel(this, 110, 280, 190, 40);
  cadenceLbl.setText("cadence");
  cadenceLbl.setOpaque(false);
  heartRateLbl = new GLabel(this, 110, 320, 190, 40);
  heartRateLbl.setText("heart rate");
  heartRateLbl.setOpaque(false);
  tempHumLbl = new GLabel(this, 440, 390, 270, 20);
  tempHumLbl.setText("temp/hum");
  tempHumLbl.setOpaque(false);
  serialSelect = new GDropList(this, 140, 400, 160, 80, 3, 10);
  serialSelect.setItems(loadStrings("list_680077"), 0);
  serialSelect.addEventHandler(this, "serialSelectClick");
  runButton = new GButton(this, 10, 400, 120, 20);
  runButton.setText("Start");
  runButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  runButton.addEventHandler(this, "runButtonClick");
  label9 = new GLabel(this, 310, 410, 130, 20);
  label9.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label9.setText("CO2:");
  label9.setOpaque(false);
  label10 = new GLabel(this, 310, 430, 130, 40);
  label10.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label10.setText("Brake Temp.:");
  label10.setOpaque(false);
  c02Lbl = new GLabel(this, 440, 410, 270, 20);
  c02Lbl.setText("CO2");
  c02Lbl.setOpaque(false);
  brakeTempLbl = new GLabel(this, 440, 430, 270, 40);
  brakeTempLbl.setText("brake");
  brakeTempLbl.setOpaque(false);
  label11 = new GLabel(this, 0, 50, 110, 20);
  label11.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label11.setText("GPS Speed:");
  label11.setOpaque(false);
  label12 = new GLabel(this, 0, 70, 110, 20);
  label12.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label12.setText("E/G km/h:");
  label12.setOpaque(false);
  gpsSpeedLbl = new GLabel(this, 110, 50, 190, 20);
  gpsSpeedLbl.setText("gps speed");
  gpsSpeedLbl.setOpaque(false);
  kmhSpeedLbl = new GLabel(this, 110, 70, 190, 20);
  kmhSpeedLbl.setText("km/h speeds");
  kmhSpeedLbl.setOpaque(false);
  label13 = new GLabel(this, 0, 260, 110, 20);
  label13.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label13.setText("Ind. Pwr.:");
  label13.setOpaque(false);
  individualPowerLbl = new GLabel(this, 110, 260, 190, 20);
  individualPowerLbl.setText("individual power");
  individualPowerLbl.setOpaque(false);
  label14 = new GLabel(this, 0, 130, 110, 20);
  label14.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label14.setText("D. R. GPS:");
  label14.setOpaque(false);
  gpsDistLbl = new GLabel(this, 110, 130, 190, 20);
  gpsDistLbl.setText("gps distance");
  gpsDistLbl.setOpaque(false);
  label15 = new GLabel(this, 0, 150, 110, 20);
  label15.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label15.setText("ETA:");
  label15.setOpaque(false);
  ETALbl = new GLabel(this, 110, 150, 190, 20);
  ETALbl.setText("ETA times");
  ETALbl.setOpaque(false);
  connectionLbl = new GLabel(this, 0, 170, 300, 50);
  connectionLbl.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  connectionLbl.setText("CONNECTION LOST");
  connectionLbl.setLocalColorScheme(GCScheme.RED_SCHEME);
  connectionLbl.setOpaque(false);
}

// Variable declarations 
// autogenerated do not edit
GLabel label1; 
GLabel label2; 
GLabel label3; 
GLabel label4; 
GLabel label5; 
GLabel label6; 
GLabel label7; 
GLabel label8; 
GButton exitBtn; 
GLabel batt1Lbl; 
GLabel batt2Lbl; 
GLabel distLbl; 
GLabel wheelSpeedLbl; 
GLabel totalPowerLbl; 
GLabel cadenceLbl; 
GLabel heartRateLbl; 
GLabel tempHumLbl; 
GDropList serialSelect; 
GButton runButton; 
GLabel label9; 
GLabel label10; 
GLabel c02Lbl; 
GLabel brakeTempLbl; 
GLabel label11; 
GLabel label12; 
GLabel gpsSpeedLbl; 
GLabel kmhSpeedLbl; 
GLabel label13; 
GLabel individualPowerLbl; 
GLabel label14; 
GLabel gpsDistLbl; 
GLabel label15; 
GLabel ETALbl; 
GLabel connectionLbl; 