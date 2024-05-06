// ===== GAME SETTINGS =====
int gridCountX = 20;
int gridCountY = 20;
boolean testMode = true;

//int gridSquaresPerMine = 10;
//int mineCount = gridCountX * gridCountY / gridSquaresPerMine;
int mineCount = 100;

int[] gridSizes = {8, 9, 10};
int[] mineCounts = {10, 10, 10};

color[] numberColors = {
  color(190),
  color(0, 0, 253),
  color(1, 126, 0),
  color(254, 0, 0),
  color(1, 1, 126),
  color(131, 1, 0),
  color(0, 128, 128),
  color(0),
  color(128),
};

// ===== ROUND VALUES =====

boolean firstClick;
int gameState = 0;
PVector gridSize;
boolean[][] gridStates;
boolean[][] minePositions;
boolean[][] flagPositions;
int[] clickedMine;

boolean leftDown = false;
boolean rightDown = false;
int mX;
int mY;

// ===== PROCESSING FUNCTIONS =====

void setup() {
  size(1000, 1000);
  gridSize = new PVector(width / gridCountX, height / gridCountY);
  newGame();
}

void draw() {
  runGame();
}

void keyPressed() {
  if(key == 'q') {
    if(rightDown) {
      performAction(1);
    } else {
      performAction(0); 
    }
    leftDown = true;
  }
  
  if(key == 'e') {
    if(leftDown) {
      performAction(1);  
    } else {
      performAction(2);
      rightDown = true;
    }
  }
}

void keyReleased() {
  if(key == 'q') {
    leftDown = false;
  }
  
  if(key == 'e') {
    rightDown = false;
  }
}

void mousePressed() {
  if(mouseButton == LEFT) {
    if(rightDown) {
      performAction(1);
    } else {
      performAction(0);
    }
    leftDown = true;
  } else {
    if(leftDown) {
      performAction(1);  
    } else {
      performAction(2);
      rightDown = true;
    }
  }
}

void mouseReleased() {
  if(mouseButton == RIGHT) {
    rightDown = false;  
  }
  if(mouseButton == LEFT) {
    leftDown = false;  
  }
}

// ===== GAME FUNCTIONS =====

void performAction(int action) {
  mX = (int)(mouseX / gridSize.x);
  mY = (int)(mouseY / gridSize.y);
  if(action == 0) {
    if(firstClick) {
      firstClick = false;
      generateMines(mX, mY);
    }
    
    if(gameState == 1 && checkMine(mX, mY)) {
      clickedMine = new int[] {mX, mY};
      loseGame();
      return;
    }
    
    if(gameState == 0 || gameState == 2) {
      newGame();
      return;
    }
    
    if(!getFlagState(mX, mY)) {
      setSquareState(mX, mY);
    }
    
    if(getAdjacentMines(mX, mY) == 0) {
      revealAdjacentSquares(mX, mY);
    }
  }
  
  if(action == 1) {
    if(getSquareState(mX, mY)) {
      revealNonFlaggedSquares(mX, mY);
    }
  }
  
  if(action == 2 && !getSquareState(mX, mY)) {
    setFlagState(mX, mY);
  }
}

void runGame() {
  if(checkComplete() && gameState == 1) {
    winGame();  
  }
  drawGrid();  
}

void newGame() {
  gameState = 1;
  clickedMine = new int[] {-1, -1};
  gridStates = new boolean[gridCountX][gridCountY];
  minePositions = new boolean[gridCountX][gridCountY];
  flagPositions = new boolean[gridCountX][gridCountY];
  firstClick = true;
}

void loseGame() {
  revealAllSquares();
  gameState = 0;
}

void winGame() {
  gameState = 2;
}

void revealAllSquares() {
  for(int i = 0; i < gridCountX; i++) {
    for(int k = 0; k < gridCountY; k++) {
      setSquareState(i, k);  
    }
  }
}

void revealNonFlaggedSquares(int x, int y) {
  if(getAdjacentFlags(x, y) != getAdjacentMines(x, y)) {
    return;  
  }
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= gridCountX || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) {       
      if(k >= gridCountY || k < 0) {
        continue;  
      }
      if(!getSquareState(i, k) && !getFlagState(i, k)) {
        if(checkMine(i, k)) {
          clickedMine = new int[] {i, k};
          loseGame();
        }
        if(getAdjacentMines(i, k) == 0)  {
          revealAdjacentSquares(i, k); 
        } else {
          setSquareState(i, k);  
        }
      }
    }
  }
}

void revealAdjacentSquares(int x, int y) {
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= gridCountX || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= gridCountY || k < 0) {
        continue;  
      }
      if(!checkMine(i, k) && !getSquareState(i, k)) {
        setSquareState(i, k);
        if(getAdjacentMines(i, k) == 0) {
          revealAdjacentSquares(i, k);
        }
      }
    }
  }
}

void setFlagState(int x, int y) {
  flagPositions[x][y] = !flagPositions[x][y];
}

boolean getFlagState(int x, int y) {
  return flagPositions[x][y];
}


boolean getSquareState(int x, int y) {
  return gridStates[x][y];  
}

void setSquareState(int x, int y) {
  gridStates[x][y] = true;
  if(getFlagState(x, y)) {
    setFlagState(x, y);
  }
}

boolean checkMine(int x, int y) {
  return minePositions[x][y];  
}

boolean checkComplete() {
  for(int i = 0; i < gridCountX;i ++) {
    for(int k = 0; k < gridCountY; k++) {
      if(!getSquareState(i , k) && !checkMine(i, k)) {
        return false;
      }
    }
  }
  return true;
}

// mine cannot be generated at the provided x and y
void generateMines(int originX, int originY) {
  int attempts = 0;
  for(int i = 1; i <= mineCount && attempts < 1000; i++) {
    int x = (int)random(gridCountX);
    int y = (int)random(gridCountY);
    boolean valid = true;
    if(checkMine(x, y) || originX == x && originY == y) {
      valid = false;  
    }
    
    if(valid) {
      minePositions[x][y] = true;
      attempts = 0;
    } else {
      attempts++;
      i--;
    }
  }
}

int getAdjacentMines(int x, int y) {
  int result = 0;
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= gridCountX || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= gridCountY || k < 0 || x == i && k == y) {
        continue;  
      }
      if(checkMine(i, k)) {
        result++;
      }
    }
  }
  return result;
}

int getAdjacentFlags(int x, int y) {
  int result = 0;
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= gridCountX || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= gridCountY || k < 0 || x == i && k == y) {
        continue;  
      }
      if(getFlagState(i, k)) {
        result++;
      }
    }
  }
  return result;  
}

// ===== DRAW FUNCTIONS =====

void drawMine(int x, int y) {
  if(x == clickedMine[0] && y == clickedMine[1]) {
    fill(255, 0, 0);
  } else {
    fill(0);  
  }
  ellipse(x * gridSize.x + gridSize.x * 0.5, y * gridSize.y + gridSize.y * 0.5, gridSize.x * 0.8, gridSize.y * 0.8);  
}

void drawFlag(int x, int y) {
  fill(255, 0, 0);
  rect(x * gridSize.x + gridSize.x * 0.25, y * gridSize.y + gridSize.y * 0.25, gridSize.x * 0.5, gridSize.y * 0.5);
}

void drawSquare(int x, int y, color c) {
  fill(c);
  rect(x * gridSize.x, y * gridSize.y, gridSize.x, gridSize.y);
}

void drawGrid() {
  for(int i = 0; i < gridCountX; i++) {
    for(int k = 0; k < gridCountY; k++) {         
           
      if(gridStates[i][k]) {
        drawSquare(i, k, color(190));
        textAlign(CENTER, CENTER);
        textSize(gridSize.x / 2);
        int mines = getAdjacentMines(i, k);
        fill(numberColors[mines]);
        text(mines, i * gridSize.x + gridSize.x * 0.5, k * gridSize.y + gridSize.y * 0.5);
      } else {
        drawSquare(i, k, color(220));
      }
      
      if((rightDown || leftDown) && getSquareState(mX, mY)) {
        if(i - mX >= -1 && i - mX <= 1 && k - mY <= 1 && k - mY >= -1 && !getSquareState(i, k)) {
          drawSquare(i, k, color(240));
        }
      }
      
      if(testMode & checkMine(i, k)) {
        drawMine(i, k);
      }

      if(gameState == 0 && checkMine(i, k)) {
        drawMine(i, k);
        textAlign(CENTER, CENTER);
        textSize(40);
        fill(255);
        text("You Lost!", width / 2, height / 2);
      }
      
      if(getFlagState(i, k)) {
        drawFlag(i, k);
      }
    }
  }
  
  if(gameState == 2) {
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    text("You Won!", width / 2, height / 2);
  }
}
