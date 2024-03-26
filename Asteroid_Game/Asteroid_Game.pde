boolean gameOver = false;
Player ply;
Weapon plyWep;

void setup() {
  size(1920, 1080);
  frameRate(238);
  
  ply = new Player(new PVector(width / 2, height / 2));
  plyWep = new Weapon(10, 5, new PVector(20, 20), 0.2);
  ply.setWeapon(plyWep);
  
  initAsteroids();
}

void draw() {
  if (gameOver == true) { 
    fill(0, 0, 255);
    rect(0, 0, width, height);
    return; 
  }
  background(0);
  noStroke();
  ply.run();
  
  runAsteroids();
  runBullets();
}


void endGame() {
  gameOver = true;
}

float NormalizeFrames(float x) {
  return x * (238 / frameRate);
}
