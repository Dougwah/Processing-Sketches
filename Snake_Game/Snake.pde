class Snake {
  PVector headPosition;
  PVector currentDirection = new PVector(1, 0);
  ArrayList<PVector> positions = new ArrayList<PVector>();
  boolean dLeft, dRight, dUp, dDown = false;
  boolean controlLocked = false;

  String keys = "wasd";
  int[] xMovement = {0, -1, 0, 1};
  int[] yMovement = {-1, 0, 1, 0};
  
  int sLength = 1;
  int lastTick = millis();
  
  boolean alive = true;
  
  Snake(PVector _position, int _sLength) {
    headPosition = _position.copy();
    sLength = _sLength;
    for (int i = 0; i < _sLength; i++) {
      positions.add(new PVector(headPosition.x, headPosition.y));   
    }
  }
  
  PVector getHeadPosition() {
    return positions.get(positions.size() - 1); 
  }
  
  ArrayList<PVector> getPositions() {
    return positions;  
  }
  
  void addLength() {
    sLength += 1;
  }
  
  void kill() {
    alive = false; 
  }
  
  void run() {
    control();
    
    if( millis() > lastTick + gameInterval) {
      setPosition();
      checkCollision();
      lastTick = millis();
      controlLocked = false;
    }

    drawSnake();
  }
  
  void checkCollision() {
    PVector headPos = getHeadPosition();
    if (headPos.x >= width || headPos.x < 0 || headPos.y >= height || headPos.y < 0) {
      kill();
    }
    
    for (int i = positions.size() - 2; i > 0; i--) {
      if (positions.size() == 1) {
        break;
      }
      if (headPos.equals(positions.get(i))) {
        kill();
      }
    }
  }
  
  void setPosition() {
    headPosition.add(currentDirection.setMag(gridSize));
    positions.add(headPosition.copy());
    for (int i = positions.size() - 1; i >= 0; i--) {
      if (i < positions.size() - sLength - 1) {
        positions.remove(i);
      }
    }
  }
  
  void control() {
    if (controlLocked) {
      return;  
    }
    switch(lastKey) {
      case 'w':
        if (currentDirection.y == 0) {
          currentDirection.set(0, -1);
        }
        break;
      case 's':
        if (currentDirection.y == 0) {        
          currentDirection.set(0, 1);
        }
        break;
      case 'a':
        if (currentDirection.x == 0) {
          currentDirection.set(-1, 0);
        }
        break;
      case 'd':
        if (currentDirection.x == 0) {
          currentDirection.set(1, 0);
        }
     }
     controlLocked = true;
  }
  
  void drawSnake() {
    for (int i = positions.size() - 1; i >= positions.size() - sLength; i--) {
      PVector position = positions.get(i);
      fill(255, 255, 255);
      if (i % 2 == 0) {
        fill(#FF7D03);  
      } else {
        fill(#FFD603);
      }
      if (i == positions.size() - 1) {
        fill(255, 255, 255);
        rect(position.x, position.y, 4, 4);
        fill(0, 0, 0);
      }
      rect(position.x, position.y, gridSize, gridSize);  
    }
  }
}

// orange, black, yellow
