#include "HX711.h"
#define DOUT12  2
#define CLK12   3
#define DOUT34  4
#define CLK34   5
#define DOUT56  6
#define CLK56   7

HX711 scale12;
HX711 scale34;
HX711 scale56;

char start = '[';
char ending[] = "]\n";
char separator = ';';

void setup() {
  Serial.begin(9600);
  scale12.begin(DOUT12, CLK12);
  scale34.begin(DOUT34, CLK34);
  scale56.begin(DOUT56, CLK56);
}

int i = 0;

void loop() {
  Serial.print(start);
  
  if (scale12.is_ready()) {
    // with a gain factor of 32, channel B is selected
    scale12.set_gain(32);
    long reading1 = scale12.read();
    //Serial.print(reading1);
    Serial.print(i * 2);
    Serial.print(separator);

    // with a gain factor of 64 or 128, channel A is selected
    scale12.set_gain(128);
    long reading2 = scale12.read();
    //Serial.print(reading2);
    Serial.print(i);
    Serial.print(separator);
  } else {
    Serial.print(separator);
    Serial.print(separator);
  }

  if (scale34.is_ready()) {
    // with a gain factor of 32, channel B is selected
    scale34.set_gain(32);
    long reading3 = scale34.read();
    //Serial.print(reading3);
    Serial.print(i / 2);
    Serial.print(separator);

    // with a gain factor of 64 or 128, channel A is selected
    scale34.set_gain(128);
    long reading4 = scale34.read();
    //Serial.print(reading4);
    Serial.print(i / 3.0);
    Serial.print(separator);
  } else {
    Serial.print(separator);
    Serial.print(separator);
  }

  if (scale56.is_ready()) {
    // with a gain factor of 32, channel B is selected
    scale56.set_gain(32);
    long reading5 = scale56.read();
    //Serial.print(reading5);
    Serial.print(i % 10);
    Serial.print(separator);

    // with a gain factor of 64 or 128, channel A is selected
    scale56.set_gain(128);
    long reading6 = scale56.read();
    Serial.print(reading6);
  } else {
    Serial.print(separator);
  }

  Serial.print(ending);
  i++;
  
  delay(100);
}
