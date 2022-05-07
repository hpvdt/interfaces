#include "HX711.h"
const int DOUT12 = 2;
const int CLK12 = 3;
const int DOUT34 = 4;
const int CLK34 = 5;
const int DOUT56 = 6;
const int CLK56 = 7;

HX711 scale12;
HX711 scale34;
HX711 scale56;

const char start = '[';
const char ending[] = "]\n";
const char separator = ';';

//#define DEV_MODE 
// Used to toggle the dev mode, sending random numbers rather than reading actual values.
// Uncomment it if you want to enter dev mode, leave commented out for normal operation.

#ifdef DEV_MODE
int i = 0; // Used for generating data in dev mode
#endif

void setup() {
  Serial.begin(115200);
  scale12.begin(DOUT12, CLK12);
  scale34.begin(DOUT34, CLK34);
  scale56.begin(DOUT56, CLK56);
}

void loop() {
  Serial.print(start);

#ifdef DEV_MODE
  // Development mode for interface testing
  // Just spits out numbers to be shown
  Serial.print(i * 2);
  Serial.print(separator);
  Serial.print(i);
  Serial.print(separator);
  Serial.print(i / 2);
  Serial.print(separator);
  Serial.print(i / 3.0);
  Serial.print(separator);
  Serial.print(i % 10);
  Serial.print(separator);
  Serial.print(0);
  i++;
#else
  /* Normal operation
    Reads all possible values for the system.

    NOTE: Due to the operation of the HX711 chips the gain setting is not 
    as expected (e.g. setting it to 32 before reading for channel B). This 
    is due to us waiting for data being ready before setting the gain and 
    then reading.

    The data readied for us to read is from the previous gain setting since 
    the gain change has not had the time to come into effect on the data 
    prepared. So what we are effectively doing is setting the gain for the 
    next reading not the one that immediately follows a gain change.

    ALSO NOTE: For a given HX711 channel A is the even numbered header, 
    channel B is used for the odd numbered header.
  */
  
  if (scale12.is_ready()) {
    // With a gain factor of 64 or 128, channel A is selected for the next read
    scale12.set_gain(128); 
    long reading1 = scale12.read();
    Serial.print(reading1);
    Serial.print(separator);

    scale12.wait_ready(1); // Wait in 1ms increments until ready to read

    // With a gain factor of 32, channel B is selected for the next read
    scale12.set_gain(32); 
    long reading2 = scale12.read();
    Serial.print(reading2);
    Serial.print(separator);
  } else {
    Serial.print(separator);
    Serial.print(separator);
  }

  if (scale34.is_ready()) {
    // With a gain factor of 64 or 128, channel A is selected for the next read
    scale34.set_gain(128);
    long reading3 = scale34.read();
    Serial.print(reading3);
    Serial.print(separator);

    scale34.wait_ready(1); // Wait in 1ms increments until ready to read

    // With a gain factor of 32, channel B is selected for the next read
    scale34.set_gain(32);
    long reading4 = scale34.read();
    Serial.print(reading4);
    Serial.print(separator);
  } else {
    Serial.print(separator);
    Serial.print(separator);
  }

  if (scale56.is_ready()) {
    // With a gain factor of 64 or 128, channel A is selected for the next read
    scale56.set_gain(128);
    long reading5 = scale56.read();
    Serial.print(reading5);
    Serial.print(separator);

    scale56.wait_ready(1); // Wait in 1ms increments until ready to read

    // With a gain factor of 32, channel B is selected for the next read
    scale56.set_gain(32);
    long reading6 = scale56.read();
    Serial.print(reading6);
  } else {
    Serial.print(separator);
  }
#endif
  
  Serial.print(ending);
  
  delay(100);
}
