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

public void lcList_click(GDropList source, GEvent event) { //_CODE_:lcList:910021:
  int index = source.getSelectedIndex();
  zeroInput.setText(nf(zero[index]));
  scaleInput.setText(nf(scaling[index]));
} //_CODE_:lcList:910021:

public void textfield1_change1(GTextField source, GEvent event) { //_CODE_:zeroInput:673497:
  //println("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:zeroInput:673497:

public void textfield1_change2(GTextField source, GEvent event) { //_CODE_:scaleInput:452314:
  //println("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:scaleInput:452314:

public void calibrate_click(GButton source, GEvent event) { //_CODE_:calibrate:272350:
  int index = lcList.getSelectedIndex();
  zero[index] = zeroInput.getValueF();
  scaling[index] = scaleInput.getValueF();
} //_CODE_:calibrate:272350:

public void export_click(GButton source, GEvent event) { //_CODE_:export:477455:
  Table calTable = new Table();
  calTable.addColumn("LC");
  calTable.addColumn("Zero");
  calTable.addColumn("Scaling");
  for (int i = 0; i < loadCells; i++) {
      TableRow newRow = calTable.addRow();
      newRow.setString("LC", legends[i]);
      newRow.setFloat("Zero", zero[i]);
      newRow.setFloat("Scaling", scaling[i]);
  }
  
  String calFName = calName + "-" + getDateTime() + ".csv";
  try {
    saveTable(calTable, calFName);
    G4P.showMessage(this, "Calibration file exported as " + calFName, 
                    "Export Calibration", G4P.INFO_MESSAGE);
  } catch (Exception e) {
    G4P.showMessage(this, "Unable to export calibration file", 
                    "Error", G4P.ERROR_MESSAGE);
  }
} //_CODE_:export:477455:

public void load_click(GButton source, GEvent event) { //_CODE_:load:866453:
  String fname = G4P.selectInput("Select File");
  
  if (fname == null) {
    return;
  }
  
  try {
    Table table = loadTable(fname, "header");
    if (table.getRowCount() != loadCells) {
      G4P.showMessage(this, "Calibration file does not have " + loadCells + " rows (excluding header)", 
                      "Error", G4P.ERROR_MESSAGE);
      return;
    }
    for (int i = 0; i < loadCells; i++) {
      TableRow row = table.getRow(i);
      
      String name = row.getString("LC");
      if (!name.equals(legends[i])) {
        G4P.showMessage(this, "Cannot match load cell: " + name, 
                        "Error", G4P.ERROR_MESSAGE);
        return;
      }
      
      zero[i] = row.getFloat("Zero");
      scaling[i] = row.getFloat("Scaling");
    }
    
    G4P.showMessage(this, "Calibration file loaded!", 
                    "Load Calibration File", G4P.INFO_MESSAGE);
  } catch (Exception e) {
    G4P.showMessage(this, "Unable to load calibration file", 
                    "Error", G4P.ERROR_MESSAGE);
  }
} //_CODE_:load:866453:

public void textarea1_change1(GTextArea source, GEvent event) { //_CODE_:readings:231265:
  println("textarea1 - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:readings:231265:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  lcList = new GDropList(this, 20, 15, 90, 80, 3, 10);
  lcList.setItems(loadStrings("list_910021"), 0);
  lcList.addEventHandler(this, "lcList_click");
  label2 = new GLabel(this, 120, 15, 60, 20);
  label2.setText("Zero");
  label2.setOpaque(false);
  zeroInput = new GTextField(this, 150, 15, 120, 20, G4P.SCROLLBARS_NONE);
  zeroInput.setOpaque(true);
  zeroInput.addEventHandler(this, "textfield1_change1");
  label3 = new GLabel(this, 270, 14, 60, 20);
  label3.setText("Scale");
  label3.setOpaque(false);
  scaleInput = new GTextField(this, 310, 15, 120, 20, G4P.SCROLLBARS_NONE);
  scaleInput.setOpaque(true);
  scaleInput.addEventHandler(this, "textfield1_change2");
  calibrate = new GButton(this, 440, 15, 80, 20);
  calibrate.setText("Calibrate");
  calibrate.addEventHandler(this, "calibrate_click");
  export = new GButton(this, 620, 15, 80, 20);
  export.setText("Export Cal");
  export.addEventHandler(this, "export_click");
  load = new GButton(this, 530, 15, 80, 20);
  load.setText("Load Cal");
  load.addEventHandler(this, "load_click");
  readings = new GTextArea(this, 15, 360, 690, 100, G4P.SCROLLBARS_NONE);
  readings.setOpaque(true);
  readings.addEventHandler(this, "textarea1_change1");
}

// Variable declarations 
// autogenerated do not edit
GDropList lcList; 
GLabel label2; 
GTextField zeroInput; 
GLabel label3; 
GTextField scaleInput; 
GButton calibrate; 
GButton export; 
GButton load; 
GTextArea readings; 
