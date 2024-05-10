// ===== GAME SETTINGS =====

int infoAreaY = 100;
int maxSquareSize = 40;
PVector gridOffset;
boolean testMode = false;

int INPROGRESS = 1;
int WON = 2;
int LOST = 0;
int MENU = 3;

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
int gameState = MENU;
int squareSize;
PVector gridSize;
boolean[][] gridStates;
boolean[][] minePositions;
boolean[][] flagPositions;
int flagsPlaced;
int[] clickedMine;
int timePassed;
int lastMilli;
boolean paused;

boolean leftDown = false;
boolean rightDown = false;
int mX;
int mY;

// ===== MENU VALUES =====

String[] optionNames = {"Grid Size X", "Grid Size Y", "Mine Count"};
int[] optionValues = {20, 20, 80};
int selectedItem = 0;

int GRIDSIZEX = 0;
int GRIDSIZEY = 1;
int MINECOUNT = 2;

// ===== PROCESSING FUNCTIONS =====

void setup() {
  noStroke();
  size(1000, 1000);
}

void draw() {
  background(0);  
  runGame();
}

void keyPressed() {
  if(key == 'q') {
    exit();  
  }
  
  if(gameState == INPROGRESS && key == ' ') {
    pauseGame();
  }
  
  if(gameState == MENU) {
    if(keyCode == DOWN) {
      selectItem(1);
    }
    
    if(keyCode == UP) {
      selectItem(-1);  
    }
    
    if(keyCode == LEFT) {
      changeValue(-1);  
    }
    
    if(keyCode == RIGHT) {
      changeValue(1);  
    }
    
    if(key == ' ') {
      newGame();  
    }
  } else {
    if(key == 'r') {
      newGame();  
    }
    
    if(key == 'm') {
      gameState = MENU;  
    }
  }
}

void mousePressed() {
  if(!setMousePos() || paused) { return; }
  if(mouseButton == LEFT) {
    leftDown = true;
    if(rightDown) {
      attemptQuickReveal();
    } else {
      attemptReveal();
    }
  } else {
    if(leftDown) {
      attemptQuickReveal();  
    } else {
      attemptFlag();
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

// MENU

void selectItem(int x) {
  selectedItem = constrain(selectedItem += x, 0, optionNames.length - 1);
}

void changeValue(int x) {
  optionValues[selectedItem] = max(optionValues[selectedItem] + x, 1);
}

// PLAYER ACTIONS

void attemptReveal() {
  if(firstClick) {
    firstClick = false;
    generateMines(mX, mY);
  }
    
  if(getMineState(mX, mY)) {
    clickedMine = new int[] {mX, mY};
    loseGame();
    return;
  }
  
  if(!getFlagState(mX, mY) && !getSquareState(mX, mY)) {
    setSquareState(mX, mY);
    leftDown = false;
  }
  
  if(getAdjacentMines(mX, mY) == 0) {
    revealAdjacentSquares(mX, mY);
  }
}

void attemptFlag() {
  if(!getSquareState(mX, mY)) {
    setFlagState(mX, mY);
  }
}

void attemptQuickReveal() {
  if(getSquareState(mX, mY)) {
    revealNonFlaggedSquares(mX, mY);
  }
}

// ROUNDS

void runGame() {
  if(gameState != MENU) {
    if(paused) { 
      drawPauseScreen();
      return; 
    }
    
    if(checkComplete()) {
      winGame();
    }
    
    drawGameScreen();
    drawInfoArea();
    
    if(gameState == INPROGRESS) {
      timePassed += millis() - lastMilli;
      lastMilli = millis(); 
    }

  } else {
    drawMenu();  
  }
}

void pauseGame() {
  paused = !paused;
  if (!paused) {
    timePassed -= millis() - lastMilli;  
  }
}

void newGame() {  
  squareSize = maxSquareSize;
  if(squareSize * optionValues[GRIDSIZEX] > width) {
      squareSize = width / optionValues[GRIDSIZEX];
  }
  if(squareSize * optionValues[GRIDSIZEY] > height - infoAreaY) {
      squareSize = (height - infoAreaY) / optionValues[GRIDSIZEY];
  }
  
  gridOffset = new PVector((width - optionValues[GRIDSIZEX] * squareSize) / 2, (height + infoAreaY - optionValues[GRIDSIZEY] * squareSize) / 2);
  gridSize = new PVector(width - gridOffset.x * 2, width - gridOffset.y * 2);
  
  gameState = INPROGRESS;
  clickedMine = new int[] {-1, -1};
  flagsPlaced = 0;
  gridStates = new boolean[optionValues[GRIDSIZEX]][optionValues[GRIDSIZEY]];
  minePositions = new boolean[optionValues[GRIDSIZEX]][optionValues[GRIDSIZEY]];
  flagPositions = new boolean[optionValues[GRIDSIZEX]][optionValues[GRIDSIZEY]];
  firstClick = true;
  paused = false;
  timePassed = 0;
  lastMilli = millis();
}

void loseGame() {
  revealAllSquares();
  gameState = LOST;
}

void winGame() {
  gameState = WON;
}

// GETTING AND SETTING GRID VALUES

// Flags

boolean getFlagState(int x, int y) {
  return flagPositions[x][y];
}

int getAdjacentFlags(int x, int y) {
  int result = 0;
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= optionValues[GRIDSIZEX] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= optionValues[GRIDSIZEY] || k < 0 || x == i && k == y) {
        continue;  
      }
      if(getFlagState(i, k)) {
        result++;
      }
    }
  }
  return result;  
}

void setFlagState(int x, int y) {
  flagPositions[x][y] = !flagPositions[x][y];
  if(getFlagState(x, y)) {
    flagsPlaced++;  
  } else {
    flagsPlaced--;
  }
}

// Squares

boolean getSquareState(int x, int y) {
  return gridStates[x][y];  
}

boolean checkComplete() {
  for(int i = 0; i < optionValues[GRIDSIZEX];i ++) {
    for(int k = 0; k < optionValues[GRIDSIZEY]; k++) {
      if(!getSquareState(i, k) && !getMineState(i, k)) {
        return false;
      }
    }
  }
  return true && gameState == INPROGRESS;
}

void revealAllSquares() {
  for(int i = 0; i < optionValues[GRIDSIZEX]; i++) {
    for(int k = 0; k < optionValues[GRIDSIZEY]; k++) {
      setSquareState(i, k);  
    }
  }
}

void revealNonFlaggedSquares(int x, int y) {
  if(getAdjacentFlags(x, y) != getAdjacentMines(x, y)) {
    return;  
  }
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= optionValues[GRIDSIZEX] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) {       
      if(k >= optionValues[GRIDSIZEY] || k < 0) {
        continue;  
      }
      if(!getSquareState(i, k) && !getFlagState(i, k)) {
        if(getMineState(i, k)) {
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
    if(i >= optionValues[GRIDSIZEX] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= optionValues[GRIDSIZEY] || k < 0) {
        continue;  
      }
      if(!getMineState(i, k) && !getSquareState(i, k)) {
        setSquareState(i, k);
        if(getAdjacentMines(i, k) == 0) {
          revealAdjacentSquares(i, k);
        }
      }
    }
  }
}

void setSquareState(int x, int y) {
  gridStates[x][y] = true;
  if(getFlagState(x, y)) {
    setFlagState(x, y);
  }
}

// Mines

boolean getMineState(int x, int y) {
  return minePositions[x][y];  
}

int getAdjacentMines(int x, int y) {
  int result = 0;
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= optionValues[GRIDSIZEX] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= optionValues[GRIDSIZEY] || k < 0 || x == i && k == y) {
        continue;  
      }
      if(getMineState(i, k)) {
        result++;
      }
    }
  }
  return result;
}

void generateMines(int originX, int originY) {
  int attempts = 0;
  for(int i = 1; i <= optionValues[MINECOUNT] && attempts < 1000; i++) {
    int x = (int)random(optionValues[GRIDSIZEX]);
    int y = (int)random(optionValues[GRIDSIZEY]);
    boolean valid = true;
    if(getMineState(x, y) || x > originX - 2 && x < originX + 2 && y > originY - 2 && y < originY + 2) {
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

// ===== HELPER FUNCTIONS =====

String formatMillis(int millis) {
  int seconds = millis / 1000;
  return nf(seconds / 60, 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0);  
}

boolean setMousePos() {
  if(gameState == MENU) { return false; }
  int x = (int)((mouseX - gridOffset.x) / squareSize);
  int y = (int)((mouseY - gridOffset.y) / squareSize);
  if(mouseX < gridOffset.x || mouseX > gridOffset.x + gridSize.x || mouseY < gridOffset.y || mouseY > gridOffset.y + gridSize.y + infoAreaY) {
    return false;  
  }
  mX = x;
  mY = y;
  return true;
}

// ===== DRAW FUNCTIONS =====

void drawMine(int x, int y) {
  if(x == clickedMine[0] && y == clickedMine[1]) {
    fill(255, 0, 0);
  } else {
    fill(0);  
  }
  circle(gridOffset.x + x * squareSize + squareSize * 0.5, gridOffset.y + y * squareSize + squareSize * 0.5, squareSize * 0.6);  
}

void drawFlag(int x, int y) {
  fill(0);
  rect(gridOffset.x + x * squareSize + squareSize * 0.6, gridOffset.y + y * squareSize + squareSize * 0.3, squareSize * 0.05, squareSize * 0.4);
  fill(255, 0, 0);
  triangle(
    gridOffset.x + x * squareSize + squareSize * 0.3, gridOffset.y + y * squareSize + squareSize * 0.5,
    gridOffset.x + x * squareSize + squareSize * 0.6, gridOffset.y + y * squareSize + squareSize * 0.5,
    gridOffset.x + x * squareSize + squareSize * 0.6, gridOffset.y + y * squareSize + squareSize * 0.3
  );
}

void drawSquare(int x, int y, int c, int state) {
  if(state == 1) {
    fill(c);
    square(gridOffset.x + x * squareSize, gridOffset.y + y * squareSize, squareSize); // Outer
    fill(c + 65);
    square(gridOffset.x + x * squareSize + squareSize * 0.05, gridOffset.y + y * squareSize + squareSize * 0.05, squareSize * 0.9); // Middle
  } else {
    fill(c - 115);
    square(gridOffset.x + x * squareSize, gridOffset.y + y * squareSize, squareSize); // Bottom Right
    fill(c);
    triangle( // Top Left
      gridOffset.x + x * squareSize, gridOffset.y + y * squareSize + squareSize,
      gridOffset.x + x * squareSize, gridOffset.y + y * squareSize,
      gridOffset.x + x * squareSize + squareSize, gridOffset.y + y * squareSize
    );
    fill(c - 50);
    square(gridOffset.x + x * squareSize + squareSize * 0.1, gridOffset.y + y * squareSize + squareSize * 0.1, squareSize * 0.8); // Middle
  }

  textAlign(CENTER, CENTER);
  textSize(squareSize * 0.8);
  if(state == 1) {
    int mines = getAdjacentMines(x, y);
    if(mines > 0) {
      fill(numberColors[mines]);
      text(mines, gridOffset.x + x * squareSize + squareSize * 0.5, gridOffset.y + y * squareSize + squareSize * 0.5);
    }
  }
}

void drawGameScreen() {
  for(int i = 0; i < optionValues[GRIDSIZEX]; i++) {
    for(int k = 0; k < optionValues[GRIDSIZEY]; k++) {         
      if(gridStates[i][k]) {
        drawSquare(i, k, 115, 1);
      } else {
        drawSquare(i, k, 230, 0);
      }

      if((rightDown || leftDown) && getSquareState(mX, mY)) {
        if(i - mX >= -1 && i - mX <= 1 && k - mY <= 1 && k - mY >= -1 && !getSquareState(i, k)) {
          drawSquare(i, k, 255, 0);
        }
      }

      if(testMode & getMineState(i, k)) {
        drawMine(i, k);
      }

      if(gameState != INPROGRESS && getMineState(i, k)) {
        drawMine(i, k);
        textAlign(CENTER, CENTER);
        textSize(40);
        fill(255);
      }
      
      if(gameState == INPROGRESS && getFlagState(i, k)) {
        drawFlag(i, k);
      }
    }
  }
    
  if(gameState != INPROGRESS) {
    String text = "You Lost!";
    if(gameState == WON) {
      text = "You Won!";
    }
    
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    text(text, width * 0.5, (height + infoAreaY) * 0.5);
  }
}
String[] helpText = {"[Arrow Keys] - Adjust Settings", "[Space] - Start", "[Left Click] - Reveal Square", "[Right Click] - Place Flag", "[Click and Hold] - Highlight Adjacent Squares.", "[Left + Right Click] - Clear Adjacent Unflagged Squares"};

void drawMenu() {
  textSize(30);
  textAlign(LEFT, CENTER);
  for(int i = 0; i < helpText.length; i++) {
    text(helpText[i], width * 0.02, height * (0.7 + 0.05 * i));  
  }
  
  textAlign(CENTER, CENTER);
  for(int i = 0; i < optionNames.length; i++) {
    if(i == selectedItem) {
      fill(255, 255, 15);
    } else {
      fill(255);  
    }
    text(optionNames[i] + ':' + optionValues[i], width * 0.5, height * (0.3 + 0.05 * i));  
  }
  int totalSquares = optionValues[GRIDSIZEX] * optionValues[GRIDSIZEY];
  fill(255);
  text("Total Squares: " + totalSquares, width * 0.5, height * 0.5);
  text("Mine Density: %" + nf((float)optionValues[MINECOUNT] / totalSquares * 100, 0, 1), width * 0.5, height * 0.55);
  textSize(60);
  text("Mine Sweeper", width * 0.5, height * 0.1);
  
}

void drawInfoArea() {
  fill(115);
  rect(0, 0, width, infoAreaY);
  fill(230);
  triangle(0, infoAreaY, 0, 0, infoAreaY, 0);
  triangle(width * 0.99, infoAreaY * 0.08, width * 0.99, 0, width, 0);
  rect(0, 0, width * 0.99, infoAreaY * 0.04);
  fill(170);
  rect(width * 0.005, infoAreaY * 0.04, width - width * 0.01, infoAreaY - infoAreaY * 0.08);
  fill(255);
  textSize(40);
  text(formatMillis(timePassed), width * 0.5, infoAreaY - infoAreaY * 0.5);
  textAlign(LEFT, CENTER);
  text(optionValues[MINECOUNT] - flagsPlaced, width * 0.2, infoAreaY - infoAreaY * 0.5);
  textSize(20);
  text("[SPACE] - Pause\n[Q] - Quit\n[R] - Restart\n[M] - Menu", width * 0.8, infoAreaY - infoAreaY * 0.5);
  fill(255, 0, 0);
  square(width * 0.15 + width * 0.0125, infoAreaY - infoAreaY * 0.49 - height * 0.0125, height * 0.025);
}

void drawPauseScreen() {
  fill(0);
  rect(0, 0, width, height);  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("Game Paused\n[SPACE] - Resume", width * 0.5, height * 0.5);
}
