class Powerup {
  PVector position;
  int spawnTime;
  boolean expired = false;

  Powerup (PVector _position) {
    position = _position;
    spawnTime = millis();
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
  
  DamagePowerup(PVector _position, int _damageIncrease) {
    super(_position);
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
  
  FireRatePowerup(PVector _position, float _fireRateIncrease) {
    super(_position);
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
  
  BulletSpeedPowerup(PVector _position, float _bulletSpeedIncrease) {
    super(_position);
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
  
  ShipSpeedPowerup(PVector _position, float _shipSpeedIncrease) {
    super(_position);
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
