// == Game Settings ==
int plySize = 50;

int[][] tilePositions = { {500, 500}, {500, - 250} };
int[][] tileSizes = { {750, 750}, {250, 750} };

// == Game Values ==

PVector tileOffset = new PVector();
PVector tileVelocity = new PVector();
int plySpeed = 5;

boolean mLeft = false;
boolean mRight = false;
boolean mDown = false;
boolean mUp = false;

void setup() {
  noStroke();
  size(1000, 1000);
}

void draw() {
  background(0);
  runGame();  
}

void keyPressed() {
  if(key == 'w') {
    mUp = true;
  }
  
  if(key == 's') {
    mDown = true;
  }
  
  if(key == 'a') {
    mLeft = true;  
  }
  
  if(key == 'd') {
    mRight = true;  
  }
}

void keyReleased() {
  if(key == 'w') {
    mUp = false;
  }
  
  if(key == 's') {
    mDown = false;
  }
  
  if(key == 'a') {
    mLeft = false;  
  }
  
  if(key == 'd') {
    mRight = false;  
  }
}

void runGame() {
  drawTiles();
  moveTiles();
  drawPly();  
}

void moveTiles() {
  tileVelocity.mult(0);
  
  if(mUp) {
    tileVelocity.y = 1;  
  }
  
  if(mDown) {
    tileVelocity.y = -1;  
  }
  
  if(mLeft) {
    tileVelocity.x = 1;  
  }
  
  if(mRight) {
    tileVelocity.x = -1;  
  }
  
  
  tileOffset.add(tileVelocity.mult(plySpeed));
}

void drawTiles() {
  for(int i = 0; i < tilePositions.length; i++) {
    float x = tilePositions[i][0] + tileOffset.x;
    float y = tilePositions[i][1] + tileOffset.y;;
    fill(150);
    rect(x - tileSizes[i][0] * 0.5, y - tileSizes[i][1] * 0.5, tileSizes[i][0], tileSizes[i][1]);
  }
}

void drawPly() {
  fill(255);
  square(500 - plySize * 0.5, 500 - plySize * 0.5, plySize);
  fill(0);
  square(500 - plySize * 0.3, 500 - plySize * 0.2, plySize * 0.1);
  square(500 + plySize * 0.2, 500 - plySize * 0.2, plySize * 0.1);
  rect(500 - plySize * 0.25, 500 + plySize * 0.2, plySize * 0.5, plySize * 0.1);
}
