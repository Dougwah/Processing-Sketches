float posX;
float posY;
float velocityX;

BouncyBall bouncyBall;
PVector moveDirection = new PVector(0, 0);

void setup() {
  size(1000, 1000);
  posX = 0.;
  posY = height / 2.;
  velocityX = 20;
  bouncyBall = new BouncyBall(new PVector(width / 2, height / 2), new PVector(30, -15), 50);
}

void draw() {
  background(0, 0, 0);
  fill(255, 0, 0);
  circle(posX, posY, 100);
  //posX = (posX + velocityX) % width;
  posX += velocityX;
  
  if (posX > width) {
    posX -= width;  
  }
  
  if (posX < 0) {
    posX += width;  
  }
  
  bouncyBall.run();
 
}

void keyPressed() {
  switch(key) {
    case('w'):
      moveDirection.y = -1;
      velocityX += 1;  
      break;
    case('a'):
      moveDirection.x = -1;
      break;
    case('s'):
      moveDirection.y = 1;
      velocityX -= 1;  
      break;
    case('d'):
      moveDirection.x = 1;
      break;
    case('x'):
      velocityX = 0;
      break;
  }
}

void keyReleased() {
  switch(key) {
    case('w'):
      moveDirection.y = 0;
      break;
    case('a'):
      moveDirection.x = 0;
      break;
    case('s'):
      moveDirection.y = 0; 
      break;
    case('d'):
      moveDirection.x = 0;
      break;
  }
}
