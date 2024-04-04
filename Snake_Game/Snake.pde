class Snake {
  PVector headPosition;
  PVector currentDirection = new PVector(1, 0);
  ArrayList<PVector> positions = new ArrayList<PVector>();

  String keys = "wasd";
  char lastKey;
  int[] xMovement = {0, -1, 0, 1};
  int[] yMovement = {-1, 0, 1, 0};
  
  int sLength = 1;
  int lastTick = millis();
  
  boolean alive = true;
  
  Snake(PVector _position, int _sLength) {
    headPosition = _position.copy();
    sLength = _sLength;
    println(headPosition);
    for (int i = 0; i < _sLength; i++) {
      println(headPosition.x - segmentSize * i);
      positions.add(new PVector(headPosition.x - segmentSize, headPosition.y));   
    }
    println(positions);
  }
  
  PVector getHeadPosition() {
    return positions.get(positions.size() - 1); 
  }
  
  void addLength() {
    sLength += 1;
  }
  
  void run() {
    control();
    
    if( millis() > lastTick + 100) {
      setPosition();
      checkCollision();
      lastTick = millis();
    }

    drawSnake();
  }
  
  void checkCollision() {
    PVector headPos = getHeadPosition();
    if (headPos.x > width || headPos.x < 0 || headPos.y > height || headPos.y < 0) {
      alive = false;
    }
    
    for (int i = positions.size() - 2; i >= 0; i--) {
      if (positions.size() == 1) {
        break;
      }
      if (headPos.equals(positions.get(i))) {
        alive = false;
      }
    }
  }
  
  void setPosition() {
    headPosition.add(currentDirection.setMag(segmentSize));
    positions.add(headPosition.copy());
    for (int i = positions.size() - 1; i >= 0; i--) {
      if (i < positions.size() - sLength - 1) {
        //println(i);
        positions.remove(i);
      }
    }
 
    //println(positions);
    //println(getHeadPosition());
  }
  
  void control() {
    if (keyPressed) {
      int keyIndex = keys.indexOf(key);
      if (keyIndex != -1) {
        currentDirection.set(new PVector(xMovement[keyIndex], yMovement[keyIndex]));
        lastKey = key;
      }
    }
  }
  
    void drawSnake() {
    for (int i = positions.size() - 1; i >= positions.size() - sLength; i--) {
      //println("Snake Length " + sLength);
      //println("ArraySize " + positions.size());
      //println("index " + i);
      PVector position = positions.get(i);
      //println("Pos" + position);
      fill(255, 255, 255);
      rect(position.x, position.y, segmentSize, segmentSize);  
    }
  }
}
