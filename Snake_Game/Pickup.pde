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
    ArrayList<PVector> snakePositions = snake.getPositions();
    for (int i = 0; i < getGridCount(); i++) {
      
      boolean isAvailable = true;
      position = new PVector(floor(random(width - gridSize) / gridSize) * gridSize, floor(random(height - gridSize) / gridSize) * gridSize);
      
      for (PVector snakePosition : snakePositions) {
        if (position.equals(snakePosition)) {
          isAvailable = false;
        }
      }
      
      if (isAvailable == true) {
        break;
      } else {
        position = new PVector(-width, -height);
      }
    
    }
    
    println(position);
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
      rect(position.x, position.y, gridSize, gridSize);
    popMatrix();
  }
}

// multiplication and division have the same weight, evaluating from left to right
// same for addition and subtraction
