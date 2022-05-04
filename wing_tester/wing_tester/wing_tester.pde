import grafica.*;

import g4p_controls.*;
import processing.serial.*;

Serial arduino; // used to communicate to the arduino
int BAUDRATE = 9600;

char start = '[';
char ending = ']';
char separator = ';';

boolean recordData = false;

int digits = 10;
char[] buffer = new char[digits]; // buffer to read in data

PrintWriter output; // to write data log

GPlot plot;
int nPointsPlot = 500;
int loadCells = 6;
GPointsArray[] dataPoints = new GPointsArray[loadCells];

public void setup() {
  if (Serial.list().length == 0) {
    println("Can't connect to a port");
    System.exit(1);
  }
  
  String portName = Serial.list()[0];
  arduino = new Serial(this, portName, BAUDRATE);
  
  size(720, 480, JAVA2D);
  
  plot = new GPlot(this);
  plot.setPos(20, 60);
  plot.setMar(0, 60, 0, 0);
  plot.setDim(620, 300);
  plot.setAxesOffset(4);
  plot.setTicksLength(4);
  plot.getYAxis().setAxisLabelText("Load Cell Readings");

  for(int i = 0; i < loadCells; i++) {
    dataPoints[i] = new GPointsArray(nPointsPlot);
    plot.addLayer("Load Cell " + str(i + 1), dataPoints[i]);
    plot.getLayer("Load Cell " + str(i + 1)).setLineColor(color(i * 40, i * 40, 255));
  }
  
}

public void draw() {
  background(230);
  
  // read one packet
  if (arduino.available() > 0) {
    while (arduino.readChar() != start) {
      // get to the start of the packet
    }
    
    for (int lc = 0; lc < loadCells - 1; lc++) {
      for (int i = 0; i < digits; i++) {
        char current = arduino.readChar();
        if (current == separator) {
          buffer[i] = '\0';
          break;
        } else {
          buffer[i] = current;
        }
      }
      
      float reading = charToFloat(buffer);
      dataPoints[lc].add(15 + 10 * frameCount, reading);
      if (frameCount > nPointsPlot) {
        dataPoints[lc].remove(0);
      }
    }
    
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
    
    float reading = charToFloat(buffer);
    dataPoints[loadCells - 1].add(15 + 10 * frameCount, reading);
    if (frameCount > nPointsPlot) {
      dataPoints[loadCells - 1].remove(0);
    }
  }
  
  plot.setPoints(new GPointsArray());
  
  for(int i = 1; i < loadCells; i++) {
    plot.getLayer("Load Cell " + str(i)).setPoints(dataPoints[i]);
  }
  
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTopAxis();
  plot.drawRightAxis();
  plot.drawTitle();
  
  for(int i = 1; i < loadCells; i++) {
    plot.getLayer("Load Cell " + str(i)).drawPoints();
    plot.getLayer("Load Cell " + str(i)).drawLines();
  }
  
  plot.endDraw();

}

float charToFloat(char[] input) {
  // Take in a character array and convert it to a float number that is returned
  String temp = new String(input);
  float x = float(temp);
  return x;
}
