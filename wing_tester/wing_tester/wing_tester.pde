import grafica.*;

import g4p_controls.*;
import processing.serial.*;

Serial arduino; // used to communicate to the arduino
int BAUDRATE = 9600;

char start = '[';
char ending = ']';
char separator = ';';

int digits = 10;
char[] buffer = new char[digits]; // buffer to read in data

boolean recordData = false;
PrintWriter output = createWriter("data.csv"); // to write data log

GPlot plot;
int nPointsPlot = 500;
int loadCells = 6;
String[] legends = new String[loadCells];
float[] legendsX = new float[loadCells];
float[] legendsY = new float[loadCells];
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
  
  legends[0] = new String("Load Cell 1");
  legendsX[0] = 0.07;
  legendsY[0] = 0.92;
  dataPoints[0] = new GPointsArray(nPointsPlot);
  plot.setLineColor(color(random(255), random(255), random(255)));

  for (int i = 1; i < loadCells; i++) {
    legends[i] = new String("Load Cell " + str(i + 1));
    legendsX[i] = legendsX[0] + i * 0.15;
    legendsY[i] = legendsY[0];
    
    dataPoints[i] = new GPointsArray(nPointsPlot);
    plot.addLayer(legends[i], dataPoints[i]);
    plot.getLayer(legends[i]).setLineColor(color(random(255), random(255), random(255)));
  }
  
  plot.activatePointLabels();
  
  output.println("Test");
  output.flush();
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
          for (int j = i; j < digits; j++) {
            buffer[j] = '\0';
          }
          break;
        } else {
          buffer[i] = current;
        }
      }
      
      float reading = charToFloat(buffer);
      dataPoints[lc].add(frameCount, reading);
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
    dataPoints[loadCells - 1].add(frameCount, reading);
    if (frameCount > nPointsPlot) {
      dataPoints[loadCells - 1].remove(0);
    }
  }
  
  plot.setPoints(dataPoints[0]);
  
  for(int i = 1; i < loadCells; i++) {
    plot.getLayer(legends[i]).setPoints(dataPoints[i]);
  }
    
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTopAxis();
  plot.drawRightAxis();
  plot.drawTitle();
  
  plot.drawLines();
  for(int i = 1; i < loadCells; i++) {
    plot.getLayer(legends[i]).drawLines();
  }
  
  plot.drawLegend(legends, legendsX, legendsY);
  
  plot.endDraw();

}

float charToFloat(char[] input) {
  // Take in a character array and convert it to a float number that is returned
  String temp = new String(input);
  float x = float(temp);
  return x;
}
