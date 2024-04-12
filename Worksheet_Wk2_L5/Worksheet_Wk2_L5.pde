/*
int result4 = -1;
int a2 = -1;
int b2 = -2;
int c2 = -3;
if (a2 > 0) {
  if (b2 > 0) {
    if (c2 > 0) {
      result4 = 0;      
    } else {
      result4 = 1;
    }
  } else {
    if (c2 > 1) {
      result4 = 2;
    } else {
      result4 = 3;
    }
  }
} else {
  if (b2 > 0) {
    if (c2 > 0) {
      result4 = 4;
    } else {
      result4 = 5; 
    }
  } else {
    if (c2 > 0) {
      result4 = 6;  
    } else {
      result4 = 7;
    }
  }
}
println(result4);

int xPos;
int direction;
int diameter = 50;

void setup() {
  size(500, 500);
}

void draw() {
  background(255);
  if (xPos >= (width * 0.75) - diameter / 2) {
    direction = -1;  
  }
  if (xPos <= 0 + diameter / 2) {
    direction = 1;
  }
  xPos += 10 * direction;
  circle(xPos, width / 2, diameter);
}
*/
int diameter = 50;
int posX = 0 + diameter / 2;
int posY = 0 + diameter / 2;
int baseVelocity = 10;
int velocityX = baseVelocity;
int velocityY = 0;

int direction;

void setup() {
  frameRate(238);
   size(500, 500);
}

void draw() {
  background(0);
 
  if (direction == 0 && posX >= width - diameter / 2) {
    baseVelocity *= 1.2;    
    direction = 1;
    velocityX = 0;
    velocityY = baseVelocity;    
  }
  
  if (direction == 1 && posY >= height - diameter / 2) {
    baseVelocity *= 1.2;    
    direction = 2;
    velocityX = -baseVelocity;
    velocityY = 0;
  }
  
  if (direction == 2 && posX <= 0 + diameter / 2) {
    baseVelocity *= 1.2;
    direction = 3;
    velocityX = 0;
    velocityY = -baseVelocity;
  }
  
  if (direction == 3 && posY <= 0 + diameter / 2) {
    direction = 0;
    velocityX = baseVelocity;
    velocityY = 0;
  }
  
  
  posX = constrain(posX + velocityX, 0 + diameter / 2, width - diameter / 2);
  posY = constrain(posY + velocityY, 0 + diameter / 2, height - diameter / 2);
  circle(posX, posY, diameter);
}

void mousePressed() {
  posX = mouseX;
  posY = mouseY;
}
