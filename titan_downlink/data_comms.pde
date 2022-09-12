  /* Gets in a value for which line to process, then processes it.
  Requests characters are lowercase, setting is uppercase

  a - Heart rate (front) (BPM)
  b - Heart rate (rear) (BPM)
  c - Cadence (front) (RPM)
  d - Cadence (rear) (RPM)
  e - Power (front) (W)
  f - Power (rear) (W)
  g - All ANT data (delimited, in order a-f)

  i - Front battery %
  j - Rear battery %

  h - Humidity (R.H.%)
  t - Temperature (C * 2 + 50)
  k - CO2 (ppm)

  s - Speed (km/h)
  q - Distance (number of rotations)

  l - Latitude (degrees)
  m - Longitude (degrees)
  n - Altitude (m)
  o - GPS speed (km/h)
  p - GPS distance (km)
  u - Starting longitude
  v - Starting latitude

  w - Front brake temperature (C)
  x - Rear brake temperature (C)

  y - Testing byte
  z - Testing byte
  */

class comms {
  Serial line = null;
  int timeout = 1000; // Timeout for data (ms)

  void sendData(char type, String data) {
    char lengthChar = char(data.length() + 31); // Prepares the length character

    data = type + lengthChar + data; // Makes the message

    line.write(data); // Send the data out on the line
  }
   
   String requestDataTwice(char type) {
     requestData(type);
     return requestData(type);
   }
  String requestData(char type) {
    line.clear(); // Clears lines of anything that came before
    
    line.write(type); // Sends request
    
    /*
    print("Requesting data: ");
    println(type);
    delay(50);
    
    print("Recieved: ");
    while (line.available() > 0) {
      print(char(line.read()));
    }
    println("");
    
    return "0";
    */
    
    // Waits and get the data length
    int endTime = millis() + timeout; // Used to mark when to timeout
    while (line.available() == 0) {
      if (millis() > endTime) {
        println("Request timed out.");
        return ""; // Timeout
      }
      delay(2);
    }

    int lengthData = line.read() - 31; // Gets the length of the message
    
    // Wait until the whole message is recieved
    endTime = millis() + timeout;
    while (line.available() < lengthData) {
      if (millis() > endTime) {
        println("Message timed out");
        return ""; // Timeout
      }
      delay(2);
    }
    
    if (line.available() == 0) return "";
    
    String output = new String (char(line.readBytes(lengthData))); // Read in data
    
    //print("Recieved message of length: ");
    //print(lengthData);
    //print(" - ");
    //println(output);
    
    return output;
  }

  void endComms() {
    if (line != null) line.stop(); // Close data line
    line = null;
    requestData = false;
  }
}
