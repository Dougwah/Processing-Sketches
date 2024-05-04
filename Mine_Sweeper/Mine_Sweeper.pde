// ===== GAME SETTINGS =====
int gridCountX = 15;
int gridCountY = 15;

//int gridSquaresPerMine = 10;
//int mineCount = gridCountX * gridCountY / gridSquaresPerMine;
int mineCount = 40;

int[] gridSizes = {8, 9, 10};
int[] mineCounts = {10, 10, 10};

color[] numberColors = {
  color(150, 150, 150),
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

// ===== PROCESSING FUNCTIONS =====

void setup() {
  size(1000, 1000);
  gridSize = new PVector(width / gridCountX, height / gridCountY);
  newGame();
}

void draw() {
  drawGrid();
}

void mousePressed() {
  int x = (int)(mouseX / gridSize.x);
  int y = (int)(mouseY / gridSize.y);
  if(mouseButton == LEFT) {
    if(firstClick) {
      firstClick = false;
      generateMines(x, y);
    }
    
    if(gameState == 1 && checkMine(x, y)) {
      endGame();
      return;
    }
    
    if(gameState == 0) {
      newGame();
      return;
    }
    
    setSquareState(x, y);
    if(getAdjacentMines(x, y) == 0) {
      revealAdjacentSquares(x, y);
    }
  } else {
    setFlagState(x, y);
  }
}

// ===== GAME FUNCTIONS =====

void newGame() {
  gameState = 1;
  gridStates = new boolean[gridCountX][gridCountY];
  minePositions = new boolean[gridCountX][gridCountY];
  flagPositions = new boolean[gridCountX][gridCountY];
  firstClick = true;
}

void endGame() {
  revealAllSquares();
  gameState = 0;  
}

void revealAllSquares() {
  for(int i = 0; i < gridCountX; i++) {
    for(int k = 0; k < gridCountY; k++) {
      setSquareState(i, k);  
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
}

boolean checkMine(int x, int y) {
  return minePositions[x][y];  
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

// ===== DRAW FUNCTIONS =====

void drawGrid() {
  for(int i = 0; i < gridCountX; i++) {
    for(int k = 0; k < gridCountY; k++) {   
      

      if(gridStates[i][k]) {
        fill(150, 150, 150);
        rect(i * gridSize.x, k * gridSize.y, gridSize.x, gridSize.y);
        textAlign(CENTER, CENTER);
        textSize(gridSize.x / 2);
        int mines = getAdjacentMines(i, k);
        fill(numberColors[mines]);
        text(mines, i * gridSize.x + gridSize.x * 0.5, k * gridSize.y + gridSize.y * 0.5);
      } else { 
        fill(120, 120, 120);
        rect(i * gridSize.x, k * gridSize.y, gridSize.x, gridSize.y);
        
        if(getFlagState(i, k)) {
          fill(255, 0, 0);
          rect(i * gridSize.x + gridSize.x * 0.25, k * gridSize.y + gridSize.y * 0.25, gridSize.x * 0.5, gridSize.y * 0.5);
        }
      }
      

      
      if(gameState == 0 && checkMine(i, k)) {
        fill(0);
        ellipse(i * gridSize.x + gridSize.x * 0.5, k * gridSize.y + gridSize.y * 0.5, gridSize.x * 0.8, gridSize.y * 0.8);
      }
    }
  }  
}
