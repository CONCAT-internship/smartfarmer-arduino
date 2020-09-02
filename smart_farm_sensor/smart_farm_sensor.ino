// 2020 08 21

#include <EtherCard.h>
#include <ArduinoJson.h>
#include <DHT.h>
#include <OneWire.h>
#include <ArduinoUniqueID.h>

#include <EEPROM.h>
#include "GravityTDS.h"
#include <DallasTemperature.h>

#define board_rate 115200
#define liquid_temperature_pin 20
#define humidity_temperature_pin A3
#define pH_pin A15
#define ec_pin A14
#define liquid_level_pin 45
#define light_pin A0
#define fan_pin 30
#define led_pin 11
#define pH_down_pin 34
#define pH_up_pin 35
#define ec_up_pin 33

#define pH_Offset -0.50

//#define PATH    "in" // 테스트용
#define PATH    "Insert"

#define get_rate 60000 // 1min
#define post_rate 180000 // 3min
#define pump_rate 800 // 0.8sec

DHT dht(humidity_temperature_pin, DHT21);
OneWire ds(liquid_temperature_pin);
DallasTemperature sensors(&ds);
GravityTDS gravityTds;

// ethernet interface mac address, must be unique on the LAN
byte mymac[] = { 0x74, 0x69, 0x69, 0x2D, 0x30, 0x31 };

//const char website[] PROGMEM = "ec2-13-125-23-94.ap-northeast-2.compute.amazonaws.com"; // 테스트용
const char website[] PROGMEM = "asia-northeast1-superfarmers.cloudfunctions.net";

// POST request 변수
String uuid;
float liquid_temperature;
float temperature_value;
float humidity_value;
float pH;
float ec;
int light;
boolean liquid_level;
int pH_pump;
int ec_pump;
boolean led = 0;
boolean fan = 1;

boolean pH_flag = 0;
boolean ec_flag = 0;

// GET request 변수
char query_string[80] = "DesiredStatus?uuid=";
char char_uuid[20];

byte Ethernet::buffer[700];
uint32_t post_timer = 0;
uint32_t get_timer = 0;

uint32_t pH_pump_up_timer = 0;
uint32_t pH_pump_down_timer = 0;
uint32_t ec_pump_timer = 0;

int pHArray[40];
int pHArrayIndex = 0;

Stash stash;

static void my_callback (byte status, word off, word len) {
  Ethernet::buffer[off + 1000] = 0;
  String fullres = (const char*) Ethernet::buffer + off;
  fullres = fullres.substring(fullres.indexOf("{"), fullres.indexOf("}") + 1);

  //  Serial.println(fullres);
  // 4개의 속성값을 가져옴
  const size_t capacity = JSON_OBJECT_SIZE(4) + 30;
  DynamicJsonDocument doc(capacity);
  deserializeJson(doc, fullres);
  serializeJson(doc, Serial);
  Serial.println();

  boolean led = doc["led"];
  boolean fan = doc["fan"];


  if (pH_flag == 0) {
    pH_pump = doc["pH_pump"];
    pH_flag = 1;
  }

  if (ec_flag == 0) {
    ec_pump = doc["ec_pump"];
    ec_flag = 1;
  }

  //fan같은 경우는 LOW일때 켜진다...
  if (fan) {
    digitalWrite(fan_pin, LOW);
    fan = true;
  }
  else {
    digitalWrite(fan_pin, HIGH);
    fan = false;
  }
}


void read_uuid() {
  for (size_t i = 0; i < 8; i++)
  {
    if (UniqueID8[i] < 0x10)
      uuid += "0";
    uuid += String(UniqueID8[i], HEX);
  }
}


int read_light() {
  return analogRead(light_pin);
}


void read_humidity_and_temperature() {
  humidity_value = dht.readHumidity();
  temperature_value = dht.readTemperature();
}


boolean read_liquid_level() {
  return digitalRead(liquid_level_pin);
}


float read_liquid_temperature() {
  float tempC;
  sensors.requestTemperatures();
  tempC = sensors.getTempCByIndex(0);
  tempC = round(tempC * 10) / 10.0;
  return tempC;
}


float read_ec() {
  float tdsValue;
  gravityTds.setTemperature(liquid_temperature);  // set the temperature and execute temperature compensation
  gravityTds.update();  //sample and calculate
  tdsValue = gravityTds.getTdsValue();  // then get the value
  tdsValue = tdsValue / 500;
  return tdsValue;
}

//pH측정을 위한 함수
double avergearray(int* arr, int number) {
  int i;
  int max, min;
  double avg;
  long amount = 0;
  if (number <= 0) {
    Serial.println("Error number for the array to avraging!/n");
    return 0;
  }
  if (number < 5) { //less than 5, calculated directly statistics
    for (i = 0; i < number; i++) {
      amount += arr[i];
    }
    avg = amount / number;
    return avg;
  }
  else {
    if (arr[0] < arr[1]) {
      min = arr[0]; max = arr[1];
    }
    else {
      min = arr[1]; max = arr[0];
    }
    for (i = 2; i < number; i++) {
      if (arr[i] < min) {
        amount += min;      //arr<min
        min = arr[i];
      } else {
        if (arr[i] > max) {
          amount += max;  //arr>max
          max = arr[i];
        } else {
          amount += arr[i]; //min<=arr<=max
        }
      }
    }
    avg = (double)amount / (number - 2);
  }
  return avg;
}


float read_pH() {
  static unsigned long samplingTime = millis();
  static unsigned long printTime = millis();
  static float pHValue, voltage;
  if (millis() - samplingTime > 20)
  {
    pHArray[pHArrayIndex++] = analogRead(pH_pin);
    if (pHArrayIndex == 40)pHArrayIndex = 0;
    voltage = avergearray(pHArray, 40) * 5.0 / 1024;
    pHValue = 3.5 * voltage + pH_Offset;
    samplingTime = millis();
  }
  return round(pHValue * 10) / 10.0;
}


void setup () {
  // 시리얼 통신 셋팅
  Serial.begin(board_rate);

  // 네트워크 셋팅
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
  //  ether.persistTcpConnection(true);

  // dht setting
  dht.begin();

  // 핀 설정
  // 수위
  pinMode(liquid_level_pin, INPUT);

  // ec
  gravityTds.setPin(ec_pin);
  gravityTds.setAref(5.0);  //reference voltage on ADC, default 5.0V on Arduino UNO
  gravityTds.setAdcRange(1024);  //1024 for 10bit ADC;4096 for 12bit ADC
  gravityTds.begin();  //initialization

  // fan
  pinMode(fan_pin, OUTPUT);
  digitalWrite(fan_pin, HIGH);

  // led
  pinMode(led_pin, OUTPUT);
  digitalWrite(led_pin, HIGH);

  //pump
  pinMode(pH_up_pin, OUTPUT);
  digitalWrite(pH_up_pin, LOW);

  pinMode(pH_down_pin, OUTPUT);
  digitalWrite(pH_down_pin, LOW);

  pinMode(ec_up_pin, OUTPUT);
  digitalWrite(ec_up_pin, LOW);


  // read_uuid
  read_uuid();

  // query string
  strcpy(char_uuid, uuid.c_str());
  strcat(query_string, char_uuid);
}


void loop () {
  ether.packetLoop(ether.packetReceive());
  // 테스트용 포트번호
  //  ether.hisport = 5000;

  // pH
  pH = read_pH();

  // 시간 중복 방지
  if (get_timer == post_timer) {
    post_timer += 1000;
  }

  //
  if (millis() > get_timer) {
    get_timer = millis() + get_rate;
    ether.browseUrl(PSTR("/"), query_string, website, my_callback);
  }

  // pH값을 높이거나 낮춰야할때
  if (pH_pump != 0) {
    // pH up
    if (pH_pump > 0) {
      digitalWrite(pH_up_pin, HIGH);
      pH_pump = 0;
      pH_pump_up_timer = millis();
    }
    // pH down
    if (pH_pump < 0) {
      digitalWrite(pH_down_pin, HIGH);
      pH_pump = 0;
      pH_pump_down_timer = millis();
    }
  }
  // pH pump off
  if (millis() - pH_pump_up_timer > pump_rate) {
    digitalWrite(pH_up_pin, LOW);
  }
  if (millis() - pH_pump_down_timer > pump_rate) {
    digitalWrite(pH_down_pin, LOW);
  }

  // ec pump on
  if (ec_pump != 0) {
    // ec pump up
    digitalWrite(ec_up_pin, HIGH);
    ec_pump = 0;
    ec_pump_timer = millis();
  }
  // ec pump off
  if (millis() - ec_pump_timer > pump_rate) {
    digitalWrite(ec_up_pin, LOW);
  }

  if (millis() > post_timer) {
    post_timer = millis() + post_rate;
    pH_flag = 0;
    ec_flag = 0;

    // liquid_temperature
    liquid_temperature = read_liquid_temperature();

    // humidity_and_temperature
    read_humidity_and_temperature();
    temperature_value = round(temperature_value * 10) / 10.0;

    // ec
    ec = read_ec();

    // liquid_level
    liquid_level = read_liquid_level();

    // light
    light = read_light();
    light = map(light, 0, 1023, 0, 100);

    // json create
    byte sd = stash.create();
    char jsondata[250];
    const size_t capacity = JSON_OBJECT_SIZE(10) + 50;
    DynamicJsonDocument doc(capacity);
    doc["uuid"] = uuid;
    doc["liquid_temperature"] = liquid_temperature;
    doc["temperature"] = temperature_value;
    doc["humidity"] = humidity_value;
    doc["pH"] = pH;
    doc["ec"] = ec;
    doc["light"] = light;
    doc["liquid_level"] = liquid_level;
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
    // send post json
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
