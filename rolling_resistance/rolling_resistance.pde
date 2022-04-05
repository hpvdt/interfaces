import grafica.*;

// Need G4P library
import g4p_controls.*;
import processing.serial.*;

Serial arduino; // Used to communicate to the arduino
int BAUDRATE = 9600;

char wheelMark = 'w';    // Mark before the wheel's rot. speed
char baseMark = 'r';     // Mark before the base rollers speed
char endMark = '\n';     // Mark of the end of a message

boolean recordData = false; // Enters loop to record data
char[] buffer = new char[10]; // 10 character buffer for speeds

float BASECIRC = 5.1; // Circumference of base wheel
float baseRot = 0.0;
float wheelCirc = 0.0;
float wheelRot = 0.0;

PrintWriter output; // Used for writting data log

GPlot speedPlot;
GPointsArray speedBuffer = new GPointsArray(500);

public void setup() {
  size(720, 480, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here

  start_btn.setVisible(false);
  stop_btn.setVisible(false);
  serial_list.setItems(Serial.list(), 0);
  
  speedPlot = new GPlot(this);
  speedPlot.setPos(20,60);
  speedPlot.setMar(0,60,0,0);
  speedPlot.setDim(620, 300);
  speedPlot.setAxesOffset(4);
  speedPlot.setTicksLength(4);
  speedPlot.getYAxis().setAxisLabelText("Speed (km/h)");
}

public void draw() {
  background(230);
  
  // Record data if we are meant to and there is an update available
  if (recordData && (arduino.available() > 0)) {
    while (arduino.readChar() != baseMark) {
      // Get to the start of a message
    }

    // Read in the base speed
    int i = 0;
    while (i < 10) {
      buffer[i] = arduino.readChar(); // Reads in value

      // Exits when the wheel speed is encountered
      if (buffer[i] == wheelMark) {
        buffer[i+1] = '\0';

        baseRot = charToFloat(buffer); // Stores the rotational speed
        break;
      }
      i++;
    }
    i = 0;

    // Read in wheel speed
    while (i < 10) {
      buffer[i] = arduino.readChar(); // Reads in value

      // Exits when the end of a message is read
      if (buffer[i] == endMark) {
        buffer[i+1] = '\0';

        wheelRot = charToFloat(buffer); // Stores the rotational speed
        break;
      }
      i++;
    }

    // Initial pass
    if (wheelCirc == 0.0) {
      // Finds the wheel circumference based on rotational speed.
      wheelCirc = BASECIRC * baseRot / wheelRot;
      output.println("Determined wheel circumference: " + wheelCirc); // Starts log file with circumference
      // Writes headers for columns
      output.println("Time (s)" + "," + "Base Speed" + "," + "Wheel Speed");
    }
    
    // Records 
    output.println((millis()/1000) + "," + baseRot + "," + wheelRot); 
  }
  
  if (frameCount > 500) speedBuffer.remove(0);
  speedBuffer.add(frameCount, 15 + 10*noise(frameCount * 0.05));
  speedPlot.setPoints(speedBuffer);
  
  speedPlot.beginDraw();
  speedPlot.drawBox();
  speedPlot.drawYAxis();
  speedPlot.drawTitle();
  speedPlot.drawLines();
  speedPlot.endDraw();
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}

float charToFloat(char[] input) {
  // Take in a character array and convert it to a float number that is returned
  String temp = new String(input);
  float x = float(temp);
  return x;
}
