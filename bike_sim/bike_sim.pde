// Need G4P library
import g4p_controls.*;
import processing.serial.*;
comms target = new comms(); // Target system
int BAUDRATE = 115200;
boolean sendData = false; // Are we sending data

// Bike variables
float speed = 0;
float distance = 0;
int rotations = 0; // Used to store the number of rotations the distance is equivalent to
int cadence = 0;
int heartRate = 0;
int power = 0;
int battery = 0;

float circ = 2.104; // Circumference of wheel in (m)


public void setup() {
  size(550, 310, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here

  // List serial options
  serialSelect.setItems(Serial.list(), 0);

  circLabel.setText("Wheel circumference is " + circ + "m."); // State circumference used
}

public void draw() {
  background(230);

  if (sendData == true) {
    // If we're sending data
    if ((frameCount % (frameRate/2)) <= 2) {
      // Send the data once a second, no need to spam the bike.
      // ANT+ derived values are only updated at around 1Hz in reality anyways

      target.sendData('A', heartRate);
      target.sendData('C', cadence);
      target.sendData('E', power);
      target.sendData('I', battery);
      target.sendData('S', speed);
      target.sendData('Q', rotations);
    }
  }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}

class comms {
  Serial line = null;
  int timeout = 10; // Timeout for data (ms)

  void sendData(char type, String data) {
    char lengthChar = char(data.length() + 31); // Prepares the length character

    data = type + lengthChar + data; // Makes the message

    line.write(data); // Send the data out on the line
  }

  void sendData(char type, int data) {
    String temp = str(data);
    char lengthChar = char(temp.length() + 31); // Prepares the length character

    temp = str(type) + str(lengthChar) + temp; // Makes the message

    line.write(temp); // Send the data out on the line
  }
  void sendData(char type, float data) {
    String temp = str(data);
    char lengthChar = char(temp.length() + 31); // Prepares the length character

    temp = str(type) + str(lengthChar) + temp; // Makes the message

    line.write(temp); // Send the data out on the line
  }

  String requestData(char type) {
    line.clear(); // Clears lines of anything that came before

    line.write(type); // Sends request

    // Waits and get the data length
    int endTime = millis() + timeout; // Used to mark when to timeout
    while (line.available() == 0) {
      if (millis() > endTime) return ""; // Timeout
    }

    int lengthData = int(line.readChar() - 31); // Gets the length of the message

    // Wait until the whole message is recieved
    endTime = millis() + timeout;
    while (line.available() < lengthData) {
      if (millis() > endTime) return ""; // Timeout
    }

    String output = new String(char(line.readBytes(lengthData))); // Read in data
    return output;
  }

  void endComms() {
    line.stop(); // Close data line
    line = null;
  }
}
