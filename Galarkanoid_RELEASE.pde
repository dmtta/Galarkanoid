//     ______        __ ___           __                         _      __
//    / ____/____ _ / //   |   _____ / /__ ____ _ ____   ____   (_)____/ /
//   / / __ / __ `// // /| |  / ___// //_// __ `// __ \ / __ \ / // __  / 
//  / /_/ // /_/ // // ___ | / /   / ,<  / /_/ // / / // /_/ // // /_/ /  
//  \____/ \__,_//_//_/  |_|/_/   /_/|_| \__,_//_/ /_/ \____//_/ \__,_/   
//                                                                     v 1.0
//  
// Daniel Mastretta Jiménez // MFADT DEC 2013
// MADE AND TESTED WITH PROCESSING rev 2.1.9
//
// Galarkanoid is a top-down shooter set in the distant spaceworld of fuckthiscode
// Evil walls are about to destroy the universe, you must destroy all the walls before 
// existence is obliterated. You are the pilot of Viper, the last ship remaining!
//
// GO SPACE COWBOY!!!! BRING THOSE WALLS DOWN AND BECOME A HERO!!!!!

//...................................................................LIBRARIES
import ddf.minim.* ;
Minim minim;
AudioPlayer laser, block, bump, bgspace, bggameover, bgvictory;
//...................................................................GLOBAL VARIABLES
int score; // Score of the actual play
int transTimer;
int highScore; // Best Score since the game existed
String scorePath; //The path where my file will be read from and saved to
int event; // Events are different states of the game, this keeps the count.
boolean pLeft; // Booleans that check if keys are pressed or not. goto: void keyPressed and void keyReleased.
boolean pRight; // Movement Boolean
boolean nextScreen; // Checks to advance to the next game screen
boolean l1end; // Checks if Level 1 has ended
boolean l2end;
boolean l3end;
boolean l4end;
boolean safeScore;
int lvlNum;
int bumplimits; // Graphical, checks where the debris should be bumping on the sides
//...................................................................GRAPHICAL VARIABLES
PFont specFont; // Main pixelated font.
PImage logoPNG; // Galarkanoid Logo
PImage blueBrick; // LVL1 Brick
PImage redBrick; // LVL1 Brick
PImage greenBrick; // LVL1 Brick
PImage gui; // Game's GUI
PImage debPNG; // Debris PNG
int logoX; // Position for the Galarkanoid Logo
int logoY; // Position for the Galarkanoid Logo
int l1Columns; // Columns of the first level brick wall
int l2Columns; // Columns of the second level brick wall
int l3Columns; // Columns of the third level brick wall
int l4Columns; // Columns of the fourth level brick wall
int l1xSpace; // Spacing in X for the first level brick wall
int l2xSpace; // Spacing in X for the second level brick wall
int l3xSpace; // Spacing in X for the third level brick wall
int l4xSpace; // Spacing in X for the third level brick wall
int l1ySpace; // Spacing in Y for the first level brick wall
int l2ySpace; // Spacing in X for the second level brick wall
int l3ySpace; // Spacing in X for the third level brick wall
int l4ySpace; // Spacing in X for the third level brick wall

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
int transTime;
//...................................................................OBJECT AND OBJECT ARRAY CALLING
Timer timer;
Viper viper; // Initializes the ship
ArrayList<Laser> shots; // ArrayList that initializes lasers
ArrayList<Debris> deb; // ArrayList that initializes debris
ArrayList<Brick> bricksLevelOne;  // ArrayList that initializes first level bricks
ArrayList<Brick> bricksLevelTwo;  // ArrayList that initializes second level bricks
ArrayList<Brick> bricksLevelThree; // ArrayList that initializes third level bricks
ArrayList<Brick> bricksLevelFour; // ArrayList that initializes fourth level bricks

public void init() { 
  frame.removeNotify(); 
  frame.setUndecorated(true); 
  frame.addNotify(); 
  frame.setLocation(width/2, height/2);
  frame.setBackground(  new     java.awt.Color(0,0,0));
  super.init();
}

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
      bgspace.rewind();
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
    for (int i=bricksLevelOne.size()-1;i>=0;i--) {
      bricksLevelOne.get(i).display();
    }
    for (int i=deb.size()-1;i>=0;i--) {
      deb.get(i).display();
    }
    countdown();
    score();
    text("LEVEL: 1", 400, 40);
    levelOneEndCheck();

    if (l1end == true) {
      transTimer = millis()+3000;
      resetLevelTimer(1);
      event = 12;
    }
    break;
    //--------------------------------------------------------- LEVEL 2
  case 3:

    background(0);
    starfield();
    image(gui, width/2, height/2);
    viper.ship();
    shipDebrisCol() ;
    debrisCheck(); 
    brickCol2();  
    for (int i=bricksLevelTwo.size()-1;i>=0;i--) {
      bricksLevelTwo.get(i).display();
    }
    for (int i=deb.size()-1;i>=0;i--) {
      deb.get(i).display();
    }
    countdown();
    score();
    text("LEVEL: 2", 400, 40);
    levelTwoEndCheck();
    if (l2end == true) {
      resetLevelTimer(1);
      transTimer = millis()+3000;
      event = 12;
    }
    break;

    //--------------------------------------------------------- LEVEL 3
  case 4:

    background(0);
    starfield();
    image(gui, width/2, height/2);
    viper.ship();
    shipDebrisCol() ;
    debrisCheck(); 
    brickCol3();  
    for (int i=bricksLevelThree.size()-1;i>=0;i--) {
      bricksLevelThree.get(i).display();
    }
    for (int i=deb.size()-1;i>=0;i--) {
      deb.get(i).display();
    }
    countdown();
    score();
    text("LEVEL: 3", 400, 40);
    levelThreeEndCheck();
    if (l3end == true) {
      resetLevelTimer(1);
      transTimer = millis()+3000;
      event = 12;
    }
    break;

    //--------------------------------------------------------- LEVEL 4
  case 5:

    background(0);
    starfield();
    image(gui, width/2, height/2);
    viper.ship();
    shipDebrisCol() ;
    debrisCheck(); 
    brickCol4();  
    for (int i=bricksLevelFour.size()-1;i>=0;i--) {
      bricksLevelFour.get(i).display();
    }
    for (int i=deb.size()-1;i>=0;i--) {
      deb.get(i).display();
    }
    countdown();
    score();
    text("LEVEL: 4", 400, 40);
    levelFourEndCheck();
    if (l4end == true) {
      bgspace.rewind();
      safeScore = true;
      event = 11;
    }
    break;


    //--------------------------------------------------------- GAME OVER SCREEN  
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
    bgspace.pause();
    bgvictory.play();
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
    //--------------------------------------------------------- TRANSITION SCREEN 
  case 12:
    background(0);
    starfield();
    bgspace.pause();
    bgvictory.play();
    image(gui, width/2, height/2);
    text ("PREPARE FOR THE NEXT LEVEL", width/2, 250);
    if (transTimer<millis()) {
      if (l3end == true) {
        bgspace.rewind();
        bgspace.play();
        resetLevelTimer(2);
        bgvictory.pause();
        bgvictory.rewind();
        event = 5;
      }
      else if (l2end == true) {
        bgspace.rewind();
        bgspace.play();
        resetLevelTimer(1);
        bgvictory.pause();
        bgvictory.rewind();
        event = 4;
      }
      else if (l1end == true) {
        bgspace.rewind();
        bgspace.play();
        resetLevelTimer(1);
        bgvictory.pause();
        bgvictory.rewind();
        event = 3;
      }
    }
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

    for (int g=bricksLevelOne.size()-1;g>=0;g--) {

      // This is the collision check for bricks & shots
      boolean top, bottom, left, right;

      top=shots.get(i).laserY > ((bricksLevelOne.get(g).bY)-(bricksLevelOne.get(g).bHeight/2));
      bottom=shots.get(i).laserY < ((bricksLevelOne.get(g).bY)+(bricksLevelOne.get(g).bHeight/2));
      left= shots.get(i).laserX > ((bricksLevelOne.get(g).bX)-(bricksLevelOne.get(g).bWidth/2));
      right= shots.get(i).laserX < ((bricksLevelOne.get(g).bX)+(bricksLevelOne.get(g).bWidth/2));



      if (top && bottom && left && right == true) {

        deb.add(new Debris(bricksLevelOne.get(g).bX, bricksLevelOne.get(g).bY, int(random(-1, -5)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelOne.get(g).bX, bricksLevelOne.get(g).bY, int(random(-4, 4)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelOne.get(g).bX, bricksLevelOne.get(g).bY, int(random(1, 5)), int(random(2, 4))));

        shots.remove(i);
        block.play();
        block.rewind();
        bricksLevelOne.remove(g); 
        score = score + 1;  
        break;
      }
    }
  }
}

void brickCol2() {

  for (int i=shots.size()-1; i>=0; i--) {

    shots.get(i).display();

    if (shots.get(i).laserY <= 0) {
      shots.remove(i);
      break;
    }
    for (int g=bricksLevelTwo.size()-1;g>=0;g--) {
      // This is the collision check for bricks & shots
      boolean top, bottom, left, right;
      top=shots.get(i).laserY > ((bricksLevelTwo.get(g).bY)-(bricksLevelTwo.get(g).bHeight/2));
      bottom=shots.get(i).laserY < ((bricksLevelTwo.get(g).bY)+(bricksLevelTwo.get(g).bHeight/2));
      left= shots.get(i).laserX > ((bricksLevelTwo.get(g).bX)-(bricksLevelTwo.get(g).bWidth/2));
      right= shots.get(i).laserX < ((bricksLevelTwo.get(g).bX)+(bricksLevelTwo.get(g).bWidth/2));



      if (top && bottom && left && right == true) {

        deb.add(new Debris(bricksLevelTwo.get(g).bX, bricksLevelTwo.get(g).bY, int(random(-1, -5)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelTwo.get(g).bX, bricksLevelTwo.get(g).bY, int(random(-4, 4)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelTwo.get(g).bX, bricksLevelTwo.get(g).bY, int(random(1, 5)), int(random(2, 4))));

        shots.remove(i);
        block.play();
        block.rewind();
        bricksLevelTwo.remove(g); 
        score = score + 1;  
        break;
      }
    }
  }
}

void brickCol3() {
  for (int i=shots.size()-1; i>=0; i--) {

    shots.get(i).display();

    if (shots.get(i).laserY <= 0) {
      shots.remove(i);
      break;
    }
    for (int g=bricksLevelThree.size()-1;g>=0;g--) {
      // This is the collision check for bricks & shots
      boolean top, bottom, left, right;
      top=shots.get(i).laserY > ((bricksLevelThree.get(g).bY)-(bricksLevelThree.get(g).bHeight/2));
      bottom=shots.get(i).laserY < ((bricksLevelThree.get(g).bY)+(bricksLevelThree.get(g).bHeight/2));
      left= shots.get(i).laserX > ((bricksLevelThree.get(g).bX)-(bricksLevelThree.get(g).bWidth/2));
      right= shots.get(i).laserX < ((bricksLevelThree.get(g).bX)+(bricksLevelThree.get(g).bWidth/2));



      if (top && bottom && left && right == true) {

        deb.add(new Debris(bricksLevelThree.get(g).bX, bricksLevelThree.get(g).bY, int(random(-1, -5)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelThree.get(g).bX, bricksLevelThree.get(g).bY, int(random(-4, 4)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelThree.get(g).bX, bricksLevelThree.get(g).bY, int(random(1, 5)), int(random(2, 4))));

        shots.remove(i);
        block.play();
        block.rewind();
        bricksLevelThree.remove(g); 
        score = score + 1;  
        break;
      }
    }
  }
}

void brickCol4() {

  for (int i=shots.size()-1; i>=0; i--) {

    shots.get(i).display();

    if (shots.get(i).laserY <= 0) {
      shots.remove(i);
      break;
    }
    for (int g=bricksLevelFour.size()-1;g>=0;g--) {
      // This is the collision check for bricks & shots
      boolean top, bottom, left, right;
      top=shots.get(i).laserY > ((bricksLevelFour.get(g).bY)-(bricksLevelFour.get(g).bHeight/2));
      bottom=shots.get(i).laserY < ((bricksLevelFour.get(g).bY)+(bricksLevelFour.get(g).bHeight/2));
      left= shots.get(i).laserX > ((bricksLevelFour.get(g).bX)-(bricksLevelFour.get(g).bWidth/2));
      right= shots.get(i).laserX < ((bricksLevelFour.get(g).bX)+(bricksLevelFour.get(g).bWidth/2));



      if (top && bottom && left && right == true) {

        deb.add(new Debris(bricksLevelFour.get(g).bX, bricksLevelFour.get(g).bY, int(random(-1, -5)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelFour.get(g).bX, bricksLevelFour.get(g).bY, int(random(-4, 4)), int(random(2, 4))));
        deb.add(new Debris(bricksLevelFour.get(g).bX, bricksLevelFour.get(g).bY, int(random(1, 5)), int(random(2, 4))));

        shots.remove(i);
        block.play();
        block.rewind();
        bricksLevelFour.remove(g); 
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
  if (bricksLevelOne.size() == 0) { 
    for (int i=deb.size()-1;i>=0;i--) {
      deb.remove(i);
    }
    for (int i=shots.size()-1;i>=0;i--) {
      shots.remove(i);
    }
    l1end = true;
    score = score + (csec*10);
    climit = 1;
  }
}

void levelTwoEndCheck() {
  if (bricksLevelTwo.size() == 0) { 
    for (int i=deb.size()-1;i>=0;i--) {
      deb.remove(i);
    }
    for (int i=shots.size()-1;i>=0;i--) {
      shots.remove(i);
    }
    l2end = true;
    score = score + (csec*10);
  }
}

void levelThreeEndCheck() {
  if (bricksLevelThree.size() == 0) { 
    for (int i=deb.size()-1;i>=0;i--) {
      deb.remove(i);
    }
    for (int i=shots.size()-1;i>=0;i--) {
      shots.remove(i);
    }
    l3end = true;
    score = score + (csec*10);
  }
}

void levelFourEndCheck() {
  if (bricksLevelFour.size() == 0) { 
    for (int i=deb.size()-1;i>=0;i--) {
      deb.remove(i);
    }
    for (int i=shots.size()-1;i>=0;i--) {
      shots.remove(i);
    }
    l4end = true;
    score = score + (csec*10);
    score = score + 1000;
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
  bricksLevelOne = new ArrayList<Brick>();
  bricksLevelTwo = new ArrayList<Brick>();
  bricksLevelThree = new ArrayList<Brick>();
  bricksLevelFour = new ArrayList<Brick>();
  //---------------------------- Image setup  
  blueBrick = loadImage("blueBlock.png");
  greenBrick = loadImage("greenBlock.png");
  redBrick = loadImage("redBlock.png");
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
  bgvictory = minim.loadFile("ending.mp3");

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

  l1Columns = 5;
  l1xSpace = 100;
  l1ySpace = 30;
  for (int i=0;i<=19;i++) {
    //  for (int i=0;i<=2;i++) { // DEBUG 2 BRICKS
    int x = (i % l1Columns) * l1xSpace;
    int y = (i / l1Columns) * l1ySpace;
    bricksLevelOne.add(new Brick(x+40, y+100));
  }
  //---------------------------- LVL 2 Brick Positions Math  

  l2Columns = 5;
  l2xSpace = 100;
  l2ySpace = 30;
  for (int i=0;i<=24;i++) {
    //  for (int i=0;i<=2;i++) { // DEBUG 2 BRICKS
    int x = (i % l2Columns) * l2xSpace;
    int y = (i / l2Columns) * l2ySpace;
    bricksLevelTwo.add(new Brick(x+40, y+100));
    bricksLevelTwo.add(new Brick(x+40, y+100));
  }

  //---------------------------- LVL 3 Brick Positions Math  

  l3Columns = 9;
  l3xSpace = 50;
  l3ySpace = 30;
  for (int i=0;i<=62;i++) {
    //  for (int i=0;i<=2;i++) { // DEBUG 2 BRICKS
    int x = (i % l3Columns) * l3xSpace;
    int y = (i / l3Columns) * l3ySpace;
    bricksLevelThree.add(new Brick(x+40, y+100));
  }
  //---------------------------- LVL 4 Brick Positions Math  

  l4Columns = 9;
  l4xSpace = 50;
  l4ySpace = 30;
  for (int i=0;i<=62;i++) {
    //  for (int i=0;i<=2;i++) { // DEBUG 2 BRICKS
    int x = (i % l4Columns) * l4xSpace;
    int y = (i / l4Columns) * l4ySpace;
    bricksLevelFour.add(new Brick(x+40, y+100));
    bricksLevelFour.add(new Brick(x+40, y+100));
    bricksLevelFour.add(new Brick(x+40, y+100));
  }
  //---------------------------- Level Managing Variables  
  lvlNum = 0;
  transTime = 0;
  nextScreen = false;
  l1end = false;
  l2end = false;
  l3end = false;
  l4end = false;
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


void resetLevelTimer(int _climit) {
  climit = _climit;
  c = climit*60*1000 - millis();
  csec = (c/(1000));
  newTimer = false;
  lastMillis = millis();
}

boolean sketchFullScreen() {
  return true;
}
