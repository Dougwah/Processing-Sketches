int tileWidth;
int halfTileWidth;
PVector[] circlePositions;
int currentTile = 0;

//Piece[] pieces = new Piece[24];
PVector[][] positions = new PVector[8][8];
int[][] piecePositions = new int[8][8];

boolean pieceSelected = false;
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
}

void mousePressed() {
  int i = floor(mouseY / tileWidth);
  int k = floor(mouseX / tileWidth);
  boolean validMove = true;
  if(!pieceSelected) {
    lastI = i;
    lastK = k;
    pieceSelected = true;
  } else {
    if(piecePositions[lastI][lastK] == 1) {
       if (lastI > i || i - lastI > 1) {
         validMove = false;  
       }
    } else {
       if (lastI < i || lastI - i > 1) {
         validMove = false;  
       }
    }
    if(k == lastK || i == lastI || piecePositions[i][k] > 0) {
      validMove = false;  
    }
    if(validMove) {
      piecePositions[i][k] = piecePositions[lastI][lastK];
      piecePositions[lastI][lastK] = 0;
    }   
    
    pieceSelected = false;
  }
}

int currentPiece = 0;
void createPieces() {
  for(int i = 0; i < positions.length; i++) {
    for(int k = 0; k < positions.length; k++) {
      if((k + i) % 2 != 0) {
        if(i < 3) {
          piecePositions[i][k] = 1;
        }
        if(i > 4) {
          piecePositions[i][k] = 2;
        }    
      }  
    }
  }
}

void createBoard() {
   for(int i = 0; i < 8; i++) {
    PVector[] row = new PVector[8];
    for(int k = 0; k < positions.length; k++) {
      row[k] = new PVector(k * tileWidth + halfTileWidth, i * tileWidth + halfTileWidth);
    }
    positions[i] = row; 
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
