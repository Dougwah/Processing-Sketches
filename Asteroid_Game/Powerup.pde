class Powerup {
  PVector position;
  int spawnTime;
  boolean expired = true;

  Powerup (PVector _position, float spawnChanceMulti) {
    position = _position;
    spawnTime = millis();

    float decider = ceil(random(101));
    if (decider <= powerupSpawnChance * spawnChanceMulti) {
      expired = false;
    }
    
    objHandler.powerups.add(this);
  }
  
  void run () {
    if (millis() > spawnTime + (powerupLifeTime * 1000)) {
      expired = true; 
    }
    checkCollisions();
    drawShape();
  }
  
  void checkCollisions() {
    float distance = PVector.sub(round.ply.getPosition(), position).mag();
    float minDistance = 25 + (round.ply.getSize().y /2);
    
    if (distance < minDistance) {
       pickup(); 
    }
  }
  
  void pickup () {
    playSound(5);
    expired = true;
  }
  
  void drawShape() {}
}

void createPowerupShape(PVector position, color drawColor, PImage image, String text) {
    pushMatrix();   
      textFont(willowFont);
      textSize(30);
      textAlign(CENTER, CENTER);
      translate(position.x, position.y);
      fill(drawColor);
      tint(drawColor);
      image(image, -25, -25, 50, 50);
      text(text, 0, -50);
    popMatrix();
}

class DamagePowerup extends Powerup {
  int damageIncrease;
  color drawColor = color(200, 0, 0);
  PImage image = loadImage("/textures/damageUp.png");
  float spawnChanceMulti = 1;
  
  DamagePowerup(PVector _position, int _damageIncrease, float _spawnChanceMulti) {
    super(_position, _spawnChanceMulti);
    damageIncrease = ceil(_damageIncrease * (powerupScale * round.difficultyScale / 2));
  }
  
  void pickup () {
    super.pickup();
    round.ply.weapon.addDamage(damageIncrease); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, str(damageIncrease));
  }
}

class FireRatePowerup extends Powerup {
  float fireRateIncrease;
  color drawColor = color(0, 0, 200);
  PImage image = loadImage("/textures/fireRateUp.png");
  float spawnChanceMulti = 0.5;
  
  FireRatePowerup(PVector _position, float _fireRateIncrease, float _spawnChanceMulti) {
    super(_position, _spawnChanceMulti);
    fireRateIncrease = _fireRateIncrease * (powerupScale * 0.5);
  }
  
  void pickup () {
    super.pickup();
    round.ply.weapon.addFireRate(fireRateIncrease); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, nf(round(fireRateIncrease * 10) * 0.1));
  }
}

class BulletSpeedPowerup extends Powerup {
  float bulletSpeedIncrease;
  color drawColor = color(0, 200, 0);
  PImage image = loadImage("/textures/bulletSpeedUp.png");
  float spawnChanceMulti = 0.75;
  
  BulletSpeedPowerup(PVector _position, float _bulletSpeedIncrease, float _spawnChanceMulti) {
    super(_position, _spawnChanceMulti);
    bulletSpeedIncrease = _bulletSpeedIncrease * powerupScale;
  }
  
  void pickup () {
    super.pickup();
    round.ply.weapon.addBulletSpeed(bulletSpeedIncrease); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, nf(round(bulletSpeedIncrease * 100) * 0.1));
  }
}

class ShipSpeedPowerup extends Powerup {
  float shipSpeedIncrease;
  color drawColor = color(255, 255, 255);
  PImage image = loadImage("/textures/shipSpeedUp.png");
  float spawnChanceMulti = 0.25;
  
  ShipSpeedPowerup(PVector _position, float _shipSpeedIncrease, float _spawnChanceMulti) {
    super(_position, _spawnChanceMulti);
    shipSpeedIncrease = _shipSpeedIncrease * powerupScale;
  }
  
  void pickup () {
    super.pickup();
    round.ply.addShipSpeed(shipSpeedIncrease); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, nf(round(shipSpeedIncrease * 1000) * 0.1));
  }
}

class AutoAimPowerup extends Powerup {
  float duration;
  color drawColor = color(255, 0, 200);
  PImage image = loadImage("/textures/autoAim.png");
  float spawnChanceMulti = 0.1;
  
  AutoAimPowerup(PVector _position, float _duration, float _spawnChanceMulti) {
    super(_position, _spawnChanceMulti);
    duration = _duration;
  }
  
  void pickup () {
    super.pickup(); 
    round.ply.weapon.enableAutoAim(duration); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, "Auto Aim");
  }
}

class ExtraBulletBouncesPowerup extends Powerup {
  float duration;
  color drawColor = color(255, 0, 200);
  PImage image = loadImage("/textures/bouncyBullets.png");
  float spawnChanceMulti = 0.1;
  
  ExtraBulletBouncesPowerup(PVector _position, float _duration, float _spawnChanceMulti) {
    super(_position, _spawnChanceMulti);
    duration = _duration;
  }
  
  void pickup () {
    super.pickup(); 
    round.ply.weapon.enableExtraBounces(duration); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, "Bouncy Bullets");
  }
}
