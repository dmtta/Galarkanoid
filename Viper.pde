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

