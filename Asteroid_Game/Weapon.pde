class Weapon {
  private int damage;
  private float fireRate;
  private PVector bulletSize;
  private float bulletSpeed;
  
  private int lastFired;
  
  Weapon(int _damage, float _fireRate, PVector _bulletSize, float _bulletSpeed) {
    damage = _damage;
    fireRate = _fireRate;
    bulletSize = _bulletSize;
    bulletSpeed = _bulletSpeed;
    
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
   
  void fire(PVector startPos, PVector endPos, PVector initialVelocity) {
    if (millis() < lastFired + (1000 / fireRate)) {
      return;
    }

    playSound(1);

    PVector velocity = PVector.sub(endPos, startPos);
    
    velocity.mult(bulletSpeed);//.add(initialVelocity);
    
    new Bullet(startPos, velocity, initialVelocity, bulletSize, 2, damage);
    lastFired = millis();
  }
}
