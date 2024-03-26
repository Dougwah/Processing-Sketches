class Weapon {
  private int damage;
  private int fireRate;
  private PVector bulletSize;
  private float bulletSpeed;
  
  private int lastFired;
  
  private ArrayList<Projectile> Bullets = new ArrayList<Projectile>(); 
  
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

    pushMatrix();
      fill(0, 255, 0);
      PShape shape = createShape(RECT, 0, 0, bulletSize.x, bulletSize.y);
    popMatrix();

    startPos.x -= (bulletSize.x / 2);
    endPos.x -= (bulletSize.x / 2);

    PVector velocity = new PVector();
    PVector.sub(endPos, startPos, velocity);
    
    velocity.mult(bulletSpeed).add(initialVelocity);
    
    new Projectile(shape, startPos, velocity, 2);
    lastFired = millis();

  }
}
