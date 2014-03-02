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
    rect (laserX, laserY, 2, 8);
    fill (#FF3030);
    rect (laserX+2, laserY, 1, 6);
    rect (laserX-2, laserY, 1, 6);
    fill (#ffffff);
    laserY = laserY - laserSpeed;
  }
}

