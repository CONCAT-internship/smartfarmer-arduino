void setup(){

    Serial.begin(9600);

}

void loop(){

    int d = analogRead(A0);

    Serial.println(d);

}
