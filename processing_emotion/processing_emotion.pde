 //serial port stuff
import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPortSend;  // The serial port
Serial myPortReceive;  // The serial port
//serial port stuff END

//keep the sensor distances consistent
int arduinoMaxDist = 200;

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
float dangerZone = 25;

//in the boxes
boolean inBox = false;
boolean inClear = false;

//array of people coordinates
int arrayLength = 8;
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
int inZone0 = 0;
int inZone1 = 0;
int inZone2 = 0;
int inZone3 = 0;

//directions
float north;
float south;
float east;
float west;
float NE;
float SE;
float SW;
float NW;

//time
int time;
int s;
int periodLength = 5;
int remover = -periodLength;
int current = s;

int pTime = 50;
int sendTime;
int sendRemover = -pTime;
boolean sendTimeOnce = false;
boolean trigger = false;
boolean peopleClose = false;


//most used zone every 'x' seconds
boolean timeRunOnce = true;
int periodBuffer = 30;
int zone1Counter = 0;
int zone2Counter = 0;
int zone3Counter = 0;
int mostUsedZone;  //1:danger, 2:good, 3:outer, 0:null

//=================Complex emotions (1-8)
//ecstatic
//enthusiastic
//relaxed
//nonchalont
//dissapointed
//defeated
//frustrated
//irritated

//number of complex emotions
int emoNumb = 8;
//positions
float [] comEmoPosX = new float[emoNumb];
float [] comEmoPosY = new float[emoNumb];
//size
float [] comEmoSizeX = new float[emoNumb];
float [] comEmoSizeY = new float[emoNumb];
//emotion enhancement
float [] emoXPlus = new float[emoNumb];
float [] emoYPlus = new float[emoNumb];
//which complex emotion is active
int activeBox;

//danger zone detection and direction
boolean danger = false;
int dangerDirection = 0;

//random coord for paint drop
int randX;
int randY;

String curEmo = "none";

float zero = rectCenterX-rectSize/2;

//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup() {
  //================================================================= SERIAL PORT STUFF
  // Open the port you are using at the rate you want:
  myPortReceive = new Serial(this, "/dev/tty.usbmodem1421", 115200);
  myPortSend = new Serial(this, "/dev/tty.usbserial-A601EYT9", 115200);
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
  comEmoPosX[0] = zero;         comEmoPosY[0] = zero+50;     comEmoSizeX[0] = 80;     comEmoSizeY[0] = 150;    emoXPlus[0] = -3;    emoYPlus[0] = -3;
  comEmoPosX[1] = zero+85;      comEmoPosY[1] = zero+60;     comEmoSizeX[1] = 80;     comEmoSizeY[1] = 90;     emoXPlus[1] = -3;    emoYPlus[1] = -1.5;
  comEmoPosX[2] = zero+220;     comEmoPosY[2] = zero+20;     comEmoSizeX[2] = 120;    comEmoSizeY[2] = 120;    emoXPlus[2] = 1;     emoYPlus[2] = -2;
  comEmoPosX[3] = zero+205;     comEmoPosY[3] = zero+125;    comEmoSizeX[3] = 120;    comEmoSizeY[3] = 30;     emoXPlus[3] = -1;    emoYPlus[3] = 0;
  comEmoPosX[4] = zero+190;     comEmoPosY[4] = zero+190;    comEmoSizeX[4] = 90;     comEmoSizeY[4] = 80;     emoXPlus[4] = 0;     emoYPlus[4] = -1.5;
  comEmoPosX[5] = zero+170;     comEmoPosY[5] = zero+250;    comEmoSizeX[5] = 140;    comEmoSizeY[5] = 30;     emoXPlus[5] = 2;     emoYPlus[5] = -2;
  comEmoPosX[6] = zero+20;      comEmoPosY[6] = zero+230;    comEmoSizeX[6] = 80;     comEmoSizeY[6] = 100;    emoXPlus[6] = -2;    emoYPlus[6] = 1;
  comEmoPosX[7] = zero+105;     comEmoPosY[7] = zero+160;    comEmoSizeX[7] = 75;     comEmoSizeY[7] = 80;     emoXPlus[7] = -1.5;  emoYPlus[7] = 1;

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
  //peopleDisplay();      //people display

  emotionDot();         //emotion point logic
  emotionDisplay();     //emotion point display
  bufferDisplay();    //emotion buffer display

  sender();

    //testing random numbers
//  int randtest = int(150+random(0,1)*550);
//  int randtest2 = int(100+random(0,1)*500);
//  println("x: " + randtest + "        " + "y: " + randtest2);

}


//=================================================================//
//============================ EMOTION ============================//
//=================================================================//

void emotionDot () {

    peopleInZones();
    mostUsedZone();
    
    activeBox = 0;
    for(int i = 0 ; i < emoNumb ; i++){
      ifEmoInBox(comEmoPosX[i], comEmoPosY[i], comEmoSizeX[i], comEmoSizeY[i], i+1);
    } 
    
    
    
    //-----------------------------------------------------emotion movement logic
    
    //major event
    if(trigger == true){
      //===================================================== Most Populated Zone
      //println(mostUsedZone);
      if(mostUsedZone == 0){
        //move to center if nothing is happening
        if(posX > rectCenterX+3){moveX += -5;}
        if(posX < rectCenterX+3){moveX += 5;}
        if(posY > rectCenterY+3){moveY += -5;}
        if(posY < rectCenterY+3){moveY += 5;}    
      }      
      //3 boundries
      if(mostUsedZone == 1){moveX += -5; moveY += -4;}
      if(mostUsedZone == 2){moveX += 2;  moveY += -5;}
      if(mostUsedZone == 3){moveX += 4; moveY += 7;}
      //two+ equal
      if(mostUsedZone == 4){moveX -= 0.2; moveY += 0.3;}
      //===================================================== Current Complex Zone
      for(int i = 0 ; i < emoNumb ; i++){
        if(activeBox == i){
          posX = posX + emoXPlus[i];
          posY = posY + emoYPlus[i];
        }
      }
      
      
    }
    
    //constant update
    if(inZone1 > 0){moveX += -0.08; moveY += -0.05;}
    if(inZone2 > 0){moveX += 0.05; moveY += -0.05;}
    if(inZone3 > 0){
      moveX -= 0.05; 
      if(posX > rectCenterY) {moveY += -0.3;}
      if(posX < rectCenterY) {moveY += 0.5;}
    }
    if(inZone0 == 8){
      //move to center if nothing is happening
      if(posX > rectCenterX){moveX += -0.06;}
      if(posX < rectCenterX){moveX += 0.06;}
      if(posY > rectCenterY){moveY += -0.06;}
      if(posY < rectCenterY){moveY += 0.06;}    
    
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
      
      //set variable to be the name of the current complex emotion
      if(activeBox == 1){curEmo = "ecstatic";}
      if(activeBox == 2){curEmo = "enthusiastic";}
      if(activeBox == 3){curEmo = "relaxed";}
      if(activeBox == 4){curEmo = "nonchalont";}
      if(activeBox == 5){curEmo = "dissapointed";}
      if(activeBox == 6){curEmo = "defeated";}
      if(activeBox == 7){curEmo = "frustrated";}
      if(activeBox == 8){curEmo = "irritated";}
      
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
    NE = map(movement[4], 0, arduinoMaxDist, 0, halfApp);
    SE = map(movement[5], 0, arduinoMaxDist, 0, halfApp);
    SW = map(movement[6], 0, arduinoMaxDist, 0, halfApp);
    NW = map(movement[7], 0, arduinoMaxDist, 0, halfApp);

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
    //NE values
    ax[4] = int(halfApp + (NE));
    ay[4] = int(halfApp - (NE));   
    //SE
    ax[5] = int(halfApp + (SE));
    ay[5] = int(halfApp + (SE));
    //SW
    ax[6] = int(halfApp - SW);
    ay[6] = int(halfApp + SW);
    //NW 
    ax[7] = int(halfApp - NW);
    ay[7] = int(halfApp - NW);
    
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
        
      //set zone 0 to be no detection by sensor   (value less than 10 for corner)
      if(north <= 10) {personZone[0] = 0;}
      if(east <= 10) {personZone[1] = 0;} 
      if(south <= 10) {personZone[2] = 0;}  
      if(west <= 10) {personZone[3] = 0;}
      
      if(NE <= 10) {personZone[4] = 0;}
      if(SE <= 10) {personZone[5] = 0;} 
      if(SW <= 10) {personZone[6] = 0;}  
      if(NW <= 10) {personZone[7] = 0;}
 
  }
    
    //-------------------------------------------------------------------------------- Count the number of people in zones
    void peopleInZones() {
      //reset number of people in zones
      inZone0 = 0; inZone1 = 0;  inZone2 = 0;  inZone3 = 0;
      
      //reset danger
      dangerDirection = 0;
      danger = false;
      
      for(int i = 0 ; i < arrayLength ; i++){
          checkZone(i);
        //count number of people in Zones
        if(personZone[i] == 1) {inZone1++; dangerDirection=i; danger=true;}
        if(personZone[i] == 2) {inZone2++;}
        if(personZone[i] == 3) {inZone3++;}
        if(personZone[i] == 0) {inZone0++;}
      }
      
//      println("in no Zone: " + inZone0);
//      println("in Zone 1: " + inZone1);
//      println("in Zone 2: " + inZone2);
//      println("in Zone 3: " + inZone3);
//      println(" "); 
    }
    //-------------------------------------------------------------------------------- find most populated zone for every 'x' seconds
    void mostUsedZone() {
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
        if(zone1Counter + zone2Counter >= 600 || zone1Counter + zone3Counter >= 600 || zone2Counter + zone3Counter >= 600){
            mostUsedZone=4;//IF 2+ ZONES ARE EQUAL
        }
        timeRunOnce = true;
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
//  text (s, 20, 20);  
//  text (current, 20, 40);  
//  text (sendTime, 20, 60);
//  text("people close: " + peopleClose, 20, 80);
//  text("danger: " + danger, 20, 100);
//  text("direction: " + dangerDirection, 20, 120);
//  text(activeBox,20,140);
    text(curEmo, 20, 20);
}

//=================================================================//
//============================== TIME =============================//
//=================================================================//

void timeCount() {
  fill(0);
  //start counter
  time = millis();
  s = time/1000;
  
  //time of 0 to periodLength (resetting at end) major event signal
  current = s - remover;
  if (current == periodLength){
    remover = remover += periodLength;
    trigger = true;
  } else {trigger = false;}
  
  //time of sender (0 to pTime)  paint signal
  sendTime = s - sendRemover;
  if(sendTime == pTime){
    sendTimeOnce = true;
    sendRemover = sendRemover += pTime;
  }
  
  //find if anyone was close to the robot before paint time
  if(sendTime > (2*pTime/3) && inZone0 < 8){
    peopleClose = true;
  }
  //reset detection of close people   
  if(sendTime == pTime/2){
     peopleClose = false;
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
    //laptop block direction removal
    distances[2] = 0;
    for (int i = 0 ; i < arrayLength ; i++){
      movement[i] = distances[i];
    }    
     //println(movement);
  }
}

void sender() {
   if(sendTime == 0 && sendTimeOnce == true){
     //determine active box
     println(activeBox);
     myPortSend.write(activeBox+1);     
     //only paint if people are close
     if(peopleClose == true){ 
       println("1");
       myPortSend.write(1);
     }
     sendTimeOnce = false;
    } else {
      //filler
      myPortSend.write(activeBox+1);
    }
    //if danger is detected
    if(danger == true){
      //println(30 + dangerDirection);
      myPortSend.write(30 + dangerDirection);
      } else {
        //filler
        myPortSend.write(0);
      }
}

int clik = 2;

void mouseClicked(){
      //int cycle = 2+ int(random(4));
      println("click"+clik);
      myPortSend.write(clik);
      myPortSend.write(1);
      clik++;
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



















