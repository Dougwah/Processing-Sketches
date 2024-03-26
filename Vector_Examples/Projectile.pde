class Projectile {
  private PVector velocity = new PVector();
  private PVector position;
  private PVector size;
  private float lifeSpan = 1;
  private float spawnTime;
  private boolean destroyed = false;

  Projectile(PVector startPos, PVector vel, PVector pSize) {
    position = startPos.copy();
    velocity = vel.copy();
    spawnTime = millis();
    size = pSize;
    
    Projectiles.add(this);
  }
  
  void Move() {
    position.add(velocity);
    
    if (position.x > width || position.x < 0) {
      velocity.x *= -1;
    }
    
    if (position.y > height || position.y < 0) {
      velocity.y *= -1;
    }
  }
  
  void Draw() {
    if (millis() - spawnTime > lifeSpan * 1000) {
      destroyed = true;
    }
    pushMatrix();
      fill(0,255,0);
      rect(position.x, position.y, size.x, size.y);
    popMatrix();
  }
}
