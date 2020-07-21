#define board_rate 115200
#define liquid_level_pin 5

boolean liquid_level;

void setup() {
  Serial.begin(board_rate);
  pinMode(liquid_level_pin, INPUT);
}

void loop() {
  liquid_level=read_liquid_level()
  Serial.print("Liquid_level= ");Serial.println(liquid_level,DEC);
  delay(500);
}

boolean read_liquid_level(){
  return digitalRead(liquid_level_pin);
}
