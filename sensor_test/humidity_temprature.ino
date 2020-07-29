#include <DHT11.h>

#define board_rate 115200
#define temperature_humidity_pin 4

DHT11 dht11(pin); 

float temperature;
float humidity;

void setup()
{
  Serial.begin(board_rate);
}

void loop()
{
  int err;
  if((err=dht11.read(humi, temp))==0)
  {
    Serial.print("temperature:");
    Serial.print(temperature);
    Serial.print(" humidity:");
    Serial.print(humidity);
    Serial.println();
  }
  else
  {
    Serial.println();
    Serial.print("Error No :");
    Serial.print(err);
    Serial.println();    
  }
  delay(2000); //delay for reread
}
