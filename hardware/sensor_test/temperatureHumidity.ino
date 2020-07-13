#include <OneWire.h> 

int DS18S20_Pin = 2; //온도센서와 연결

OneWire ds(DS18S20_Pin); //2번 핀과 연결되 OneWire 객체 생성

void setup(void) {
 Serial.begin(9600);
  delay(300);
}

void loop(void) {
 float temperature = getTemp(); //온도 측정 후 변수에 저장
 Serial.print("tmp: ");
 Serial.println(temperature);    //온도 LCD에 출력
  
 delay(1000);   //5초마다 측정 후 출력
 
}

//온도 측정 후 반환하는 함수
float getTemp(){

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
