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
  bike.endComms();
  exit();
} //_CODE_:exitBtn:797162:

public void serialSelectClick(GDropList source, GEvent event) { //_CODE_:serialSelect:680077:
  //println("dropList1 - GDropList >> GEvent." + event + " @ " + millis());
  // List serial options, but not after selection
  if (event != GEvent.SELECTED ) serialSelect.setItems(Serial.list(), 0);
} //_CODE_:serialSelect:680077:

public void runButtonClick(GButton source, GEvent event) { //_CODE_:runButton:452403:
    if (requestData == false) {
    // Start sending data becausew we weren't
    bike.line = new Serial(this, serialSelect.getSelectedText(), BAUDRATE);
    requestData = true;
    serialSelect.setEnabled(false); //Disable the serial selector
    runButton.setText("STOP");
    runButton.setLocalColorScheme(runButton.RED_SCHEME);
    delay(5000); // Wait for four seconds before using the serial port
  }
  else {
    // Stop sending data, free serial line
    requestData = false;
    bike.endComms();
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
  label1 = new GLabel(this, 0, 20, 110, 40);
  label1.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label1.setText("Speed:");
  label1.setOpaque(false);
  label2 = new GLabel(this, 140, 450, 80, 20);
  label2.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label2.setText("Battery 2:");
  label2.setOpaque(false);
  label3 = new GLabel(this, 140, 430, 80, 20);
  label3.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label3.setText("Battery 1:");
  label3.setOpaque(false);
  label4 = new GLabel(this, 0, 60, 110, 40);
  label4.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label4.setText("Distance:");
  label4.setOpaque(false);
  label5 = new GLabel(this, 0, 180, 110, 40);
  label5.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label5.setText("Power (W):");
  label5.setOpaque(false);
  label6 = new GLabel(this, 0, 220, 110, 40);
  label6.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label6.setText("Cadence (RPM):");
  label6.setOpaque(false);
  label7 = new GLabel(this, 0, 340, 110, 40);
  label7.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label7.setText("Heart Rate (BPM):");
  label7.setOpaque(false);
  label8 = new GLabel(this, 0, 280, 110, 40);
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
  distLbl = new GLabel(this, 110, 60, 190, 40);
  distLbl.setText("distance");
  distLbl.setOpaque(false);
  speedLbl = new GLabel(this, 110, 20, 190, 40);
  speedLbl.setText("speed");
  speedLbl.setOpaque(false);
  powerLbl = new GLabel(this, 110, 180, 190, 40);
  powerLbl.setText("power");
  powerLbl.setOpaque(false);
  cadenceLbl = new GLabel(this, 110, 220, 190, 40);
  cadenceLbl.setText("cadence");
  cadenceLbl.setOpaque(false);
  heartRateLbl = new GLabel(this, 110, 340, 190, 40);
  heartRateLbl.setText("heart rate");
  heartRateLbl.setOpaque(false);
  tempHumLbl = new GLabel(this, 110, 280, 190, 40);
  tempHumLbl.setText("temp/hum");
  tempHumLbl.setOpaque(false);
  serialSelect = new GDropList(this, 140, 400, 120, 80, 3, 10);
  serialSelect.setItems(loadStrings("list_680077"), 0);
  serialSelect.addEventHandler(this, "serialSelectClick");
  runButton = new GButton(this, 10, 400, 120, 20);
  runButton.setText("Start");
  runButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  runButton.addEventHandler(this, "runButtonClick");
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
GLabel speedLbl; 
GLabel powerLbl; 
GLabel cadenceLbl; 
GLabel heartRateLbl; 
GLabel tempHumLbl; 
GDropList serialSelect; 
GButton runButton; 
