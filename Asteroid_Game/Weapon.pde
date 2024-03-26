class Weapon {
  private int damage;
  private int fireRate;
  private PVector bulletSize;
  private float bulletSpeed;
  
  private int lastFired;
  
  Weapon(int _damage, int _fireRate, PVector _bulletSize, float _bulletSpeed) {
    damage = _damage;
    fireRate = _fireRate;
    bulletSize = _bulletSize;
    bulletSpeed = _bulletSpeed;
    
    lastFired = millis();
   }
  
  void fire(PVector startPos, PVector endPos, PVector initialVelocity) {
    if (millis() < lastFired + (1000 / fireRate)) {
      return;
    }
    
    startPos.x -= (bulletSize.x / 2);
    endPos.x -= (bulletSize.x / 2);

    PVector velocity = PVector.sub(endPos, startPos);
    
    velocity.mult(bulletSpeed).add(initialVelocity);
    
    new Bullet(startPos, velocity, bulletSize, 2, damage);
    lastFired = millis();
  }
}
