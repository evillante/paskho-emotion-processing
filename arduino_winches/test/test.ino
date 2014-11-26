int randTest = 0;

void setup(){
  Serial.begin(300);
}

void loop(){
  randTest = int(random(10, 100));
  Serial.write(randTest);
}
