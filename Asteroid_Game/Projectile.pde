ArrayList<Projectile> Projectiles = new ArrayList<Projectile>();

class Projectile {
  private PVector velocity = new PVector();
  private PVector position;
  private PShape shape;
  private int lifeSpan;
  private int spawnTime;
  private boolean destroyed = false;

 
  Projectile(PShape _shape, PVector _position, PVector _velocity, int _lifeSpan) {
    position = _position;
    velocity = _velocity;
    shape = _shape;
    lifeSpan = _lifeSpan;
    spawnTime = millis();
    
    Projectiles.add(this);
  }
  
  void run() {
    if (millis() - spawnTime > lifeSpan * 1000) {
      destroyed = true;
    }
    
    move();
    drawProjectile();
  }
  
  void move() {
    position.add(velocity);
    if (position.x > width || position.x < 0) {
      velocity.x *= -1;
    }
    
    if (position.y > height || position.y < 0) {
      velocity.y *= -1;
    }
  }
  
  void drawProjectile() {
    shape(shape, position.x, position.y);
  }
}
