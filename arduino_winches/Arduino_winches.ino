
//=======================================================//
//======================== SERVO ========================//
//=======================================================// 

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
int microTroub2 = 120;
int microDev;

int mid;
int spiderUp;
int frameMid;
int mag;
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

int zTop = 1900;
int zBot = 1100;
int dropDelay;







//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup()
{
  Serial.begin(300);

  
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
 
    
  mid = 1500;
  spiderUp = mid + 80;
  //ring variables
  frameMid = 1600;
  mag = 250;
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
//  moveX = 150;
//  moveY = 500;
//  moveSpider(moveX, moveY);
  
  paint(3);
  //ring(2700);


}

//=================================================================//
//=============================== LOOP ============================//
//=================================================================//

void loop()
{
 //ring();
 //microTest();
 //sexBot();
}




//=================================================================//
//========================= SMALL FUNCTIONS =======================//
//=================================================================//


void paint(int b) {
  if(b ==3){
    //move over container
    moveX = 850;
    moveY = 400;
    moveSpider(moveX, moveY);
    delay(3000); 
    //drop/raise sponge
    spongeToCont(1850);
    //move to mid
    moveX = 350;
    moveY = 400;
    moveSpider(moveX, moveY);
    delay(3000);
    //clamp
    clamp(1500);
    ring(1500);
  }
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

void startUp() {
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

//=================================================================//
//=============================== MOVE ============================//
//=================================================================//

void moveSpider(int x,int y) {

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
    troubYS = map(y, 0, 400, 0, 150);
    troubYS = 150 - troubYS;
    spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS + troubXY;
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
  s2i = spiderUp + -50 + troub2;
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
}

//=================================================================//
//=============================== RING ============================//
//=================================================================//

 void ring (int d){
 
    //1 up
    servo5.writeMicroseconds(frameMid + mag);
    servo6.writeMicroseconds(frameMid);  
    servo7.writeMicroseconds(frameMid - mag);
    servo8.writeMicroseconds(frameMid);
    clamp(700);
    delay(d);
    //1-2 up
    servo5.writeMicroseconds(frameMid + mag);
    servo6.writeMicroseconds(frameMid + mag);  
    servo7.writeMicroseconds(frameMid - mag);
    servo8.writeMicroseconds(frameMid - mag);
    clamp(700);
    delay(d);
    //2 up
    servo5.writeMicroseconds(frameMid);
    servo6.writeMicroseconds(frameMid + mag);  
    servo7.writeMicroseconds(frameMid);
    servo8.writeMicroseconds(frameMid - mag);
    clamp(700);
    delay(d);
    //2-3 up
    servo5.writeMicroseconds(frameMid - mag);
    servo6.writeMicroseconds(frameMid + mag);  
    servo7.writeMicroseconds(frameMid + mag);
    servo8.writeMicroseconds(frameMid - mag);
    clamp(700);
    delay(d);
    //3 up
    servo5.writeMicroseconds(frameMid - mag);
    servo6.writeMicroseconds(frameMid);  
    servo7.writeMicroseconds(frameMid + mag);
    servo8.writeMicroseconds(frameMid);
    clamp(700);
    delay(d);
    //3-4 up
    servo5.writeMicroseconds(frameMid - mag);
    servo6.writeMicroseconds(frameMid - mag);  
    servo7.writeMicroseconds(frameMid + mag);
    servo8.writeMicroseconds(frameMid + mag);
    clamp(700);
   delay(d); 
    //4 up
    servo5.writeMicroseconds(frameMid);
    servo6.writeMicroseconds(frameMid - mag);  
    servo7.writeMicroseconds(frameMid);
    servo8.writeMicroseconds(frameMid + mag);
    clamp(700);
    delay(d);
    //4-1 up
    servo5.writeMicroseconds(frameMid + mag);
    servo6.writeMicroseconds(frameMid - mag);  
    servo7.writeMicroseconds(frameMid - mag);
    servo8.writeMicroseconds(frameMid + mag);
    clamp(700);
    delay(d);
    //ALL MID
    servo5.writeMicroseconds(frameMid);
    servo6.writeMicroseconds(frameMid);  
    servo7.writeMicroseconds(frameMid);
    servo8.writeMicroseconds(frameMid);   
    clamp(700);
    delay(d);
 }
  

//=================================================================//
//============================ Experiment =========================//
//=================================================================//

//void brain() {
//  int randCont = random(1,5);
//  
//  //troubleshoot
//  randCont = 1;
//  
//  //set basic attributes for the specific container pickup
//  if(randCont == 1){
//    contX = 1100;
//    contY = 400;
//    drop = 1100;
//    dropDelay = 3000;
//  }
//  
//  
//}  
//  
//  
void paint() {
  //================
  //process!!!!!
  //================
  
  //open clamps
  
  //raise sponge
  
  //semi close clamps
  
  //move spider
  
  //open clamps
  
  //drop sponge || Delay || raise sponge
  
  //close clamps
  
  //move to mid
}
//  
//  
//  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  




