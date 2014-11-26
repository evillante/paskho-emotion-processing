#include <SoftwareSerial.h>


//=======================================================//
//======================== SERVO ========================//
//=======================================================// 

int inByte;
int byteEmo;

float troub1 = 0;
float troub2 = 0;
float troub3 = 0;
float troub4 = 0;

float troubXB = 0;
float troubXS = 0;

float troubYB = 0;
float troubYS = 0;

float troubXY = 0;

// servo library
#include <Servo.h>  

  //SPIDER
Servo servo1;  
Servo servo2;
Servo servo3;  
Servo servo4;
  //CANVAS
Servo servo5;  
Servo servo6;
Servo servo7;  
Servo servo8;
  //painter
Servo servoM1;  
Servo servoM2;

Servo servoS;

int microTroub1 = 100;
int microTroub2 = 140;
int microDev;

int mid;
int spiderUp;
int frameMid;
int tilt;
int circSeg;

int s1i;
int s2i;
int s3i;
int s4i;
int s5i;
int s6i;
int s7i;
int s8i;

//spider dimens
float lengthX;
float lengthY;
int midPoint;

//ring 
float rw;
float hrw;

//movement of x & y axis
float moveX;
float moveY;

//math
int h1; int h2; int h3; int h4;
int c1; int c2; int c3; int c4; 

int zTop = 1900;  //1920 for top
int zBot = 1100;
int dropDelay;

int spiderHei = 80;

int dangerDirection = 0;

int randX; float randXtemp;
int randY; float randYtemp;

int cont1X = 1050; int cont1Y = 400; int cont1D = 2650;
int cont2X = 1100; int cont2Y = 800; int cont2D = 2000;
int cont3X = 850; int cont3Y = 400;  int cont3D = 1500;
int cont4X = 900; int cont4Y = 200;  int cont4D = 2200;

//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup()
{
  Serial.begin(115200);

  
  //============================ SERVO
  //initialize servos (pin, min range, max range).
  //spider
  servo1.attach(10, 1000, 2000);
  servo2.attach(4, 1000, 2000);
  servo3.attach(5, 1000, 2000);
  servo4.attach(11, 1000, 2000);  
  //frame
  servo5.attach(12, 1000, 2000);
  servo6.attach(7, 1000, 2000);
  servo7.attach(6, 1000, 2000);
  servo8.attach(13, 1000, 2000); 

  servoM1.attach(3);  
  servoM2.attach(8);  
  servoS.attach(2, 1000, 2000);  
 
  //define basic variables
  mid = 1500;
  spiderUp = mid + -spiderHei;
  //ring variables
  frameMid = 1600;
  tilt = 250;
  circSeg = 1000;
  
  //spider dimens
  lengthX = 1100;
  lengthY = 800;
  
  midPoint = 630; //when all lines are equal distance
  
  //ring 
  rw = 160;
  hrw = rw/2;  

  //set values to 0
  startUp();
  //test
//  moveX = 200;
//  moveY = 700;
//  moveSpider(moveX, moveY);
  
  //paint(4, 400, 400);
  //ring(2700);


}

//=================================================================//
//=============================== LOOP ============================//
//=================================================================//

void loop()
{
  //serial read
  while(Serial.available()){
    inByte = Serial.read();
  }    
  //decision function
  brain();  
    
    
 //ring();
 //microTest();
 //sexBot();
}




//=================================================================//
//========================= SMALL FUNCTIONS =======================//
//=================================================================//
void brain(){

  //set the emotion
  if(inByte == 2){byteEmo = 1;}
  if(inByte == 3){byteEmo = 2;}
  if(inByte == 4){byteEmo = 3;}
  if(inByte == 5){byteEmo = 4;}
  if(inByte == 6){byteEmo = 5;}
  if(inByte == 7){byteEmo = 6;}
  if(inByte == 8){byteEmo = 7;}
  if(inByte == 9){byteEmo = 8;}  
  
  //love detected
  if(inByte==30){north(tilt);}
  if(inByte==31){east(tilt);}
  if(inByte==32){south(tilt);}
  if(inByte==33){west(tilt);}
  
  if(inByte==34){SouthW(-tilt);}
  if(inByte==35){NorthW(-tilt);}
  if(inByte==36){NorthE(-tilt);}
  if(inByte==37){SouthE(-tilt);}
  
  
  //run paint function
  if(inByte == 1){
      int cordX = int(random(150,700));
      int cordY = int(random(100,600));
      paint(byteEmo);
  }
    
}

void paint(int b) {

    if(b == 1){cycle(cont2X, cont2Y, cont2D, 0);ring(1500);}
    if(b == 2){cycle(cont2X, cont2Y, cont2D, 20);}
    if(b == 3){cycle(cont3X, cont3Y, cont3D, 30);}
    if(b == 4){cycle(cont1X, cont1Y, cont1D, 0);}
    
    if(b == 5){cycle(cont3X, cont3Y, cont3D, 20);}
    if(b == 6){cycle(cont4X, cont4Y, cont3D, 0);}
    if(b == 7){cycle(cont4X, cont4Y, cont4D, 20);}
    if(b == 8){cycle(cont1X, cont1Y, cont4D, 0);}    
  
}

void cycle(int x, int y, int d, int dPlus){
    //move over container
    moveToCont(x, y);
    delay(3000); 
    //drop/raise sponge
    spongeToCont(d + dPlus);
    delay(3000);
    //move to mid
    moveToMid();
    delay(3000);
    //move to drop location 
//    randXtemp = 150+(random(1)*550);
//    randYtemp = 100+(random(1)*500);
//    randX = int(randXtemp);
//    randY = int(randYtemp);
    randX = 50-(random(100,650));
    randY = random(120,900);
    moveToDrop(randX, randY);
    delay(4000);
    //clamp
    clamp(1000);
    //ring(1500);
    //run setup
    spiderUp = mid + spiderHei;
    startUp();  
}

void moveToCont(int x, int y){
  moveX = x;
  moveY = y;
  moveSpider(moveX, moveY);
}

void moveToMid(){
    moveX = 550;
    moveY = 400;
    spiderUp = mid + spiderHei;
    moveSpider(moveX, moveY);
}

void moveToDrop(int dropX, int dropY){

  moveX = dropX;
  moveY = dropY;
  spiderUp = mid + spiderHei;
  moveSpider(moveX, moveY);
}

void startUp() {
  spiderUp = mid + spiderHei;  
  //center frame
  servo5.writeMicroseconds(frameMid);
  servo6.writeMicroseconds(frameMid);  
  servo7.writeMicroseconds(frameMid);
  servo8.writeMicroseconds(frameMid);  
  //center spider
  moveX = 550;
  moveY = 400;
  moveSpider(moveX, moveY);
  //open microservo
  servoM1.write(microTroub1);
  servoM2.write(microTroub2);
  delay(1000);
  //raise sponge
  servoS.writeMicroseconds(zTop);
  delay(3000); 
}

void microTest() {
  delay(1000);
  microDev = 0; 
  servoM1.write(microTroub1 - microDev);
  servoM2.write(microTroub2 - microDev);
  delay(1000);
  microDev = 20; 
  servoM1.write(microTroub1 - microDev);
  servoM2.write(microTroub2 - microDev);  
}  

void sexBot() {
  servoS.writeMicroseconds(zTop); 
  delay(4000);
  servoS.writeMicroseconds(zBot); 
  delay(4000);
}

void spongeToCont(int d) {
    servoS.writeMicroseconds(zBot);
    delay(d); 
    servoS.writeMicroseconds(zTop);
    delay(d);
}

void clamp(int d){
  microDev = 28; 
  servoM1.write(microTroub1 - microDev);
  servoM2.write(microTroub2 - microDev);
  delay(d);
  microDev = 0; 
  servoM1.write(microTroub1 - microDev);
  servoM2.write(microTroub2 - microDev); 
}

//=================================================================//
//=============================== MOVE ============================//
//=================================================================//

void moveSpider(int x,int y) {
   spiderUp = mid + spiderHei;
   troub1 = 0;
   troub2 = 0;
   troub3 = 0;
   troub4 = 0;
  //===========================Troubleshoot===========================
  
  //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  if(x>=800){
    troub1 = map(x, 800, 1100, 0, 150);    
    troub2 = map(x, 800, 1100, 0, 170);
    troub3 = map(x, 800, 1100, 0, 170);
    troub4 = map(x, 800, 1100, 0, 150);
  }
//
  if(x<550 && y==400){
    troubXS = map(x, 0, 550, 0, 50);
    troubXS = 50-troubXS;
    //troub2 = troub2 + (50 - map(moveX, 0, 500, 0, 50));
    spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS + troubXY;
  }
//
  //YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
  if(y>400){
    troubYS = map(y, 400, 800, 0, 180); 
    spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS + troubXY;
  }
//  
  if(y<400){
    troubYS = map(y, 0, 400, 0, 100);
    troubYS = 100 - troubYS;
    spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS + troubXY;
    troub4 = troub4 - 80;
  }
//  
  //XYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXYXY
  if(x > 800 && y > 400){
    int tot = map(x, 800, 1100, 0, 50) + (25 - map(y, 400, 800, 0, 50));
    troub3 = troub3 + tot;
    troub2 = troub2 - tot;
    troub1 = troub1 - tot;
    troub4 = troub4 - tot;
  }  
  
//  if(x<400 && y > 400){
//  int tot2 = (100- map(x, 0, 400, 0, 100)) + (map(y, 400, 800, 0, 100));
//  troubXY = -tot2;
//  spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS + troubXY;
//  }
//  
  
  //==========================Set Individual==========================
  s1i = spiderUp + 0 + troub1;
  s2i = spiderUp + -400 + troub2;
  s3i = spiderUp + -50 + troub3;
  s4i = spiderUp + 0 + troub4;

  
  //============================I Hate Math===========================
  h1 =  int( sqrt ( sq(x-hrw) + sq(y-hrw)) );
  h2 =  int( sqrt ( sq(lengthX-x-hrw) + sq(y-hrw)) );
  h3 =  int( sqrt ( sq(lengthX-x-hrw) + sq(lengthY-y-hrw)) );
  h4 =  int( sqrt ( sq(x-hrw) + sq(lengthY-y-hrw)) );
  
  c1 = s1i + midPoint - h1;
  c2 = s2i + midPoint - h2;
  c3 = s3i + midPoint - h3;
  c4 = s4i + midPoint - h4;
  
  //============================Move Spider===========================
  servo1.writeMicroseconds(c1);
  servo2.writeMicroseconds(c2);  
  servo3.writeMicroseconds(c3);
  servo4.writeMicroseconds(c4);    
  
  spiderUp = mid + spiderHei;
}

//=================================================================//
//=============================== RING ============================//
//=================================================================//

 void ring (int d){
 
    //1
    SouthE(-tilt);
    clamp(700);
    delay(d);
    
    //2
    east(-tilt);
    clamp(700);
    delay(d);
    
    //3
    NorthE(-tilt);
    clamp(700);
    delay(d);
    
    //4
    north(-tilt);
    clamp(700);
    delay(d);
    
    //3 up
    NorthW(-tilt);
    clamp(700);
    delay(d);
    
    //6
    west(-tilt);
    clamp(700);
    delay(d); 
   
    //4 up
    SouthW(-tilt);
    clamp(700);
    delay(d);
    
    //7
    south(-tilt);
    clamp(700);
    delay(d);
    
    //8
    midFrame();
    clamp(700);
    delay(d);
 }
  

//=================================================================//
//============================ Experiment =========================//
//=================================================================//

  void midFrame(){
    servo5.writeMicroseconds(frameMid);
    servo6.writeMicroseconds(frameMid);  
    servo7.writeMicroseconds(frameMid);
    servo8.writeMicroseconds(frameMid);   
  }

  //=================================================== Square 0-3
  void north(int mag) {
    servo5.writeMicroseconds(frameMid - mag);
    servo6.writeMicroseconds(frameMid + mag);  
    servo7.writeMicroseconds(frameMid + mag);
    servo8.writeMicroseconds(frameMid - mag);
  }
  
  void east(int mag) {
    servo5.writeMicroseconds(frameMid + mag);
    servo6.writeMicroseconds(frameMid + mag);  
    servo7.writeMicroseconds(frameMid - mag);
    servo8.writeMicroseconds(frameMid - mag);
  }  
  
  void south(int mag) {
    servo5.writeMicroseconds(frameMid + mag);
    servo6.writeMicroseconds(frameMid - mag);  
    servo7.writeMicroseconds(frameMid - mag);
    servo8.writeMicroseconds(frameMid + mag);
  }
  
  void west(int mag) {
    servo5.writeMicroseconds(frameMid - mag);
    servo6.writeMicroseconds(frameMid - mag);  
    servo7.writeMicroseconds(frameMid + mag);
    servo8.writeMicroseconds(frameMid + mag);
  }
  //=================================================== Diagonal 4-7
  void NorthE(int mag) {
    servo5.writeMicroseconds(frameMid);
    servo6.writeMicroseconds(frameMid + mag);  
    servo7.writeMicroseconds(frameMid);
    servo8.writeMicroseconds(frameMid - mag);
  }
  
  void SouthE(int mag) {
    servo5.writeMicroseconds(frameMid + mag);
    servo6.writeMicroseconds(frameMid);  
    servo7.writeMicroseconds(frameMid - mag);
    servo8.writeMicroseconds(frameMid);
  }
  
  void SouthW(int mag) {
    servo5.writeMicroseconds(frameMid);
    servo6.writeMicroseconds(frameMid - mag);  
    servo7.writeMicroseconds(frameMid);
    servo8.writeMicroseconds(frameMid + mag);
  }  
  
  void NorthW(int mag) {
    servo5.writeMicroseconds(frameMid - mag);
    servo6.writeMicroseconds(frameMid);  
    servo7.writeMicroseconds(frameMid + mag);
    servo8.writeMicroseconds(frameMid);
  }  
  
  
  
  
  
  
  
  
  
  
  
  
  




