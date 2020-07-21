#define board_rate 115200
#define light_pin A0

int light

void setup(){
  Serial.begin(board_rate);
}

void loop(){
  int light = read_light();
  Serial.println(light);
}

int read_light(){
  return analogRead(light_pin);
}
