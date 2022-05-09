import grafica.*;

import g4p_controls.*;
import processing.serial.*;

Serial arduino; // used to communicate to the arduino
int BAUDRATE = 115200;

char start = '[';
char ending = ']';
char separator = ';';

int loadCells = 6;

int digits = 10;
char[] buffer = new char[digits]; // buffer to read in data

boolean recordData = true;
Table table = new Table();
String csvName = "data/readings";
String calName = "data/calibration";

GPlot plot;
int nPointsPlot = 300;
String[] legends = new String[loadCells];
float[] legendsX = new float[loadCells];
float[] legendsY = new float[loadCells];
GPointsArray[] dataPoints = new GPointsArray[loadCells];

float[] raw = new float[loadCells];
float[] zero = new float[loadCells];
float[] scaling = new float[loadCells];
float[] output = new float[loadCells];

public void setup() {
  size(720, 480, JAVA2D);
  createGUI();
  customGUI();
  
  if (Serial.list().length == 0) {
    println("Can't connect to a port");
    System.exit(1);
  }
  
  ports.setItems(Serial.list(), 0);
  
  String portName = Serial.list()[0];
  arduino = new Serial(this, portName, BAUDRATE);
  
  plot = new GPlot(this);
  plot.setPos(20, 50);
  plot.setMar(0, 60, 0, 0);
  plot.setDim(620, 300);
  plot.setAxesOffset(4);
  plot.setTicksLength(4);
  plot.getYAxis().setAxisLabelText("Load Cell Readings");
  
  legends[0] = new String("Load Cell 1");
  legendsX[0] = 0.07;
  legendsY[0] = 0.92;
  dataPoints[0] = new GPointsArray(nPointsPlot);
  
  // Set colour
  colorMode(HSB, 60, 100, 100); 
  plot.setLineColor(color(0, 100, 100));
  colorMode(RGB, 255, 255, 255);

  for (int i = 1; i < loadCells; i++) {
    legends[i] = new String("Load Cell " + (i + 1));
    legendsX[i] = legendsX[0] + i * 0.15;
    legendsY[i] = legendsY[0];
    
    dataPoints[i] = new GPointsArray(nPointsPlot);
    plot.addLayer(legends[i], dataPoints[i]);
    
    // Switching the HSB colour to get colours evenly spaced through the colour spectrum
    colorMode(HSB, 60, 100, 100);
    plot.getLayer(legends[i]).setLineColor(color(i * 10, 100, 100));
    colorMode(RGB, 255, 255, 255);
  }
  
  lcList.setItems(legends, 0);
  
  plot.activatePointLabels();
  
  if (recordData) {
    csvName += "-" + getDateTime() + ".csv";
    for (int i = 1; i <= loadCells; i++) {
      table.addColumn("Raw LC" + i);
      table.addColumn("Zero LC" + i);
      table.addColumn("Scaling LC" + i);
      table.addColumn("Final LC" + i);
    }
  }
  
  for (int i = 0; i < loadCells; i++) {
    zero[i] = 0;
    scaling[i] = 1;
  }
}

public void draw() {
  background(230);
  
  // read one packet which consists of all the load cell readings e.g. [1;2;3;4;5;6]
  if (arduino.available() > 0) {
    while (arduino.readChar() != start) {
      // get to the start of the packet
    }
    
    for (int lc = 0; lc < loadCells - 1; lc++) {
      for (int i = 0; i < digits; i++) {
      
        while (arduino.available() == 0) {
          // Wait for data to come in if we run out of characters
          delay(10);
        }
        
        char current = arduino.readChar();
        if (current == separator) {
          for (int j = i; j < digits; j++) {
            buffer[j] = '\0';
          }
          break;
        } else {
          buffer[i] = current;
        }
      }
      
      if (buffer[digits - 1] != '\0') {
        while (arduino.readChar() != separator) {
          // get to the end of this data
        }
        buffer[digits - 1] = '\0';
      }
      
      raw[lc] = charToFloat(buffer);
      dataPoints[lc].add(frameCount, raw[lc]);
      if (frameCount > nPointsPlot) {
        dataPoints[lc].remove(0);
      }
    }
    
    // for the last load cell reading
    for (int i = 0; i < digits; i++) {
      char current = arduino.readChar();
      if (current == ending) {
        arduino.readChar(); // newline
        buffer[i] = '\0';
        break;
      } else {
        buffer[i] = current;
      }
    }
    
    raw[loadCells - 1] = charToFloat(buffer);
    dataPoints[loadCells - 1].add(frameCount, raw[loadCells - 1]);
    if (frameCount > nPointsPlot) {
      dataPoints[loadCells - 1].remove(0);
    }
    
    String displayText = "";
    
    for (int i = 0; i < loadCells; i++) {
      output[i] = (raw[i] - zero[i]) / scaling[i];
      displayText += legends[i] + ":   Raw " + nfs(raw[i], 5, 2) 
                                + "    Zero " + nfs(zero[i], 2, 1) 
                                + "    Scaling " + nfs(scaling[i], 2, 1)
                                + "    Final " + nfs(output[i], 5, 2) + "\n";
      readings.setText(displayText);
    }
        
    if (recordData) {
      TableRow newRow = table.addRow();
      
      for (int i = 0; i < loadCells; i++) {
        newRow.setFloat("Raw LC" + (i + 1), raw[i]);
        newRow.setFloat("Zero LC" + (i + 1), zero[i]);
        newRow.setFloat("Scaling LC" + (i + 1), scaling[i]);
        newRow.setFloat("Final LC" + (i + 1), output[i]);
      }
      
      try {
        saveTable(table, csvName);
      } catch (Exception e) {
        println("Error saving data to " + csvName);
      }
    }
  }
  
  plot.setPoints(dataPoints[0]);
  
  for(int i = 1; i < loadCells; i++) {
    plot.getLayer(legends[i]).setPoints(dataPoints[i]);
  }
    
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawYAxis();
  plot.drawTitle();
  
  plot.drawLines();
  for(int i = 1; i < loadCells; i++) {
    plot.getLayer(legends[i]).drawLines();
  }
  
  plot.drawLegend(legends, legendsX, legendsY);
  
  plot.endDraw();
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
  zeroInput.setNumericType(G4P.DECIMAL);
  scaleInput.setNumericType(G4P.DECIMAL);
}

String getDateTime() {
  return String.format("%4d%02d%02d-%02d%02d%02d", year(), month(), day(), hour(), minute(), second());
}

float charToFloat(char[] input) {
  // Take in a character array and convert it to a float number that is returned
  String temp = new String(input);
  float x = float(temp);
  return x;
}
