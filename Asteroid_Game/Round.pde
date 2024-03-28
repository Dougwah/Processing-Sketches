// GAME VALUES
float difficultyScaleRate = 0.03;
// POWERUP VALUES
float powerupSpawnChance = 0.2;
float powerupScale = 1;
float powerupLifeTime = 10;
// PLAYER VALUES
float plyMaxVelocity = 10;
float plyAccelerationRate = 0.2;
float plyDeccelerationRate = 0.05;
float plyRotationRate = 0.04;
int plyMaxHealth = 50;
// WEAPON VALUES
int WeaponDamage = 1;
int WeaponFireRate = 2;
PVector BulletSize = new PVector(10, 30);
float BulletSpeed = 0.1;
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
   
  Player ply;
  Background bg;
  ArrayList<Bullet> bullets;
  ArrayList<Asteroid> asteroids;
  ArrayList<DamageEffect> damageEffects;
   
  Round(float _difficultyScaleRate) {

    difficultyScaleRate = _difficultyScaleRate;
    init();
  }
  
  void init() {
    score = 0;
    over = false;
    bullets = new ArrayList<Bullet>();
    asteroids = new ArrayList<Asteroid>();
    damageEffects = new ArrayList<DamageEffect>();
    difficultyScale = 1;
    lastTick = millis();
    
    bg = new Background();
     
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

    objHandler = new ObjectHandler();
    
    for (int i = 0; i < asteroidMaxAmount; i++) {
      new Asteroid();
    }
    

  }

  void run() {
    if (ply.getDestroyed()) { 
       endGame();
       return;
    }
     
    bg.run();
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
    float decider = ceil(random(101));
    if (decider <= powerupSpawnChance * 100) {
      new DamagePowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 1);
      new FireRatePowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 1);
      new BulletSpeedPowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 0.1);
      new ShipSpeedPowerup(new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8)), 0.05);
    }
  }
 
  void endGame() {
    init();
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
