// === GAME SETTINGS ===

int gridSizeX = 7;
int gridSizeY = 6;
int winLength = 4;
color[] colors = {color(255), color(230, 73, 68), color(250, 215, 80)};

// === ROUND VALUES ===

int[][] gridStates;
int gameState;
boolean p1Turn;
int circleDia;
int lastGridX;
int lastGridY;
float tempY;
int mX;

// === PROCESSING FUNCS ===

void setup() {
  noStroke();
  size(1000, 1000);
  circleDia = width / gridSizeX;
  newRound();
}

void draw() {
  background(255);
  fill(8, 100, 200);
  rect(0, 150, width, height);
  runGame();
}

void mousePressed() {
  if(gameState == 1 && mX < gridSizeX) {
    placeDisk();
  }
}

void keyPressed() {
 if(Character.toLowerCase(key) == 'r') {
   newRound();
 }
}

// === GAME FUNCS ===

void runGame() {
  mX = (int)mouseX / circleDia; 
  
  drawSlots();
  if(gameState == 1) {
    drawPreviewDisk();  
  }

  drawGameInfo();
}

void newRound() {
  gridStates = new int[gridSizeX][gridSizeY];
  gameState = 1;
  lastGridX = -1;
  lastGridY = -1;
  p1Turn = true;
}

void endRound() {
  gameState = 2;
}

void placeDisk() {
  int i = mX;
  int k = gridSizeY - getColumnHeight(i) - 1;
  
  if(k < 0) {
    return;  
  }
  
  int type = 1;
  if(!p1Turn) {
    type = 2;  
  }
  
  gridStates[i][k] = type;
  tempY = 75;
  lastGridX = i;
  lastGridY = k;
  
  if(checkRun(i, k)) {
    endRound();  
  } else {
    p1Turn = !p1Turn;  
  }
}

boolean checkRun(int x, int y) {
  int type = 1;
  int[] counts = new int[4];

  if(!p1Turn) {
    type = 2;  
  }
 
  for(int i = 0; i < gridStates.length; i++) {
    for(int k = 0; k < gridStates[i].length; k++) {
      boolean match = gridStates[i][k] == type;
     
      if(i == x) {
        if(match) {
          counts[0]++;
          if(counts[0] == winLength) {
            return true;  
          }
        } else {
          counts[0] = 0;
        }
      }

      if(k == y) {
        if(match) {
          counts[1]++;
          if(counts[1] == winLength) {
            return true;  
          }
        } else {
          counts[1] = 0;
        }
      }
      
      if(i + y == k + x) {
        if(match) {
          counts[2]++;
          if(counts[2] == winLength) {
            return true;  
          }
        } else {
          counts[2] = 0;
        }
      }
      
      if(i - x == y - k) {
        if (match) {
          counts[3]++;
          if(counts[3] == winLength) {
            return true;  
          }
        } else {
          counts[3] = 0;
        }
      }
    }
  }
  
  return false;
}

int getColumnHeight(int i) {
  int count = 0;
  for(int k = 0; k < gridStates[i].length; k++) {
    if(gridStates[i][k] > 0) {
      count++;  
    }
  }
  return count;
}

// === DRAW FUNCS ===

void drawSlots() {
  for(int i = 0; i < gridStates.length; i++) {
    for(int k = 0; k <gridStates[i].length; k++) {
      float y = k * (height - 150) / gridSizeY + circleDia * 0.5 + 150;
      if(i == lastGridX && k == lastGridY) {
        fill(255);
        circle(i * width / gridSizeX + circleDia * 0.5, y, circleDia * 0.9); 
        y = tempY;
      }
      
      fill(colors[gridStates[i][k]]);
      circle(i * width / gridSizeX + circleDia * 0.5, y, circleDia * 0.9); 
    }
  }
  tempY *= 1.08;
  tempY = min(tempY, lastGridY * (height - 150) / gridSizeY + circleDia * 0.5 + 150);
}

void drawPreviewDisk() {
  if(p1Turn) {
    fill(colors[1]);  
  } else {
    fill(colors[2]);  
  }
  circle(mX * width / gridSizeX + circleDia * 0.5, 75, circleDia * 0.9);
}

void drawGameInfo() {
  if(gameState == 2) {
    String text = "Player 1 Wins!";
    if(!p1Turn) {
      text = "Player 2 Wins!";
    }
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(40);
    text(text, width / 2, 50);
  }
}
