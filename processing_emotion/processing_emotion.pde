 //serial port stuff
import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPortSend;  // The serial port
Serial myPortReceive;  // The serial port
//serial port stuff END

int arduinoMaxDist = 300;

//-------------------------------------------------------------------------------- global variables
int appSize = 800;
int halfApp = appSize/2;

//rect center
float rectCenterX = 400;
float rectCenterY = 400;
float rectSize = 250;
float rectHalf = rectSize/2;

//zones
float outerZone = appSize;
float goodZone = 150;
float dangerZone = 15;

//in the boxes
boolean inBox = false;
boolean inClear = false;

//array of people coordinates
int arrayLength = 4;
int [] ax = new int[arrayLength];
int [] ay = new int[arrayLength];
int [] aZone = new int[arrayLength];
int [] personZone = new int[arrayLength];

int numberOfPeople = 0;


int[] distances = new int[arrayLength];
int[] movement = new int[arrayLength];

//position of emotion dot
float moveX = 0;
float moveY = 0;
float posX = rectCenterX;
float posY = rectCenterY;

//buffer emotion
float bufferLimit = 200;
float bufferOrigin = rectHalf;

float bufferH = bufferOrigin;
float bufferS = bufferOrigin;
float bufferE = bufferOrigin;
float bufferC = bufferOrigin;


//person position *Random movement*
float pMoveX = 0;
float pMoveY = 0;

//time
int t1;
int t2;

//in zones
int inZone1 = 0;
int inZone2 = 0;
int inZone3 = 0;

//directions
float north;
float south;
float east;
float west;

//time
int time;
int s;
int periodLength = 5;
int remover = -periodLength;
int current = s;

//most used zone every 'x' seconds
boolean timeRunOnce = true;
int periodBuffer = 30;
int zone1Counter = 0;
int zone2Counter = 0;
int zone3Counter = 0;
int mostUsedZone;  //1:danger, 2:good, 3:outer, 0:null

//complex emotion box width
int ecstatic = 50;
int enthusiastic = 50;
int relaxed = 50;
int nonchalont = 50;
int dissapointed = 50;
int defeated = 50;
int frustrated = 50;
int irritated = 50;

int emoNumb = 8;

float [] comEmoPosX = new float[emoNumb];
float [] comEmoPosY = new float[emoNumb];
float [] comEmoSizeX = new float[emoNumb];
float [] comEmoSizeY = new float[emoNumb];
int activeBox;

float zero = rectCenterX-rectSize/2;

//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup() {
  //================================================================= SERIAL PORT STUFF
  // Open the port you are using at the rate you want:
  myPortReceive = new Serial(this, "/dev/tty.usbmodem1a1331", 115200);
  myPortSend = new Serial(this, "/dev/tty.usbserial-A601EWK6", 115200);
  //myPort.clear();
  myString = myPortReceive.readStringUntil(lf);
  //TO SEND
  //================================================================= SERIAL PORT STUFF END
  size(appSize, appSize);
  background(255, 255, 255);

  //-- set initial position --//
  for (int i = 0; i < arrayLength; i++) {
    ax [i] = 0;
    ay [i] = 0;
    aZone[i] = 0;
  }
  
  //complex emotion points and sizes
  comEmoPosX[0] = zero;         comEmoPosY[0] = zero+50;     comEmoSizeX[0] = 80;     comEmoSizeY[0] = 150;
  comEmoPosX[1] = zero+85;      comEmoPosY[1] = zero+60;     comEmoSizeX[1] = 80;     comEmoSizeY[1] = 90;
  comEmoPosX[2] = zero+220;     comEmoPosY[2] = zero+20;     comEmoSizeX[2] = 120;    comEmoSizeY[2] = 120;
  comEmoPosX[3] = zero+205;     comEmoPosY[3] = zero+125;    comEmoSizeX[3] = 120;    comEmoSizeY[3] = 30;
  comEmoPosX[4] = zero+190;     comEmoPosY[4] = zero+190;    comEmoSizeX[4] = 90;     comEmoSizeY[4] = 80;
  comEmoPosX[5] = zero+170;     comEmoPosY[5] = zero+250;    comEmoSizeX[5] = 140;    comEmoSizeY[5] = 30;
  comEmoPosX[6] = zero+20;      comEmoPosY[6] = zero+230;    comEmoSizeX[6] = 80;     comEmoSizeY[6] = 100;
  comEmoPosX[7] = zero+105;     comEmoPosY[7] = zero+160;    comEmoSizeX[7] = 75;    comEmoSizeY[7] = 80;

}

//=================================================================//
//============================== DRAW =============================//
//=================================================================//

void draw() {

  backgroundDisplay();  //make the background boxes
  textDisplay();
  emotionGridDisplay(); //make the emotion box & grid
  complexEmotions();
  
  timeCount();          //time logic
  timeDisplay();        //display time counters
  
  movePerson();         //people movement logic
  peopleDisplay();      //people display

  emotionDot();         //emotion point logic
  emotionDisplay();     //emotion point display
  //bufferDisplay();      //emotion buffer display


  mostusedZone();
}


//=================================================================//
//============================ EMOTION ============================//
//=================================================================//

void emotionDot () {

    peopleInZones();
    
    activeBox = 0;
    for(int i = 0 ; i < emoNumb ; i++){
      ifEmoInBox(comEmoPosX[i], comEmoPosY[i], comEmoSizeX[i], comEmoSizeY[i], i+1);
    }
    
    //-----------------------------------------------------movement logic
    //if more people in good than outer
    if(inZone1 > 0){
      moveX -= 0.5;
      moveY -= 0.5;
     } else {
      moveX += 0.5;
      moveY += 0.5;
     }
    
    


  //limit emotion point to buffer
  if(rectCenterX + moveX >= rectCenterX + bufferC) {moveX = bufferC;}
  if(rectCenterX + moveX <= rectCenterX - bufferE) {moveX = -bufferE;}
  if(rectCenterY + moveY >= rectCenterY + bufferS) {moveY = bufferS;}
  if(rectCenterY + moveY <= rectCenterY - bufferH) {moveY = -bufferH;}  
  
  //MOVE THE DOT
  posX = rectCenterX + moveX;
  posY = rectCenterY + moveY;
  
  //-------MOVE THE BUFFER
  // to outer limit
  if(posX >= (rectCenterX + bufferC - 5) && bufferC <= bufferLimit){bufferC += 0.5;}else{bufferC -= 0.5;}
  if(posX <= (rectCenterX - bufferE + 5) && bufferE <= bufferLimit){bufferE += 0.5;}else{bufferE -= 0.5;}
  if(posY >= (rectCenterY + bufferS - 5) && bufferS <= bufferLimit){bufferS += 0.5;}else{bufferS -= 0.5;}
  if(posY <= (rectCenterY - bufferH + 5) && bufferH <= bufferLimit){bufferH += 0.5;}else{bufferH -= 0.5;}
  // to min
  if(bufferC <= bufferOrigin){bufferC = bufferOrigin;}
  if(bufferE <= bufferOrigin){bufferE = bufferOrigin;}
  if(bufferS <= bufferOrigin){bufferS = bufferOrigin;}
  if(bufferH <= bufferOrigin){bufferH = bufferOrigin;}
  //to minimum


  //restrict movement    
  if (posX > (rectCenterX+rectHalf) ) {
    posX = rectCenterX+rectHalf;
  }
  if (posX < (rectCenterX-rectHalf) ) {
    posX = rectCenterX-rectHalf;
  }
  if (posY > (rectCenterY+rectHalf) ) {
    posY = rectCenterX+rectHalf;
  }
  if (posY < (rectCenterY-rectHalf) ) {
    posY = rectCenterX-rectHalf;
  }
}

    //=================================================================//
    //===================== EMOtiON SUB FUNCTIONS =====================//
    //=================================================================//

    void ifEmoInBox(float boxX, float boxY, float distX, float distY, int within) {
      //check within boundries
      if(posX >= (boxX-(distX/2)) && posX <= (boxX+(distX/2)) && posY >= (boxY-(distY/2)) && posY <= (boxY+(distY/2))){
          activeBox = within;
      }
    println(activeBox);
    }



//=================================================================//
//============================= PEOPLE ============================//
//=================================================================//
void movePerson() {
  rectMode(CENTER);
    //println(movement);
    //println(" ");
    north = map(movement[0], 0, arduinoMaxDist, 0, halfApp);
    east = map(movement[1], 0, arduinoMaxDist, 0, halfApp);
    south = map(movement[2], 0, arduinoMaxDist, 0, halfApp);   
    west = map(movement[3], 0, arduinoMaxDist, 0, halfApp);  

    //north values
    ay[0] = int(halfApp - north);
    ax[0] = halfApp;
    //east values
    ax[1] = int(halfApp + east);
    ay[1] = halfApp;
    //south values
    ay[2] = int(halfApp + south);
    ax[2] = halfApp;    
    //west values
    ax[3] = int(halfApp - west);
    ay[3] = halfApp;       
}


    //=================================================================//
    //====================== PEOPLE SUB FUNCTIONS =====================//
    //=================================================================//
    
    //-------------------------------------------------------------------------------- Check what zone people are in
    void checkZone(int i ) {
          //within bounds of app
      if((  ax[i] > 0 && ax[i] < appSize  )      &&      (  ay[i] > 0 && ay[i] < appSize  )) {personZone[i] = 3;}
          //if within good zone
      if((  ax[i] > (rectCenterX - rectHalf - goodZone)  )  &&  (  ax[i] < (rectCenterX + rectHalf + goodZone)  )      &&      (  ay[i] > (rectCenterY - rectHalf - goodZone)  )  &&  (  ay[i] < (rectCenterY + rectHalf + goodZone)  )) {personZone[i] = 2;} 
          //if within danger zone
      if((  ax[i] > (rectCenterX - rectHalf - dangerZone)  ) &&  (  ax[i] < (rectCenterX + rectHalf + dangerZone)  )       &&      (  ay[i] > (rectCenterY - rectHalf - dangerZone)  ) &&  (  ay[i] < (rectCenterY + rectHalf + dangerZone)  )) {personZone[i] = 1;} 
        
      //set zone 0 to be no detection by sensor   
      if(north == 0) {personZone[0] = 0;}  if(east == 0) {personZone[1] = 0;}  if(south == 0) {personZone[2] = 0;}  if(west == 0) {personZone[3] = 0;}
 
  }
    
    //-------------------------------------------------------------------------------- Count the number of people in zones
    void peopleInZones() {
      //reset number of people in zones
      inZone1 = 0;  inZone2 = 0;  inZone3 = 0;
      
      for(int i = 0 ; i < arrayLength ; i++){
        checkZone(i);
        //count number of people in Zones
        if(personZone[i] == 1) {inZone1++;}
        if(personZone[i] == 2) {inZone2++;}
        if(personZone[i] == 3) {inZone3++;}
        
      }
    }
    //-------------------------------------------------------------------------------- find most populated zone for every 'x' seconds
    void mostusedZone() {
      //run once at 0 seconds
      if(current == 0 && timeRunOnce == true){
        zone1Counter = 0;        zone2Counter = 0;        zone3Counter = 0;
        timeRunOnce = false;
      }
      
      //run while between 0 and 'x' seconds
      if(current >= 0 && current <= 5){
        peopleInZones();
        
        if(inZone1 != 0){zone1Counter++;}
        if(inZone2 != 0){zone2Counter++;}
        if(inZone3 != 0){zone3Counter++;}

      }
      
      //run once at 5 seconds
      if (current == 5 && timeRunOnce == false){
        int a = max(zone1Counter, zone2Counter, zone3Counter);
        //most used individually
        if(a == zone1Counter && zone1Counter > periodBuffer) {mostUsedZone=1;}
        if(a == zone2Counter && zone2Counter > periodBuffer) {mostUsedZone=2;}
        if(a == zone3Counter && zone3Counter > periodBuffer) {mostUsedZone=3;}
        //any detection lasting under 'x' time is not recognised
        if(a <= periodBuffer) {mostUsedZone=0;}
        //if multiple most used
        println(zone1Counter);
        println(zone2Counter);
        println(zone3Counter);
        println(" ");
        if(zone1Counter + zone2Counter >= 600 || zone1Counter + zone3Counter >= 600 || zone2Counter + zone3Counter >= 600){
          println("rekt");
        }
        
        
        timeRunOnce = true;
        
        //println(mostUsedZone);
      }
      
      
    }
   
    

//=================================================================//
//============================ DISPLAY ============================//
//=================================================================//

//-------------------------------------------------------------------------------- DISPLAY BACKGROUND
void backgroundDisplay (){

  noStroke();
  //boolean determines if a zone is occupied by ANYONE
  boolean trigger3 = false;
  boolean trigger2 = false;
  boolean trigger1 = false;
  for(int i = 0 ; i < personZone.length ; i++) {
    if(personZone[i] == 3){     trigger3 = true;     }
    if(personZone[i] == 2){     trigger2 = true;     }
    if(personZone[i] == 1){     trigger1 = true;     }
  }

  if(trigger3 == true){  fill(150, 150, 255);  }else{  fill(255);  }
  rect(rectCenterX, rectCenterY, outerZone, outerZone);
  
  if(trigger2 == true){  fill(150, 255, 150);  }else{  fill(255);  }
  rect(rectCenterX, rectCenterY, rectSize+goodZone*2, rectSize+goodZone*2);
  
  if(trigger1 == true){  fill(255, 0, 0);  }else{  fill(255);  }
  rect(rectCenterX, rectCenterY, rectSize+dangerZone*2, rectSize+dangerZone*2);
 
}

//-------------------------------------------------------------------------------- DISPLAY FEELING TEXT
void textDisplay() {
  // text around the rectangle
  fill(0);
  text ( "Happy", rectCenterX-20, rectCenterY-180); 
  text ( "Sad", rectCenterX-5, rectCenterY+180); 
  text ( "Excited", rectCenterX-210, rectCenterY-10); 
  text ( "Calm", rectCenterX+180, rectCenterY-10);  
}

//-------------------------------------------------------------------------------- DISPLAY EMOTION GRID
void emotionGridDisplay () {
  fill(255);
  strokeWeight(0);
  stroke(0);
  rect(rectCenterX, rectCenterY, rectSize, rectSize);

  for (int i = 0; i < 10; i++) {
    rectMode(CENTER);
    stroke(0);
    noFill();
    rect(rectCenterX, rectCenterY, (rectSize/10)*i, (rectSize/10)*i);
  }  
}

//-------------------------------------------------------------------------------- DISPLAY COMPLEX EMOTIONS
void complexEmotions () {

  rectMode(CENTER);
  strokeWeight(1);
  stroke(50);
  
  for(int i = 0 ; i < emoNumb ; i++){
     rect(comEmoPosX[i], comEmoPosY[i], comEmoSizeX[i], comEmoSizeY[i]);
  }
}

//-------------------------------------------------------------------------------- DISPLAY EMOTION DOT AND BUFFER
void emotionDisplay () {
  //Emotion dot
  fill(50, 100, 50);
  ellipse(posX, posY, 10, 10);
}

void bufferDisplay() {
  stroke(0,150,150);
  strokeWeight(2);
  line(rectCenterX - bufferE, rectCenterY - bufferH, rectCenterX + bufferC, rectCenterY -bufferH);    //happy line
  line(rectCenterX + bufferC, rectCenterY - bufferH, rectCenterX + bufferC, rectCenterY + bufferS);   //calm line
  line(rectCenterX - bufferE, rectCenterY + bufferS, rectCenterX + bufferC, rectCenterY + bufferS);   //sad line
  line(rectCenterX - bufferE, rectCenterY - bufferH, rectCenterX - bufferE, rectCenterY + bufferS);   //excited line
  strokeWeight(1);
}

//-------------------------------------------------------------------------------- DISPLAY PEOPLE
void peopleDisplay() {
  noStroke();
  for(int i = 0 ; i < arrayLength ; i++){
    //dont display a person if it is not within a zone
    if(personZone[i] != 0){
      rect(ax[i], ay[i], 20, 20);
    }
  }
}
//-------------------------------------------------------------------------------- DISPLAY TIME
void timeDisplay() {
  text (s, 20, 20);  
  text (current, 20, 40);  
}

//=================================================================//
//============================== TIME =============================//
//=================================================================//

void timeCount() {
  fill(0);
  //start counter
  time = millis();
  s = time/1000;
  //time of 0 to periodLength (resetting at end)
  current = s - remover;
  if (current == periodLength){
    remover = remover += periodLength;
  }
}


//=================================================================//
//===================== SERIAL PORT FUNCTION ======================//
//=================================================================//

void serialEvent(Serial myPortReceive) {
  myString = myPortReceive.readStringUntil(lf);
  if (myString != null) {
    myString = trim(myString);
    int[] distances = int(split(myString, " "));
    for (int i = 0 ; i < arrayLength ; i++){
      movement[i] = distances[i];
    }    
     //println(distances);
  }
}

//=================================================================//
//============================= UNUSED ============================//
//=================================================================//

//---------------------------------------------------------------------------------------------------- people position within emotion grid
/*
//check if in emotion container
void inBox () {
  if (( (mouseX < rectCenterX-rectHalf-10) || (mouseX > rectCenterX+rectHalf+10) ) || ( (mouseY < rectCenterX-rectHalf-10) || (mouseY > rectCenterX+rectHalf+10) ) ) {
    inBox = false;
  } else {
    inBox= true;
  }
}

//check if in clear
void inClear() {
  if (( (mouseX < 10) || (mouseX > 110) ) || ( (mouseY < 13) || (mouseY > 37) ) ) {
    inClear = false;
  } else {
    inClear= true;
  }
}
*/



















