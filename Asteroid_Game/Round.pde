// GAME VALUES
float difficultyScaleRate = 0.03;
// POWERUP VALUES
float powerupSpawnChance = 10;
float powerupScale = 1;
float powerupLifeTime = 10;
// PLAYER VALUES
float plyMaxVelocity = 10;
float plyAccelerationRate = 0.2;
float plyDeccelerationRate = 0.05;
float plyRotationRate = 0.04;
int plyMaxHealth = 5;
// WEAPON VALUES
int weaponDamage = 1;
int weaponFireRate = 2;
PVector bulletSize = new PVector(10, 30);
float bulletSpeed = 0.1;
int bulletMaxBounces = 1;
// ASTEROID VALUES
float asteroidBaseHealth = 2;
float asteroidBaseDamage = 1;
float asteroidBaseRadius = 30;
float asteroidBaseScore = 10;
float asteroidMinSpeed = 2;
float asteroidMaxSpeed = 6;
float asteroidMinLevel = 1;
float asteroidMaxLevel = 3;
int asteroidMaxAmount = 15;
int asteroidSpawnInterval = 2;
int asteroidSpawnIntervalVariance = 1;

class Round {
  int score;
  boolean over;
  float difficultyScaleRate;
  float difficultyScale;
  float lastTick;
  float scoreLastAdded;
   
  Player ply;

  Round(float _difficultyScaleRate) {
    difficultyScaleRate = _difficultyScaleRate;
    init();
  }
  
  void init() {
    score = 0;
    over = false;
    difficultyScale = 1;
    lastTick = millis();
    scoreLastAdded = millis();
    
    ply = new Player(
      new PVector(width / 2, height / 2), 
      plyMaxVelocity,
      plyAccelerationRate, 
      plyDeccelerationRate, 
      plyRotationRate, 
      plyMaxHealth
    );
     
    ply.setWeapon(new Weapon(
      weaponDamage, 
      weaponFireRate, 
      bulletSize, 
      bulletSpeed,
      bulletMaxBounces
    ));

    objHandler = new ObjectHandler();
    
    for (int i = 0; i < asteroidMaxAmount; i++) {
      new Asteroid();
    }
  }

  void run() {
    if (ply.getDestroyed()) { 
       endGame();

       if (keys[89]) {
         init();
         return;
       }
       
       if (keys[78]) {
         exit(); 
       }
       return;
    }
    
    ply.run();
    objHandler.run();
     
    if (millis() > lastTick + 1000) {
      difficultyScale += difficultyScale * difficultyScaleRate;
      spawnPowerups();
      lastTick = millis();
    }

   drawRoundInfo();
  }
  
  void spawnPowerups() {
    if (millis() > scoreLastAdded + 10000) { return; }
    println(scoreLastAdded);
    println(millis());

    new ShipSpeedPowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 0.05, 0.4);
    new BulletSpeedPowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 0.05, 0.5);
    new FireRatePowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 1, 0.75);
    new DamagePowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 1, 0.8);
    new AutoAimPowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 10, 0.15);
    new ExtraBulletBouncesPowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 10, 0.15);
  }
 
  void endGame() {
    objHandler.createArrays();
    pushMatrix();
      fill(0, 255, 0);
      textFont(marineFont);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("Score: " + score, width / 2, height / 2);
      textSize(128);
      text("YOU DIED", width / 2, height / 2.5);
      textFont(willowFont);
      textSize(50);
      text("Continue? [Y/N]", width / 2, height / 1.5);      
    popMatrix();
  }
 
  void addScore(float _score) {
    score += _score;
    score = round(score);
    scoreLastAdded = millis();
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
