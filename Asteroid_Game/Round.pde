// GAME VALUES
float difficultyScaleRate = 0.03;
// POWERUP VALUES
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
float asteroidMaxRadius = 150;
float asteroidBaseScore = 10;
float asteroidMinSpeed = 2;
float asteroidMaxSpeed = 10;
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
  float scoreLastAdded;
  int powerupsCollected;
  int lastSecond;
  int lastMilli;
  int timePassed;
   
  Player ply;

  Round(float _difficultyScaleRate) {
    difficultyScaleRate = _difficultyScaleRate;
    init();
  }
  
  void init() {
    score = 0;
    over = false;
    difficultyScale = 1;
    lastSecond = millis();
    scoreLastAdded = millis();
    powerupsCollected = 0;
    lastSecond = 0;
    lastMilli = millis();
    timePassed = 0;
    
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
     
    if (millis() > lastSecond + 1000) {
      difficultyScale += difficultyScale * difficultyScaleRate;
      spawnPowerups();
      lastSecond = millis();
    }
    
    timePassed += millis() - lastMilli;
    lastMilli = millis();
   drawRoundInfo();
  }
  
  void spawnPowerups() {
    if (millis() > scoreLastAdded + 10000) { return; }
    new ShipSpeedPowerup(0.05, 5);
    new BulletSpeedPowerup(0.05, 8);
    new FireRatePowerup(1, 8);
    new DamagePowerup(1, 8);
    new AutoAimPowerup(15, 3);
    new ExtraBulletBouncesPowerup(15, 2);
    new ShipHealPowerup(1, 9);
    new ShipInvinciblePowerup(5, 2);
  }
 
  void endGame() {
    objHandler.createArrays();
    pushMatrix();
      fill(0, 255, 0);
      textFont(marineFont);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("Score: " + score, width / 2, height / 2);
      text("Time: " + formatMillis(timePassed), width / 2, height / 1.8);
      text("Powerups: " + powerupsCollected, width / 2, height / 1.6);
      textSize(128);
      text("YOU DIED", width / 2, height / 2.4);
      textFont(willowFont);
      textSize(50);
      text("Continue? [Y/N]", width / 2, height / 1.3);  
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
     
     pushMatrix();
      textSize(25);
      textAlign(LEFT, CENTER);
      text("Time: " + formatMillis(timePassed), width * 0.05, 100);
      textAlign(CENTER, CENTER);
      text("Health", width * 0.8, 100);
     popMatrix();
     
    PVector shipSize = new PVector(20, 44);
    float shipDistance = 80;
    float listWidth = shipSize.x + shipDistance * (ply.getHealth() + 1);
    float listCentre = listWidth / 2 - (shipSize.x / 2);
    color iconColor = color(255, 255, 255);

    for (int i = 1; i <= ply.getHealth(); i++) {
      PVector iconPosition = new PVector(((width * 0.8 - listCentre) + shipDistance * i), 120);
      pushMatrix();
        if (ply.getInvincible()) {
          iconColor = color(250, 190, 0);
        }
        drawPlayerShape(iconPosition, ply.getSize(), iconColor, radians(1));
      popMatrix();
    }
  }
}
