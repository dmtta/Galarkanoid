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

