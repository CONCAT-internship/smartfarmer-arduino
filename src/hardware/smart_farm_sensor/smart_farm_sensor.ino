#include <EtherCard.h>
#include <ArduinoJson.h>
#include <DHT11.h>
#include <OneWire.h>
#include <ArduinoUniqueID.h>
#include <EEPROM.h>
#include "GravityTDS.h"
#include <DallasTemperature.h>

#define board_rate 11520
#define liquid_temperature_pin 20
#define humidity_temperature_pin 4
#define pH_pin A14
#define ec_pin A15
#define liquid_level_pin 21
#define light_pin A0
#define fan_pin 11

#define pH_Offset 0.00

DHT11 dht11(humidity_temperature_pin);
OneWire ds(liquid_temperature_pin);
DallasTemperature sensors(&ds);
GravityTDS gravityTds;

#define PATH    "in"
// ethernet interface mac address, must be unique on the LAN
byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 };
const char website[] PROGMEM = "ec2-13-125-23-94.ap-northeast-2.compute.amazonaws.com";

int pHArray[40];
int pHArrayIndex=0;

String uuid;
float liquid_temperature;
float temperature;
float humidity;
float liquid_flow_rate = 25.5;
float pH=7;
float ec;
int light;
boolean liquid_level;
boolean valve = 0;
boolean led = 0;
boolean fan;

byte Ethernet::buffer[700];
uint32_t timer;
Stash stash;

void read_uuid(){
  for (size_t i = 0; i < 8; i++)
  {
    if (UniqueID8[i] < 0x10)
      uuid += "0";
    uuid += String(UniqueID8[i], HEX);
  }
}

int read_light(){
  return analogRead(light_pin);
}

void read_humidity_and_temperature(){
  dht11.read(humidity, temperature);
}

boolean read_liquid_level(){
  return digitalRead(liquid_level_pin);
}

float read_liquid_temperature(){
  float tempC;
  sensors.requestTemperatures();
  tempC = sensors.getTempCByIndex(0);
  tempC = round(tempC*10)/10.0;
  return tempC;
}

float read_ec(){
  float tdsValue;
  gravityTds.setTemperature(liquid_temperature);  // set the temperature and execute temperature compensation
  gravityTds.update();  //sample and calculate
  tdsValue = gravityTds.getTdsValue();  // then get the value
  tdsValue = round(tdsValue)/500;
  tdsValue = round(tdsValue*10)/10.0;
  return tdsValue;
}


double avergearray(int* arr, int number){
  int i;
  int max,min;
  double avg;
  long amount=0;
  if(number<=0){
    Serial.println("Error number for the array to avraging!/n");
    return 0;
  }
  if(number<5){   //less than 5, calculated directly statistics
    for(i=0;i<number;i++){
      amount+=arr[i];
    }
    avg = amount/number;
    return avg;
  }
  else{
    if(arr[0]<arr[1]){
      min = arr[0];max=arr[1];
    }
    else{
      min=arr[1];max=arr[0];
    }
    for(i=2;i<number;i++){
      if(arr[i]<min){
        amount+=min;        //arr<min
        min=arr[i];
      }else {
        if(arr[i]>max){
          amount+=max;    //arr>max
          max=arr[i];
        }else{
          amount+=arr[i]; //min<=arr<=max
        }
      }//if
    }//for
    avg = (double)amount/(number-2);
  }//if
  return avg;
}
float read_pH(){  
  static unsigned long samplingTime = millis();
  static unsigned long printTime = millis();
  static float pHValue,voltage;
  if(millis()-samplingTime > 20)
  {
    pHArray[pHArrayIndex++]=analogRead(pH_pin);
    if(pHArrayIndex==40)pHArrayIndex=0;
    voltage = avergearray(pHArray, 40)*5.0/1024;
    pHValue = 3.5*voltage+pH_Offset;
    samplingTime=millis();
  }
  return round(pHValue*10)/10.0;
}

void setup () {
  //시리얼 통신 셋팅
  Serial.begin(board_rate);

  //핀 설정
  //수위센서
  pinMode(liquid_level_pin, INPUT);

  //네트워크 셋팅
  Serial.println("\n[Smart Farm]");
  if (ether.begin(sizeof Ethernet::buffer, mymac, 53) == 0) 
    Serial.println( "Failed to access Ethernet controller");
  if (!ether.dhcpSetup())
    Serial.println("DHCP failed");
  ether.printIp("IP:  ", ether.myip);
  ether.printIp("GW:  ", ether.gwip);  
  ether.printIp("DNS: ", ether.dnsip);  
  if (!ether.dnsLookup(website))
    Serial.println("DNS failed");
  ether.printIp("SRV: ", ether.hisip);

  //ec sensor setting
  gravityTds.setPin(ec_pin);
  gravityTds.setAref(5.0);  //reference voltage on ADC, default 5.0V on Arduino UNO
  gravityTds.setAdcRange(1024);  //1024 for 10bit ADC;4096 for 12bit ADC
  gravityTds.begin();  //initialization

  pinMode(fan_pin, OUTPUT);
  digitalWrite(fan_pin, HIGH);
  
  //read_uuid
  read_uuid();

  
}

void loop () {  
  ether.packetLoop(ether.packetReceive());
  //pH
  pH = read_pH();

  if (millis() > timer) {
    //1000 -> 1sec
    timer = millis() + 5000;
    Serial.println();
    Serial.print("<<< REQ ");
    
    //포트번호
    ether.hisport = 5000;

    //liquid_temperature
    liquid_temperature = read_liquid_temperature();

    //
    read_humidity_and_temperature();
    temperature = round(temperature*10)/10.0;
    
    //ec
    ec = read_ec();
    
    //liquid_level
    liquid_level = read_liquid_level();
    
    //light
    light = read_light();
    light = map(light, 0, 1023, 0, 100);
    
    byte sd = stash.create();
    char jsondata[250];
    const size_t capacity = JSON_OBJECT_SIZE(12)+50;
    DynamicJsonDocument doc(capacity);
    doc["uuid"] = uuid;
    doc["liquid_temperature"] = liquid_temperature;
    doc["temperature"] = temperature;
    doc["humidity"] = humidity;
    doc["liquid_flow_rate"] = liquid_flow_rate;
    doc["pH"] = pH;
    doc["ec"] = ec;
    doc["light"] = light;
    doc["liquid_level"] = liquid_level;
    doc["valve"] = valve;
    doc["led"] = led;
    doc["fan"] = fan;
    
    serializeJson(doc, jsondata, sizeof(jsondata));
    Serial.print("sizeof(jsondata) : ");
    Serial.println(sizeof(jsondata));
    Serial.println(jsondata);
    stash.print(jsondata);
    stash.save();
    
    // generate the header with payload - note that the stash size is used,
    // and that a "stash descriptor" is passed in as argument using "$H"
    //send post json
    Stash::prepare(PSTR("POST http://$F/$F HTTP/1.1" "\r\n"
                "Host: $F" "\r\n"
                "Content-Length: $D" "\r\n"
                "Content-Type: application/json" "\r\n"
                "\r\n"
                "$H"),
    website, PSTR(PATH), website, stash.size(), sd);
    // send the packet - this also releases all stash buffers once done
    ether.tcpSend();

  }
}
