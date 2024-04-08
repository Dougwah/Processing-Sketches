int posY;
int velocityY;

void setup() {
  size(1000, 1000);
  posY = height;
  velocityY = 10;
}

void draw() {
  background(255);
  stroke(255, 0, 0);
  strokeWeight(20);
  line(0, posY, width, posY);
  posY -= velocityY;
  if (posY < 0) {
    posY = height;  
  }
}
