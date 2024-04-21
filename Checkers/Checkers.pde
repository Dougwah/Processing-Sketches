int tileWidth;
int halfTileWidth;
PVector[] circlePositions;
int currentTile = 0;

PVector[][] positions = new PVector[8][8];
int[][] piecePositions = new int[8][8];
// 0 - Empty
// 1 - Black
// 2 - Red

boolean pieceSelected = false;
int currentPlayersTurn = 1;
int lastI;
int lastK;

void setup() {
  noStroke();
  size(1000, 1000);
  
  tileWidth = width / 8;
  halfTileWidth = tileWidth / 2;
  createBoard();
  createPieces();
}

void draw() {
  drawBoard();
  drawPieces();
  if (pieceSelected) {
    int[] mouseTile = getMouseTile();
    PVector pos = positions[mouseTile[0]][mouseTile[1]];
    if (validateMove(mouseTile[0], mouseTile[1])) {
      fill(255);
    } else {
      fill(150);
    }
    circle(pos.x, pos.y, halfTileWidth);
  }
}

void mousePressed() {
  int[] mouseTile = getMouseTile();
  int i = mouseTile[0];
  int k = mouseTile[1];

  if(!pieceSelected && piecePositions[i][k] == currentPlayersTurn) {
    lastI = i;
    lastK = k;
    pieceSelected = true;
  } else {
    if(validateMove(i, k)) {
      piecePositions[i][k] = piecePositions[lastI][lastK];
      piecePositions[lastI][lastK] = 0;
      if (currentPlayersTurn == 1) {
        currentPlayersTurn = 2;
      } else {
        currentPlayersTurn = 1; 
      }
    }   
    pieceSelected = false;
  }
}

int[] getMouseTile() {
  return new int[] {floor(mouseX / tileWidth), floor(mouseY / tileWidth)};
}

int[] getTileDistance(int i, int k, int i2, int k2) {
  return new int[] {i - i2, k - k2};
}

boolean validateMove(int i, int k) {
  int[] dist = getTileDistance(i, k, lastI, lastK);
  
  if(dist[1] > 0 && currentPlayersTurn == 2 || dist[1] < 0 && currentPlayersTurn == 1) { // No backwards
    return false;  
  }
  
  if(dist[0] == 0 || dist[1] == 0 || piecePositions[i][k] > 0) { // Only diagonal, Cant move onto taken square
    return false;  
  }
  
  //if() {
  //  
  //}
  
  if(abs(dist[0]) > 1 || abs(dist[1]) > 1) { // Can only move 1 tile away
    return false;  
  }

  
  checkDiagonals(i, k);
  return true;
}

int[][] checkDiagonals(int i, int k) {
  int[][] result = new int[4][2];
  for(int j = -1; j <= 1; j+=2) {
    for(int l = -1; l <= 1; l+=2) {
      int pieceType = piecePositions[constrain(i + j, 0, 7)][constrain(k + l, 0, 7)];
      if(pieceType > 0 && pieceType != currentPlayersTurn) {  
        println(i + j, k + l);
      }
    }
  }
  println();  
  return result;
}

void createBoard() {
   for(int i = 0; i < 8; i++) {
    PVector[] row = new PVector[8];
    for(int k = 0; k < positions.length; k++) {
      row[k] = new PVector(i * tileWidth + halfTileWidth, k * tileWidth + halfTileWidth);
    }
    positions[i] = row; 
  }
}

void createPieces() {
  for(int i = 0; i < positions.length; i++) {
    for(int k = 0; k < positions.length; k++) {
      if((k + i) % 2 != 0) {
        if(i < 3) {
          piecePositions[k][i] = 1;
        }
        if(i > 4) {
          piecePositions[k][i] = 2;
        }    
      }  
    }
  }
}

void drawBoard() {
  for(int i = 0; i < 8; i++) {
    for(int k = 0; k < 8; k++) {
      if((k + i) % 2 != 0) {
        fill(118, 145, 84);
      } else {
        fill(233, 233, 206);  
      }
      square(positions[i][k].x - halfTileWidth, positions[i][k].y - halfTileWidth, tileWidth);
    }
  }
}

void drawPieces() {
  for(int i = 0; i < 8; i++) {
    for(int k = 0; k < 8; k++) {
      if (piecePositions[i][k] == 1) {
        fill(198, 64, 60);
        circle(positions[i][k].x, positions[i][k].y, tileWidth * 0.8); 
      } else if (piecePositions[i][k] == 2) {
        fill(0);  
        circle(positions[i][k].x, positions[i][k].y, tileWidth * 0.8); 
      }

    }
  }
}
