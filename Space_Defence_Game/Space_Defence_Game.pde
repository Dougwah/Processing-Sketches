int infoAreaY = 50;
int score;
int millisPassed;
int lastMilli;
boolean gameStarted;

// CROSSHAIR
float crossHairX = 3.;
float crossHairY = 20.;
float xHairGap = 10.;
color xHairColor = color(255, 255, 255);
PVector mousePos;

// ENEMIES
int FRIGATE = 0;
int CRUISER = 1;
int DESTROYER = 2;
int[] shipHealthValues = {1, 5, 3};
int[] shipDamageValues = {1, 2, 0};
int[] shipSpeedValues = {10, 5, 5};
int[] shipPointValues = {10, 20, 15};

int enemyCount;
int[] enemies = new int[50];
PVector[] enemyPositions = new PVector[50];
int[] enemyHealth = new int[50];

// PROJECTILES
int CANNON = 0;
int[] projHealthValues = {1};
int[] projDamageValues = {3};
int[] projSpeedValues = {3};
int[] projPointValues = {30};

PVector[] projectilePositions = new PVector[50];

void setup() {
  noCursor();
  size(800, 600);
  gameStarted = true;
}

void draw() {
  background(0, 0, 0);
  
  if (!gameStarted) {
    newGame();  
  }
  
  // GAME INFO AREA
  fill(255, 255, 255);
  rect(0, 0, width, infoAreaY);
  
  // SPACE STATION
  fill(#08CFFF);
  circle(width / 2, height / 2, 100);
  
  // CROSSHAIR
  mousePos = getMousePos();
  fill(xHairColor);
  rect(mousePos.x - xHairGap - crossHairY, mousePos.y - crossHairX / 2, crossHairY, crossHairX); // LEFT
  rect(mousePos.x + xHairGap, mousePos.y - crossHairX / 2, crossHairY, crossHairX);              // RIGHT
  rect(mousePos.x - crossHairX / 2, mousePos.y - crossHairY - xHairGap, crossHairX, crossHairY); // UP
  rect(mousePos.x - crossHairX / 2, mousePos.y + xHairGap, crossHairX, crossHairY);              // DOWN
  noFill();
  strokeWeight(crossHairX);
  stroke(xHairColor);
  circle(mousePos.x, mousePos.y, crossHairY);
  point(mousePos.x, mousePos.y);
  
  if (enemyCount < 50) {
    newShip(1);
  }
  for (int i = enemyCount - 1; i >= 0; i--) {
    fill(255);
    circle(enemyPositions[i].x, enemyPositions[i].y, 50);  
  }
}

void newGame() {
  score = 0;
  millisPassed = 0;
  lastMilli = 0;
  enemyCount = 0;
  gameStarted = true;
}

void newShip(int shipType) {
  enemies[enemyCount] = shipType;
  PVector position;
  if (boolean((int)random(2))) {
    position = new PVector(random(width), height * (int)random(2));
    println("x");
  } else {
    println("y");
    position = new PVector(width * (int)random(2), random(infoAreaY, height));
  }
  enemyPositions[enemyCount] = position;
  enemyCount += 1;
}

// Limits the y position of the mouse
PVector getMousePos() {
  return new PVector(mouseX, max(mouseY, infoAreaY));
}
