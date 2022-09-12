
class BulkDataStruct {
  float speedEncoder, speedGPS;
  int rotations;
  float gpsDist;
  float frontBrakeT, rearBrakeT;
  byte fBatt, rBatt;
  float humid, temp;
  int CO2;
  byte fhr, rhr, fcad, rcad;
  int fpwr, rpwr; 
  
  void readBulkData(Serial line) {
    
    int timeOutPeriod = 200;
    
    do {
      int timeOutMark = millis() + timeOutPeriod;
      line.write('{');
      
      // Wait for message before retrying
      while ((line.available() < 32) && (millis() < timeOutMark)) {
        delay(5);
      }
    } while (line.available() < 32);
    
    byte bufIn[] = line.readBytes(32);
    line.clear(); // Clear any trailing data
    
    //for (byte i = 0; i < 32; i ++) print(char(bufIn[i]));
    
    this.gpsDist = bytesToInt(bufIn, 2, 2) / 1000.0;
    this.speedEncoder = bytesToInt(bufIn, 4, 4) / 1000.0;
    this.speedGPS = bytesToInt(bufIn, 8, 4) / 1000.0;
    this.rotations = bytesToInt(bufIn, 12, 2);
    this.frontBrakeT = bytesToInt(bufIn, 14, 2) / 100.0;
    this.rearBrakeT = bytesToInt(bufIn, 16, 2) / 100.0;
    this.fBatt = bufIn[18];
    this.rBatt = bufIn[19];
    this.humid = bufIn[20] / 2.0;
    this.temp = (bufIn[21] - 50) / 2.0;
    this.CO2 = bytesToInt(bufIn, 22, 2);
    this.fhr = bufIn[24];
    this.rhr = bufIn[25];
    this.fcad = bufIn[26];
    this.rcad = bufIn[27];
    this.fpwr = bytesToInt(bufIn, 28, 2);
    this.rpwr = bytesToInt(bufIn, 30, 2); 
  }
  
  private int bytesToInt(byte array[], int startIndex, int widthOfField) {
    int output = 0;
    
    for (int i = 0; i < widthOfField; i++) {
      output = output + (int(array[startIndex + i]) << (8 * i));
    }
    
    return output;
  }
};
