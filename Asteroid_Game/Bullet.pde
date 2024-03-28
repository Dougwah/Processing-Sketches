class Bullet {
  private PVector position, size, velocity = new PVector(), additionalVelocity;
  private float rotation;
  private float damage;
  private int lifeSpan;
  private int spawnTime;
  
  private boolean destroyed = false;

  Bullet(PVector _position, PVector _velocity, PVector _additionalVelocity, PVector _size, int _lifeSpan, float _damage) {
    position = _position;

    additionalVelocity = _additionalVelocity.copy();
    velocity = PVector.add(_velocity, additionalVelocity);
    
    size = _size.copy();
    damage = _damage;
    lifeSpan = _lifeSpan;

    spawnTime = millis();
    objHandler.bullets.add(this);
  }
  
  void run() {
    if (millis() - spawnTime > lifeSpan * 1000) {
      destroyed = true;
    }
    checkCollision();
    move();
    drawShape();
  }
  
  void checkCollision() {
    if (position.x > width || position.x < 0) {
      velocity.x *= -1;
    }
    
    if (position.y > height || position.y < 0) {
      velocity.y *= -1;
    }
    
    for (int i = objHandler.asteroids.size() - 1; i >= 0; i--) {
      Asteroid a = objHandler.asteroids.get(i);
      
      float distance = PVector.sub(a.position, position).mag();
      float minDistance = (size.x / 2) + (a.radius);
      
      if (distance < minDistance) {
        destroyed = true;
        a.takeDamage(damage, true);
      }
    }
  }
  
  void move() {
    position.add(velocity);
    
    PVector baseVelocity = PVector.sub(velocity, additionalVelocity);
    rotation = -atan2(baseVelocity.x, baseVelocity.y);
  }
  
  void drawShape() {
    pushMatrix();
      fill(0, 255, 0);
      rectMode(CENTER);
      translate(position.x, position.y);
      rotate(rotation);
      rect(0, 0, size.x, size. y);
    popMatrix();
    //size.mult(0.99);
  }
  
}
