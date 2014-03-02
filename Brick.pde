class Brick {

  int bX;
  int bY;
  int bHeight;
  int bWidth;

  Brick(int _bX, int _bY) {
   
    bX = _bX;
    bY = _bY;
    bHeight = 20;
    bWidth = 45;
  }

  void display() {
    if(event == 2){
    image(greenBrick, bX, bY);
    }
    if(event == 3){
    image(blueBrick, bX, bY);
    }
    if(event == 4){
    image(greenBrick, bX, bY);
    }
    if(event == 5){
    image(redBrick, bX, bY);
    }
    }
// 
// stroke(#0000FF);
// noFill();
// rect (bX,bY,bWidth,bHeight);
  }


