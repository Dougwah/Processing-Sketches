int gridCountX = 25;
int gridCountY = 25;
int gridSquaresPerBomb = 5;
int bombCount = gridCountX * gridCountY / gridSquaresPerBomb;
PVector gridSize;
boolean[][] gridStates = new boolean[gridCountX][gridCountY];
int[][] bombPositions = new int[gridCountX][gridCountY];


void setup() {
  size(1000, 1000);
  gridSize = new PVector(width / gridCountX, height / gridCountY);
  generateBombs();
}

void draw() {
  drawGrid();
}

void mousePressed() {
  int iX = (int)(mouseX / gridSize.x);
  int iY = (int)(mouseY / gridSize.y);
  changeSquareState(iX, iY);
  if(getAdjacentBombs(iX, iY) == 0) {
    revealAdjacentSquares(iX, iY);
  }
}

void drawGrid() {
  for(int i = 0; i < gridCountX; i++) {
    for(int k = 0; k < gridCountY; k++) {   
      
      if(gridStates[i][k]) {
        fill(150, 150, 150);
        rect(i * gridSize.x, k * gridSize.y, gridSize.x, gridSize.y);
        textAlign(CENTER, CENTER);
        textSize(20);
        fill(255);
        text(getAdjacentBombs(i, k), i * gridSize.x + gridSize.x * 0.5, k * gridSize.y + gridSize.y * 0.5);
      } else { 
        fill(100, 100, 100);
        rect(i * gridSize.x, k * gridSize.y, gridSize.x, gridSize.y);
      } 
      
      if(bombPositions[i][k] == 1) {
        fill(255, 0, 0);
        ellipse(i * gridSize.x + gridSize.x * 0.5, k * gridSize.y + gridSize.y * 0.5, gridSize.x * 0.5, gridSize.y * 0.5);
      }
    }
  }  
}

int getAdjacentBombs(int x, int y) {
  int result = 0;
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= gridCountX || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= gridCountY || k < 0) {
        continue;  
      }
      if(bombPositions[i][k] == 1) {
        result++;
      }
    }
  }
  return result;
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
      if(getAdjacentBombs(i, k) <= 1) {
        changeSquareState(i, k);
        
      }
    }
  }
}

void changeSquareState(int x, int y) {
  gridStates[x][y] = true;
  
  if(bombPositions[x][y] == 1) {
    println("Bomb");  
  }
}

void generateBombs() {
  int lastI = 0;
  int attempts = 0;
  for(int i = 1; i <= bombCount && attempts < 1000; i++) {
    int x = (int)random(gridCountX);
    int y = (int)random(gridCountY);
    boolean valid = true;
    if(bombPositions[x][y] == 1) {
      valid = false;  
    }
    
    if(valid) { //<>//
      bombPositions[x][y] = 1;
      lastI = i;
      attempts = 0;
    } else {
      attempts++;
      i = lastI;
    }
  }
}
