abstract class Powerup {
  PVector position;
  int spawnTime;
  boolean expired = true;
  float spawnChance;

  Powerup (float spawnChance) {
    position = new PVector(random(width * 0.1, width * 0.9), random(height * 0.1, height * 0.9));
    spawnTime = millis();

    float decider = ceil(random(101) * 100);
    if (decider <= spawnChance * 100) {
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
    playSound(PICKUP);
    round.powerupsCollected += 1;
    expired = true;
  }
  
  void drawShape() {}
}

void createPowerupShape(PVector position, color drawColor, PImage image, String text) {
    pushMatrix();   
      textFont(willowFont);
      textSize(nX(30));
      textAlign(CENTER, CENTER);
      translate(position.x, position.y);
      fill(drawColor);
      tint(drawColor);
      image(image, nX(-25), nY(-25), nX(50), nY(50));
      text(text, 0, -nY(50));
    popMatrix();
}

class DamagePowerup extends Powerup {
  int damageIncrease;
  color drawColor = color(200, 0, 0);
  PImage image = loadImage("/textures/damageUp.png");
  
  DamagePowerup(int _damageIncrease, float _spawnChance) {
    super(_spawnChance);
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
  
  FireRatePowerup(float _fireRateIncrease, float _spawnChance) {
    super(_spawnChance);
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
  
  BulletSpeedPowerup(float _bulletSpeedIncrease, float _spawnChance) {
    super(_spawnChance);
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
  
  ShipSpeedPowerup(float _shipSpeedIncrease, float _spawnChance) {
    super(_spawnChance);
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
  
  AutoAimPowerup(float _duration, float _spawnChance) {
    super(_spawnChance);
    duration = _duration * powerupScale;
  }
  
  void pickup () {
    super.pickup(); 
    round.ply.weapon.enableAutoAim(duration); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, nf(duration) + "s Auto Aim");
  }
}

class ExtraBulletBouncesPowerup extends Powerup {
  float duration;
  color drawColor = color(255, 0, 200);
  PImage image = loadImage("/textures/bouncyBullets.png");
  
  ExtraBulletBouncesPowerup(float _duration, float _spawnChance) {
    super(_spawnChance);
    duration = _duration * powerupScale;
  }
  
  void pickup () {
    super.pickup(); 
    round.ply.weapon.enableExtraBounces(duration); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, nf(duration) + "s Bouncy Bullets");
  }
}

class ShipHealPowerup extends Powerup {
  float healthIncrease;
  color drawColor = color(255, 255, 255);
  PImage image = loadImage("/textures/shipHeal.png");
  
  ShipHealPowerup(float _healthIncrease, float _spawnChance) {
    super(_spawnChance);
    healthIncrease = floor(_healthIncrease * powerupScale);
  }
  
  void pickup () {
    super.pickup(); 
    round.ply.heal(healthIncrease); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, nf(healthIncrease) + " Health");
  }
}

class ShipInvinciblePowerup extends Powerup {
  float duration;
  color drawColor = color(250, 190, 0);
  PImage image = loadImage("/textures/shipInvincible.png");
  
  ShipInvinciblePowerup(float _duration, float _spawnChance) {
    super(_spawnChance);
    duration = _duration * powerupScale;
  }
  
  void pickup () {
    super.pickup(); 
    round.ply.enableNoDamage(duration); 
  }
  
  void drawShape() {
    createPowerupShape(position, drawColor, image, nf(duration) + "s Invincibility");
  }
}
