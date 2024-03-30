class Weapon {
  private int damage;
  private float fireRate;
  private PVector bulletSize;
  private float bulletSpeed;
  private int bulletMaxBounces;
  private float extraBounceEndTime;
  private float autoAimEndTime;
  
  private int lastFired;
  
  Weapon(int _damage, float _fireRate, PVector _bulletSize, float _bulletSpeed, int _bulletMaxBounces) {
    damage = _damage;
    fireRate = _fireRate;
    bulletSize = _bulletSize;
    bulletSpeed = _bulletSpeed;
    bulletMaxBounces = _bulletMaxBounces;
    
    lastFired = millis();
   }
   
  void addDamage(int _damage) {
    damage += _damage;
  }
   
  void addFireRate(float _fireRate) {
     fireRate += _fireRate;
   }
   
  void addBulletSpeed(float _bulletSpeed) {
    bulletSpeed += _bulletSpeed;
  }
   
  void enableExtraBounces(float duration) {
    extraBounceEndTime = millis() + duration * 1000;
  }
   
  void enableAutoAim(float duration) {     
    autoAimEndTime = millis() + duration * 1000;
  }
   
  void fire(PVector startPos, PVector endPos, PVector initialVelocity) {
    if (millis() < lastFired + (1000 / fireRate)) {
      return;
    }
    
    color drawColor = color(0, 255, 0);
    float velocityMult = bulletSpeed;
    int bulletBounces = bulletMaxBounces;
    if (extraBounceEndTime > millis()) {
      drawColor = color(255, 0, 200);
      bulletBounces = 3;
    }
    
    if (autoAimEndTime > millis()) {
      Asteroid closestAsteroid = objHandler.asteroids.get(0);
      float smallestMagnitude = 1e6;
      for (int i = objHandler.asteroids.size() - 1; i >= 0; i--) {
        Asteroid a = objHandler.asteroids.get(i);
        float magnitude = PVector.sub(startPos, a.position).mag();
        if (magnitude < smallestMagnitude) {
          smallestMagnitude = magnitude;
          closestAsteroid = a;
        }
      }
      velocityMult = 1;
      endPos = closestAsteroid.position;
    }
    
    PVector velocity = PVector.sub(endPos, startPos).setMag(100);
    velocity.mult(velocityMult);
    
    new Bullet(startPos, velocity, initialVelocity, bulletSize, bulletBounces, damage, drawColor);
    playSound(WEAPONFIRE);
    lastFired = millis();
  }
}
