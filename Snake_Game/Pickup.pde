class Pickup {
  PVector position;
  int sizeIncrease;
  boolean active = false;
  
  Pickup() {
    spawn();
  }
  
  void run() {
    if (!active) {
      return; 
    }
    checkCollision();
    drawShape();
  }
  
  void spawn() {
    position = new PVector(round(random(width) / segmentSize) * segmentSize, round(random(height) / segmentSize) * segmentSize);
    active = true;
  }
  
  void remove() {
    active = false;
    spawn(); 
  }
  
  void checkCollision() {
    if (position.equals(snake.getHeadPosition())) {
      snake.addLength();
      remove();
    }
  }
  
  void drawShape() {
    pushMatrix();
      fill(255, 0, 0);
      rect(position.x, position.y, segmentSize, segmentSize);
    popMatrix();
  }
}

// multiplication and division have the same weight, evaluating from left to right
// same for addition and subtraction
