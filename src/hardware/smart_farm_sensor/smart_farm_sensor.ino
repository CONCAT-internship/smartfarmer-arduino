#include <EtherCard.h>
#include <ArduinoJson.h>
#include <DHT11.h>
#include <OneWire.h> 

#define board_rate 115200
#define liquid_temperature_pin 2
#define liquid_level_pin 5

DHT11 dht11(4);
OneWire ds(liquid_temperature_pin); //2번 핀과 연결되 OneWire 객체 생성

#define PATH    "in"
// ethernet interface mac address, must be unique on the LAN
byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 };

const char website[] PROGMEM = "ec2-13-125-23-94.ap-northeast-2.compute.amazonaws.com";

String uuid = "57 39 39 31 34 31 10 15 0E";
float liquid_temperature;
float temperature;
float humidity;
float liquid_flow_rate = 25.51;
float ph = 7.1;
float ec = 0.12;
int light;
boolean liquid_level;
boolean valve = 0;
boolean led = 0;
boolean fan = 0;

byte Ethernet::buffer[500];
uint32_t timer;
Stash stash;

void setup () {
  //시리얼 통신 셋팅
  Serial.begin(board_rate);

  //핀 설정
  //수위센서
  pinMode(liquid_level_pin, INPUT);

  //네트워크 셋팅
  Serial.println("\n[webClient]");
  if (ether.begin(sizeof Ethernet::buffer, mymac) == 0) 
    Serial.println( "Failed to access Ethernet controller");
  if (!ether.dhcpSetup())
    Serial.println("DHCP failed");
  ether.printIp("IP:  ", ether.myip);
  ether.printIp("GW:  ", ether.gwip);  
  ether.printIp("DNS: ", ether.dnsip);  
  if (!ether.dnsLookup(website))
    Serial.println("DNS failed");
  ether.printIp("SRV: ", ether.hisip);
  
}

void loop () {  
  ether.packetLoop(ether.packetReceive());
  if (millis() > timer) {
    timer = millis() + 5000;
    Serial.println();
    Serial.println("<<< REQ ");

    liquid_temperature = round(read_liquid_temperature()*100)/100.00;
    light = read_light();
    light = map(light, 0, 1023, 100, 0);
    dht11.read(humidity, temperature);
    liquid_level = read_liquid_level();
    
    //포트번호
    ether.hisport = 5000;
    byte sd = stash.create();
    String jsondata = "";
    StaticJsonBuffer<170> jb;
    //DynamicJsonBuffer jb;
    JsonObject& obj = jb.createObject();
    
    obj["uuid"] = uuid;
    obj["liquid_temperature"] = liquid_temperature;
    obj["temperature"] = temperature;
    obj["humidity"] = humidity;
    obj["liquid_flow_rate"] = liquid_flow_rate;
    obj["ph"] = ph;
    obj["ec"] = ec;
    obj["light"] = light;
    obj["liquid_level"] = liquid_level;
    obj["valve"] = valve;
    obj["led"] = led;
    obj["fan"] = fan;
    
    
    obj.printTo(jsondata);
    Serial.println(jsondata);
    stash.print(jsondata);
    //stash.print("light=");
    //stash.print(light);
    //stash.print("&humidity=");
    //stash.print(humidity);
    //stash.print("&temperature=");
    //stash.print(temperature);
    int stash_size = stash.size();
    Serial.println(stash_size);
    stash.save();
    
    // generate the header with payload - note that the stash size is used,
    // and that a "stash descriptor" is passed in as argument using "$H"
    Stash::prepare(PSTR("POST https://$F/$F HTTP/1.1" "\r\n"
                "Host: $F" "\r\n"
                "Content-Length: $D" "\r\n"
                "Content-Type: application/json" "\r\n"
                "\r\n"
                "$H"),
    website, PSTR(PATH), website, stash_size, sd);
    // send the packet - this also releases all stash buffers once done
    ether.tcpSend();
  }
}

int read_light(){
  return analogRead(A0);
}

void read_Humidity_and_Temperature(){
  dht11.read(humidity, temperature);
}

boolean read_liquid_level(){
  return digitalRead(liquid_level_pin);
}

//온도 측정 후 반환하는 함수
float read_liquid_temperature(){
 byte data[12];
 byte addr[8];
 if ( !ds.search(addr)) {
   ds.reset_search();
   return -3000;
 }
 if ( OneWire::crc8( addr, 7) != addr[7]) {
   Serial.println("CRC is not valid!");
   return -2000;
 }
 if ( addr[0] != 0x10 && addr[0] != 0x28) {
   Serial.print("Device is not recognized");
   return -1000;
 }
 ds.reset();
 ds.select(addr);
 ds.write(0x44,1);    //변환
 byte present = ds.reset();
 ds.select(addr);  
 ds.write(0xBE); 
 for (int i = 0; i < 9; i++) { 
  data[i] = ds.read();  //Scratchpad 읽음
 }
 ds.reset_search();
 byte MSB = data[1];
 byte LSB = data[0];
 float tempRead = ((MSB << 8) | LSB); 
 float TemperatureSum = tempRead / 16;
 return TemperatureSum;
}
