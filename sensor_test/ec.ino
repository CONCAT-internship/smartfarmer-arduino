#include <EEPROM.h>
#include "GravityTDS.h"

#define board_rate 115200
#define ec_pin A1

GravityTDS gravityTds;

float temperature = 25;
float tdsValue = 0;

void setup()
{
  Serial.begin(board_rate);
  gravityTds.setPin(ec_pin);
  gravityTds.setAref(5.0);  //reference voltage on ADC, default 5.0V on Arduino UNO
  gravityTds.setAdcRange(1024);  //1024 for 10bit ADC;4096 for 12bit ADC
  gravityTds.begin();  //initialization
}

void loop()
{
  //temperature = readTemperature();  //add your temperature sensor and read it
  gravityTds.setTemperature(temperature);  // set the temperature and execute temperature compensation
  gravityTds.update();  //sample and calculate
  tdsValue = gravityTds.getTdsValue();  // then get the value
  Serial.print(tdsValue,0);
  Serial.println("ppm");
  delay(1000);
}
