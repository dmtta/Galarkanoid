//     ______        __ ___           __                         _      __
//    / ____/____ _ / //   |   _____ / /__ ____ _ ____   ____   (_)____/ /
//   / / __ / __ `// // /| |  / ___// //_// __ `// __ \ / __ \ / // __  / 
//  / /_/ // /_/ // // ___ | / /   / ,<  / /_/ // / / // /_/ // // /_/ /  
//  \____/ \__,_//_//_/  |_|/_/   /_/|_| \__,_//_/ /_/ \____//_/ \__,_/   
//                                                                     v 1.0
//  
// Daniel Mastretta Jiménez // MFADT DEC 2013
//
// Galarkanoid is a top-down shooter set in the distant spaceworld of fuckthiscode
// Evil walls are about to destroy the universe, you must destroy all the walls before 
// existence is obliterated. You are the pilot of Viper, the last ship remaining!
//
// GO SPACE COWBOY!!!! BRING THOSE WALLS DOWN AND BECOME A HERO!!!!!

//...................................................................LIBRARIES
import ddf.minim.* ;
Minim minim;
AudioPlayer laser, block, bump, bgspace, bggameover;
//...................................................................GLOBAL VARIABLES
int score; // Score of the actual play
int highScore; // Best Score since the game existed
String scorePath; //The path where my file will be read from and saved to
int event; // Events are different states of the game, this keeps the count.
boolean pLeft; // Booleans that check if keys are pressed or not. goto: void keyPressed and void keyReleased.
boolean pRight; // Movement Boolean
boolean nextScreen; // Checks to advance to the next game screen
boolean l1end; // Checks if Level 1 has ended
boolean safeScore;
int bumplimits; // Graphical, checks where the debris should be bumping on the sides
//...................................................................GRAPHICAL VARIABLES
PFont specFont; // Main pixelated font.
PImage logoPNG; // Galarkanoid Logo
PImage brick; // LVL1 Brick
PImage gui; // Game's GUI
PImage debPNG; // Debris PNG
int logoX; // Position for the Galarkanoid Logo
int logoY; // Position for the Galarkanoid Logo
int nColumns; // Columns of the first level brick wall
int xSpacing; // Spacing in X for the first level brick wall
int ySpacing; // Spacing in Y for the first level brick wall
int stars; // number of Stars
int[] starSpeed; // Randomizer fot star speed
int[] x; // X Star positions
int[] y; // Y Star positions
//................................................................... TIMERS AND COUTDOWNS
int c; //time
int csec;
int climit; //This adds minutes to the countdown (climit = X eq. X minutes)
int lastMillis;
boolean newTimer;
boolean newGameTimer;
//...................................................................OBJECT AND OBJECT ARRAY CALLING
Timer timer;
Viper viper; // Initializes the ship
ArrayList<Laser> shots; // ArrayList that initializes lasers
ArrayList<Debris> deb; // ArrayList that initializes debris
ArrayList<BlueBrick> blueBricks;  // ArrayList that initializes first level bricks

//public void init() { 
//  frame.removeNotify(); 
//  frame.setUndecorated(true); 
//  frame.addNotify(); 
//  frame.setLocation(0, 0);
//  frame.setBackground(  new     java.awt.Color(  0, 0, 0  ));
//  super.init();
//}  a

void setup() {  //-------------------------------------------------------------------------------------------------------- GAME SETUP (RUNS ONCE)

  gameReset();
  constants();
} //-------------------------------------------------------------------------------------------------------- END OF SETUP


void draw() {

  switch(event) {

    //--------------------------------------------------------- INITIAL ANIMATION SCREEN  
  case 0:

    background(0);
    bgspace.play();
    starfield();
    image(gui, width/2, height/2);
    image(logoPNG, logoX, logoY);
    textAlign(CENTER);
    textFont(specFont);
    text("Press A to start", width/2, 500);
    text("Daniel Mastretta Jimenez .2013", width/2, 630);
    if (nextScreen == true) { 
      nextScreen = false;
      event=1;
    }

    break;

    //--------------------------------------------------------- TUTORIAL SCREEN  
  case 1:

    background(0);
    starfield();
    image(gui, width/2, height/2);
    text("Ship moves LEFT and RIGHT with arrows.", width/2, 150);
    text("Press Z to shoot at the wall.", width/2, 180);
    text("The wall will shoot back.", width/2, 210);
    text("Destroy it before the time is over.", width/2, 240);
    text("Each block is worth 10 points.", width/2, 270);
    text("Remaining time is added to the score.", width/2, 300);
    text("Press A to start", width/2, 500);
    if (nextScreen == true) { 
      nextScreen = false;
      newTimer = true;
      event=2;
    }
    break;

    //--------------------------------------------------------- LEVEL 1  
  case 2:

    background(0);
    starfield();
    image(gui, width/2, height/2);
    viper.ship();

    shipDebrisCol() ;
    debrisCheck(); 
    brickCol();  
    for (int i=blueBricks.size()-1;i>=0;i--) {
      blueBricks.get(i).display();
    }
    for (int i=deb.size()-1;i>=0;i--) {
      deb.get(i).display();
    }

    countdown();
    score();
    levelOneEndCheck();
    if (l1end == true) {
      safeScore = true;
      event = 11;
    }



    break;

    //---------------------------------------------------------GAME OVER SCREEN  
  case 10:
    background(0);
    starfield();
    saveScore();
    bggameover.play();
    image(gui, width/2, height/2);
    text("YOU SUCK.", width/2, 150);
    text("YOUR SOUL WILL FOREVER DRIFT IN SPACE.", width/2, 200);
    text ("FINAL SCORE:  "+score, width/2, 250);
    text ("HIGH SCORE:  "+highScore, width/2, 270);
    text("Press P to reset.", width/2, 500);  

    if (timer.isFinished()) {
      fill(#00FF00);
      text ("You can restart now, keep building your score.", width/2, 410); 
      safeScore = true;
    } 
    else { 
      fill(#FF0000);
      text ("Don't reset for "+((timer.passedTime-timer.totalTime)/1000*-1)+" seconds to keep your score", width/2, 410);
    }
    break;

    //---------------------------------------------------------WINNER SCREEN  
  case 11:
    background(0);
    starfield();
    saveScore();
    image(gui, width/2, height/2);
    text("A WINNER IS YOU.", width/2, 150);
    text("YOU SAVED THE UNIVERSE.", width/2, 200);
    text ("FINAL SCORE:  "+score, width/2, 250);
    text ("HIGH SCORE:  "+highScore, width/2, 270);
    fill(#00FF00);
    text ("You can restart now, keep building your score.", width/2, 410); 
    fill(#FFFFFF);
    text("Press P to reset.", width/2, 500);
    break;
  }
}

void keyPressed() {

  //PLAYER KEYS
  if (keyCode==LEFT) {
    pLeft = true;
  }
  if (keyCode==RIGHT) {
    pRight = true;
  }
  //  if (key=='Z' ||key=='z') {
  //    pShot = true;
  //  }
  if (key=='Q' || key=='q') {
    event = 0;
  }
}

void keyReleased() {

  //PLAYER KEYS
  if (keyCode==LEFT) {
    pLeft = false;
    viper.vPNG = loadImage("shipViper.png");
  }
  if (keyCode==RIGHT) {
    pRight = false;
    viper.vPNG = loadImage("shipViper.png");
  }

  if (key=='Z' ||key=='z') {
    shots.add(new Laser(viper.xPos, viper.yPos-25));
    laser.play();
    laser.rewind();
  }

  if (key=='A' ||key=='a') {
    nextScreen = true;
  }

  if (key=='P' ||key=='p') {
    if (safeScore == false) score = 0;
    minim.stop();
    gameReset();
  }
}

void starfield() {
  for (int i=0; i<stars; i++) {
    fill(255);
    stroke(1);
    rect(x[i], y[i], 2, 2);
  }

  for (int i=0;i<stars;i++) {
    y[i]+= starSpeed[i];
    if (y[i] > height) {
      y[i] = int(random(-100, 0));
    }
  }
}

void brickCol() {

  for (int i=shots.size()-1; i>=0; i--) {

    shots.get(i).display();

    if (shots.get(i).laserY <= 0) {
      shots.remove(i);
      break;
    }

    for (int g=blueBricks.size()-1;g>=0;g--) {

      // This is the collision check for bricks & shots
      boolean top, bottom, left, right;

      top=shots.get(i).laserY > ((blueBricks.get(g).bY)-(blueBricks.get(g).bHeight/2));
      bottom=shots.get(i).laserY < ((blueBricks.get(g).bY)+(blueBricks.get(g).bHeight/2));
      left= shots.get(i).laserX > ((blueBricks.get(g).bX)-(blueBricks.get(g).bWidth/2));
      right= shots.get(i).laserX < ((blueBricks.get(g).bX)+(blueBricks.get(g).bWidth/2));



      if (top && bottom && left && right == true) {

        deb.add(new Debris(blueBricks.get(g).bX, blueBricks.get(g).bY, int(random(-1, -5)), int(random(2, 4))));
        deb.add(new Debris(blueBricks.get(g).bX, blueBricks.get(g).bY, int(random(-4, 4)), int(random(2, 4))));
        deb.add(new Debris(blueBricks.get(g).bX, blueBricks.get(g).bY, int(random(1, 5)), int(random(2, 4))));

        shots.remove(i);
        block.play();
        block.rewind();
        blueBricks.remove(g); 
        score = score + 1;  
        break;
      }
    }
  }
}

void debrisCheck() {

  for (int i=deb.size()-1;i>=0;i--) {
    if (deb.get(i).debrisY >= height) deb.remove(i);
    break;
  }
}

void levelOneEndCheck() {
  if (blueBricks.size() == 0) { 
    l1end = true;
    score = score + csec;
  }
}

void shipDebrisCol() {

  for (int h=deb.size()-1;h>=0;h--) {

    // This is the collision check for shots & ship
    boolean topS, bottomS, leftS, rightS;

    topS = deb.get(h).debrisY > viper.yPos-15;
    bottomS = deb.get(h).debrisY < viper.yPos+15;
    leftS= deb.get(h).debrisX > viper.xPos-10;
    rightS= deb.get(h).debrisX < viper.xPos+10;

    if (topS && bottomS && leftS && rightS == true) {
      timer.start();
      bgspace.pause();
      event = 10;
    }
  }
}

void countdown() {
  if (newTimer == true) {
    lastMillis = millis();
    newTimer = false;
  }

  c = climit*60*1000+lastMillis - millis();
  csec = (c/(1000));
  text ("TIME LEFT:  "+csec, 100, 30);
  if (csec <= 0) event = 10;
}

void score() {
  text ("SCORE:  "+score, 100, 50);
}

void saveScore() {

  if (score > highScore) {
    String[] saveScore = new String[1];
    saveScore[0] = nf(score, 0, 0);
    saveStrings(scorePath, saveScore);
    String[] tempArray = loadStrings(scorePath);  
    highScore = parseInt(tempArray[0]);
  }
}

void saveTime() {
}

void stop()//------------------ Part of sound library
{
  minim.stop() ;
  super.stop() ;
}

void gameReset() {  //-------------------------------------------------------------------------------------------------------- GAME SETUP (RUNS ONCE)

  //---------------------------- General Graphic Setup
  size (480, 640);
  frameRate(60);
  smooth();
  rectMode(CENTER);
  imageMode(CENTER);
  bumplimits = 25;
  //---------------------------- Object and Array Setup 
  viper = new Viper();
  shots = new ArrayList<Laser>();
  deb = new ArrayList<Debris>();
  blueBricks = new ArrayList<BlueBrick>();
  //---------------------------- Image setup  
  brick = loadImage("blockOne.png");
  gui = loadImage("gui.png");
  logoPNG = loadImage("logo.png");
  logoX = width/2 ;
  logoY = height/2-50;
  debPNG = loadImage("shot1.png");
  specFont = loadFont("square.vlw");
  //---------------------------- Sound Setup
  minim = new Minim(this) ;
  laser = minim.loadFile("laser.wav") ;
  bump = minim.loadFile("bump.wav") ;
  block = minim.loadFile("block.wav") ;
  bgspace = minim.loadFile("fireeye.mp3");
  bggameover = minim.loadFile("cemetary.mp3");

  //---------------------------- Starfield Setup  
  stars = 200;
  starSpeed = new int [stars];
  x = new int [stars];
  y = new int [stars];
  for (int i = 0; i < stars; i++) {
    x[i] = int(random(0, width));
    y[i] = int(random(0, height));
    starSpeed[i] = int(random(0, 7));
  }
  //---------------------------- Movement Booleans   
  pLeft = false;
  pRight = false;
  //---------------------------- Scoring
  scorePath = "highScore.txt";
  String[] tempArray = loadStrings(scorePath);
  highScore = parseInt(tempArray[0]);
  safeScore = false;
  //---------------------------- Time Check
  newGameTimer = false;
  timer = new Timer(120000);
  //---------------------------- LVL 1 Brick Positions Math  
  nColumns = 9;
  xSpacing = 50;
  ySpacing = 30;
  for (int i=0;i<=62;i++) {
    int x = (i % nColumns) * xSpacing;
    int y = (i / nColumns) * ySpacing;
    blueBricks.add(new BlueBrick(x+40, y+100));
  }
  //---------------------------- Level Managing Variables  
  nextScreen = false;
  l1end = false;
  event = 0; // This variable controls the events. Every event is a different state of the game.
  //---------------------------- Time Counter for Game Over
  climit = 1;
  c = climit*60*1000 - millis();
  csec = (c/(1000));
  newTimer = false;
  lastMillis = millis();
}

void constants() {
  score = 0;
}

class BlueBrick {

  int bX;
  int bY;
  int bHeight;
  int bWidth;

  BlueBrick(int _bX, int _bY) {
   
    bX = _bX;
    bY = _bY;
    bHeight = 20;
    bWidth = 45;
  }

  void display() {
    image(brick, bX, bY);
    }
// 
// stroke(#0000FF);
// noFill();
// rect (bX,bY,bWidth,bHeight);
  }


class Debris {

  int debrisX;
  int debrisY;
  int dXSpeed;
  int dYSpeed;

  Debris(int _debrisX, int _debrisY, int _dXSpeed, int _dYSpeed) {
    debrisX = _debrisX;
    debrisY = _debrisY;
    dXSpeed = _dXSpeed;
    dYSpeed = _dYSpeed;
  }

  void display() 
  {
   
    image (debPNG, debrisX, debrisY);
    debrisX+=dXSpeed;
    debrisY+=dYSpeed;

    if (debrisX >= width-10) {
      dXSpeed*=-1;
      if (debrisY < height) bump.play();
      bump.rewind();
    }

    if (debrisX <= 10) {
      dXSpeed*=-1;
      if (debrisY < height) bump.play();
      bump.rewind();
    }
  }
}

class Laser {
  int laserX;
  int laserY;
  int laserSpeed;

  Laser(int _laserX, int _laserY) {
    laserX = _laserX;
    laserY = _laserY;
    laserSpeed = 4;
  }

  void display() {
    noStroke();
    fill (#ffffff);
    rect (laserX, laserY, 2, 6);
    laserY = laserY - laserSpeed;
  }
}

class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  int secondsToGo;
  int passedTime;
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
    secondsToGo = (totalTime/1000);
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      
      return true;
    } else {
      return false;
    }
   }
   
 }
class Viper {

  int xPos; 
  int yPos;
  PImage vPNG;
  int shipSpeed;
 

  Viper() {

    shipSpeed  = 3;
    vPNG = loadImage("shipViper.png");
    xPos = (width/2);
    yPos= 550;
  }

  // The next void ship(); is the entire ship's behaviour, the class knows how to shoot and how to move by itself.

  void ship() {
    imageMode(CENTER);
    image(vPNG, xPos, yPos);

    if (pLeft==true) {
      xPos -=shipSpeed;
      vPNG = loadImage("shipViperLeft.png");
    }
    if (pRight==true) {
      xPos += shipSpeed;
      vPNG = loadImage("shipViperRight.png");
    }

    if (xPos >= width-bumplimits) xPos = width-bumplimits;
    if (xPos <= 0+bumplimits) xPos = bumplimits;
//------------------------------------------------ LASER CREATION ----------------------------------
    
    
    
    for (int i=shots.size()-1; i>=0; i--) {

      if (shots.get(i).laserY <= 0) {
        shots.remove(i);
        break;
      }
    }
  }
}


