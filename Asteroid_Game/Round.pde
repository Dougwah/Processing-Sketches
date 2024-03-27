// GAME VALUES
float difficultyScaleRate = 0.03;                  // How fast the asteroid level increases
// PLAYER VALUES
float plyMaxVelocity = 50;
float plyAccelerationRate = 0.6;
float plyDeccelerationRate = 0.05;
float plyRotationRate = 0.04;
int plyMaxHealth = 50;
// WEAPON VALUES
int WeaponDamage = 1;
int WeaponFireRate = 2;
PVector BulletSize = new PVector(10, 40);
float BulletSpeed = 0.8;
// ASTEROID VALUES
float asteroidBaseHealth = 2;
float asteroidBaseDamage = 1;
float asteroidBaseRadius = 30;
float asteroidBaseScore = 10;
float asteroidMinSpeed = 4;
float asteroidMaxSpeed = 12;
float asteroidMinLevel = 1;
float asteroidMaxLevel = 3;
int asteroidMaxAmount = 10;
int asteroidSpawnInterval = 2;
int asteroidSpawnIntervalVariance = 1;

class Round {
 int score = 0;
 boolean over = false;
 float difficultyScaleRate;
 float difficultyScale = 1;
 float lastTick;
 
 Player ply;
 ArrayList<Bullet> bullets = new ArrayList<Bullet>();
 ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
 
 Round(float _difficultyScaleRate) {
   difficultyScaleRate = _difficultyScaleRate;
   lastTick = millis();
   
   ply = new Player(
     new PVector(width / 2, height / 2), 
     plyMaxVelocity,
     plyAccelerationRate, 
     plyDeccelerationRate, 
     plyRotationRate, 
     plyMaxHealth
     );
     
   ply.setWeapon(new Weapon(
     WeaponDamage, 
     WeaponFireRate, 
     BulletSize, 
     BulletSpeed
     ));
   
  for (int i = 0; i < asteroidMaxAmount; i++) {
    asteroids.add(new Asteroid());
  }
   
 }
 
 void run() {
  if (ply.getDestroyed()) { 
      endGame();
      return; 
   }
   
   drawRoundInfo();
   ply.run();
   
   if (millis() > lastTick + 1000) {
     difficultyScale += difficultyScale * difficultyScaleRate;
     lastTick = millis();
   }
   
   // RUN ASTEROIDS
   for (int i = asteroids.size() - 1; i >= 0; i--) {
     Asteroid a = asteroids.get(i);
     a.run();
   }
   
   // RUN BULLETS
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    
    if (b.destroyed == true) {
      bullets.remove(b);
      continue;
    }
    b.run();
  }
  
 }
 
 void endGame() {
  rectMode(CORNER);
  fill(0, 0, 255);
  rect(0, 0, width, height);
}
 
 void addScore(float _score) {
  score += _score;
  score = round(score);
}
  
 void drawRoundInfo() {
   pushMatrix();
     fill(0, 255, 0);
     textFont(marineFont);
     textSize(50);
     textAlign(CENTER, CENTER);
     text("Score:\n\n" + score, width / 2, 100);
   popMatrix();
 }
}
