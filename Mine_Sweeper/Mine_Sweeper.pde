// Add start menu
  // Allow selection of grid sizes and bomb count using arrow keys
  // Display bomb density
// Allow returning to menu when game ends
// Add pause menu
  // Allows returning to menu

// ===== GAME SETTINGS =====
int infoAreaY = 100;
int squareSize = 40;
PVector gridOffset;
boolean testMode = false;

//int[] gridSizesX = {8, 9, 10, 13, 13, 14, 14, 15, 15, 16, 16};
//int[] gridSizesY = {8, 9, 10, 15, 16, 15, 16, 15, 16, 16, 30};
//int[] optionValues[2]s = {10, 10, 10, 10, 40, 40, 40, 40, 40, 40 , 100};

//int difficulty = 1;

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
int leftDownTime = 0;
boolean rightDown = false;
int rightDownTime = 0;
int mX;
int mY;

// ===== MENU VALUES =====

String[] optionNames = {"Grid Size X", "Grid Size Y", "Mine Count"};
int[] optionValues = {20, 20, 80};
int selectedItem = 0;

// ===== PROCESSING FUNCTIONS =====

void setup() {
  size(1000, 1000);
}

void draw() {
  background(0);  
  runGame();
}

void keyPressed() {
  if(gameState != MENU) {
    if(key == 'r') {
      newGame();  
    }
    
    if(key == 'm') {
      gameState = MENU;  
    }
  }
  
  if(gameState == INPROGRESS) {
    if(key == ' ') {
      pauseGame();
    }
    
  
    //if(!setMousePos() || paused) { return; }
    
    //if(key == 'q') {
    //  if(rightDown) {
    //    attemptQuickReveal();
    //  } else {
    //    attemptReveal();
    //  }
    //  leftDown = true;
    //}
    
    //if(key == 'e') {
    //  if(leftDown) {
    //    attemptQuickReveal();  
    //  } else {
    //    placeFlag();
    //    rightDown = true;
    //  }
    //}
  } else {
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
      placeFlag();
      rightDown = true;
    }
  }
}

void mouseReleased() {
  if(mouseButton == RIGHT) {
    rightDown = false;
    rightDownTime = 0;
  }
  if(mouseButton == LEFT) {
    leftDown = false;
    leftDownTime = 0;
  }
}

// ===== GAME FUNCTIONS =====

// MENU
void selectItem(int x) {
  selectedItem = constrain(selectedItem += x, 0, optionNames.length - 1);
}

void changeValue(int x) {
  optionValues[selectedItem] += x;  
}

// PLAYER ACTIONS

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

void attemptReveal() {
  if(firstClick) {
    firstClick = false;
    generateMines(mX, mY);
  }
    
  if(checkMine(mX, mY)) {
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

void placeFlag() {
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
    
    timePassed += millis() - lastMilli;
    lastMilli = millis(); 
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
  if(squareSize * optionValues[0] > width) {
      squareSize = width / optionValues[0];
  }
  if(squareSize * optionValues[1] > height - infoAreaY) {
      squareSize = (height - infoAreaY) / optionValues[1];
  }
  
  gridOffset = new PVector((width - optionValues[0] * squareSize) / 2, (height + infoAreaY - optionValues[1] * squareSize) / 2);
  gridSize = new PVector(width - gridOffset.x * 2, width - gridOffset.y * 2);
  
  gameState = INPROGRESS;
  clickedMine = new int[] {-1, -1};
  flagsPlaced = 0;
  gridStates = new boolean[optionValues[0]][optionValues[1]];
  minePositions = new boolean[optionValues[0]][optionValues[1]];
  flagPositions = new boolean[optionValues[0]][optionValues[1]];
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

void revealAllSquares() {
  for(int i = 0; i < optionValues[0]; i++) {
    for(int k = 0; k < optionValues[1]; k++) {
      setSquareState(i, k);  
    }
  }
}

// GETTING AND SETTING SQUARES

void revealNonFlaggedSquares(int x, int y) {
  if(getAdjacentFlags(x, y) != getAdjacentMines(x, y)) {
    return;  
  }
  for(int i = x - 1; i <= x + 1; i++) {
    if(i >= optionValues[0] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) {       
      if(k >= optionValues[1] || k < 0) {
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
    if(i >= optionValues[0] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= optionValues[1] || k < 0) {
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
  if(getFlagState(x, y)) {
    flagsPlaced++;  
  } else {
    flagsPlaced--;
  }
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
  for(int i = 0; i < optionValues[0];i ++) {
    for(int k = 0; k < optionValues[1]; k++) {
      if(!getSquareState(i , k) && !checkMine(i, k)) {
        return false;
      }
    }
  }
  return true && gameState == INPROGRESS;
}

void generateMines(int originX, int originY) {
  int attempts = 0;
  for(int i = 1; i <= optionValues[2] && attempts < 1000; i++) {
    int x = (int)random(optionValues[0]);
    int y = (int)random(optionValues[1]);
    boolean valid = true;
    if(checkMine(x, y) || x > originX - 2 && x < originX + 2 && y > originY - 2 && y < originY + 2) {
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
    if(i >= optionValues[0] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= optionValues[1] || k < 0 || x == i && k == y) {
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
    if(i >= optionValues[0] || i < 0) {
      continue;  
    }
    for(int k = y - 1; k <= y + 1; k++) { 
      if(k >= optionValues[1] || k < 0 || x == i && k == y) {
        continue;  
      }
      if(getFlagState(i, k)) {
        result++;
      }
    }
  }
  return result;  
}

// ===== HELPER FUNCTIONS =====

String formatMillis(int millis) {
  int seconds = millis / 1000;
  return nf(seconds / 60, 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0);  
}

// ===== DRAW FUNCTIONS =====

void drawMine(int x, int y) {
  if(x == clickedMine[0] && y == clickedMine[1]) {
    fill(255, 0, 0);
  } else {
    fill(0);  
  }
  circle(gridOffset.x + x * squareSize + squareSize * 0.5, gridOffset.y + y * squareSize + squareSize * 0.5, squareSize * 0.8);  
}

void drawFlag(int x, int y) {
  fill(255, 0, 0);
  square(gridOffset.x + x * squareSize + squareSize * 0.25, gridOffset.y + y * squareSize + squareSize * 0.25, squareSize * 0.5);
}

void drawSquare(int x, int y, color c, int state) {
  fill(c);
  square(gridOffset.x + x * squareSize, gridOffset.y + y * squareSize, squareSize);
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
  for(int i = 0; i < optionValues[0]; i++) {
    for(int k = 0; k < optionValues[1]; k++) {         
           
      if(gridStates[i][k]) {
        drawSquare(i, k, color(190), 1);
      } else {
        drawSquare(i, k, color(220), 0);
      }

      if((rightDown || leftDown) && getSquareState(mX, mY)) {
        if(i - mX >= -1 && i - mX <= 1 && k - mY <= 1 && k - mY >= -1 && !getSquareState(i, k)) {
          drawSquare(i, k, color(240), 0);
        }
      }
      
      if(testMode & checkMine(i, k)) {
        drawMine(i, k);
      }

      if(gameState != INPROGRESS && checkMine(i, k)) {
        drawMine(i, k);
        textAlign(CENTER, CENTER);
        textSize(40);
        fill(255);
      }
      
      if(getFlagState(i, k)) {
        drawFlag(i, k);
      }
    }
  }
    
  if(gameState != INPROGRESS) {
    String text = "";
    if(gameState == WON) {
      text = "You Won!";
    } else {
      text = "You Lost!";  
    }
    
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    text(text, width * 0.5, (height + infoAreaY) * 0.5);
  }
}

void drawMenu() {
  textAlign(CENTER, CENTER);
  textSize(40);
  for(int i = 0; i < optionNames.length; i++) {
    if(i == selectedItem) {
      fill(255, 255, 15);
    } else {
      fill(255);  
    }
    text(optionNames[i] + ':' + optionValues[i], width * 0.5, height * (0.4 + 0.1 * i));  
  }
}

void drawInfoArea() {
  fill(80);
  rect(0, 0, width, infoAreaY);
  fill(255);
  textSize(40);
  text(formatMillis(timePassed), width * 0.5, infoAreaY - infoAreaY * 0.5);
  textAlign(LEFT, CENTER);
  text(optionValues[2] - flagsPlaced, width * 0.2, infoAreaY - infoAreaY * 0.5);
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
