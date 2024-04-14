// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxLives = 5;
PVector stationSize = new PVector(140, 80);
int initialShipSpeed = 1;

PVector xHairSize = new PVector(3, 20);
int xHairGap = 10;
color xHairColor = color(255, 255, 255);

// ===== BACKGROUND OBJECT SETTINGS =====
PVector lShipSize = new PVector(300, 120); // 1 : 2.5 aspect ratio
PVector rShipSize = new PVector(300, 120);
PVector lShipPos = new PVector(180, 200);
PVector rShipPos = new PVector(620, 180);

boolean lightOn = false;
int lastLightTime = millis();

// ===== CURRENT ROUND VALUES =====
int gameState = 0; // 0 == start screen, 1 = game screen, 2 = end screen
int score;
int kills;
int lives;

float shotsTaken;
float shotsHit;

int millisPassed;
int lastMilli;

PVector mousePos = new PVector();
PVector centrePos;

boolean targetAlive = false;
int currentShipMaxSpeed;


void setup() {
  noCursor();
  size(800, 600);
  centrePos = new PVector(width * 0.5, height * 0.5 + (infoAreaY * 0.5));
  lShipPos = new PVector(180, 200);
  rShipPos = new PVector(width - 180, 180);
}

void draw() {
  background(0);
  
  if (gameState == 2) {
    drawEndScreen();
    return;
  }
  
  if (gameState == 0) {
    drawStartScreen();
    return;
  }
  
  mousePos.x = mouseX;
  mousePos.y = max(mouseY, infoAreaY);
  
  if(!targetAlive) {
    
  }
  
  currentShipMaxSpeed += 0.001; // Make the difficulty ramp up over time
  
  drawBackgroundObjects();
  drawCrosshair();
  drawInfoArea();
  
  millisPassed += millis() - lastMilli;
  lastMilli = millis();
}


/*
Background is the correct size                                            2
There is a start screen                                                   2
User can only move to the game screen when a key is pressed               2
Game screen has 2 sections and at least 4 shapes to add visual interest   6
Score and lives are displayed using variables                             3
Target is a composite shape                                               12
Cross hairs are a composite shape                                         12
Target appears at a random location                                       2
A target is hit if the cross hairs and target collide                     10
If a target is hit it should disappear                                    5
When the target reappears the type of target is randomized                5
When target reappears, its location is randomized                         5
Target and cross hairs should be limited to the game area ONLY            5
All of the target should be confined to the game area                     2
Score and lives update as per the target and if it was a successful hit   6
No key presses should work on the game screen                             2
There is a finite end to game                                             4
When game ends it moves to final screen with detail displayed             4
Pressing a key should bring user back to game screen                      4
Upon returning to game screen, scores and lives reset                     2
Creativity                                                                5
*/

/*
Background(800, 600)
2 sections, 1 for game info, other for game
4 static shapes in background for visual interest
Targets and crosshairs must consist of 5 different shapes with more than 1 color
2 types of target, distinguishable appearance
show score and lives left on top section of screen

Begins with start screen, game starts when key is pressed
target randomly chosen between the 2 types
target appears at random position on games screen not cut off by edges
crosshair follows mouse
clicking mouse counts as shot taken
one target increases score by 4 while the other reduces it by 1
decrement lives if shot has missed
game has finite end
end screen that displays stats and allows restarting of game
*/
