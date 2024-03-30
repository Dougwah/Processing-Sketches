class Bullet {
  private PVector position, size, velocity = new PVector(), additionalVelocity;
  private float rotation;
  private float damage;
  private color drawColor;
  private int bounces;
  private int lifeSpan = 10;
  private int spawnTime;
  
  private boolean destroyed = false;

  Bullet(PVector _position, PVector _velocity, PVector _additionalVelocity, PVector _size, int _maxBounces, float _damage, color _color) {
    position = _position;

    additionalVelocity = _additionalVelocity.copy();
    velocity = PVector.add(nVector(_velocity), additionalVelocity);
    
    size = nVector(_size.copy());
    damage = _damage;
    drawColor = _color;
    bounces = _maxBounces;

    spawnTime = millis();
    objHandler.bullets.add(this);
  }
  
  void incrementBounces(int count) {
    bounces += count;
    if (bounces <= 0) {
      destroyed = true; 
    }
  }
  
  void rebound(PVector fromPosition) {
    PVector direction = PVector.sub(position, fromPosition).normalize();
    velocity.set(direction.mult(velocity.mag()));
  }
  
  void run() {
    if (millis() - spawnTime > lifeSpan * 1000) {
      destroyed = true;
    }
    
    move();
    checkCollision();
    drawShape();
  }
  
  void checkCollision() {
    if (position.x > width) {
      position.x -= width;
    }

    if (position.x < 0) {
      position.x += width;
    }

    if (position.y > height) {
      position.y -= height;
    }

    if (position.y < 0) {
      position.y += height;
    }
    
    for (int i = objHandler.asteroids.size() - 1; i >= 0; i--) {
      Asteroid a = objHandler.asteroids.get(i);
      
      float distance = PVector.sub(a.position, position).mag();
      float minDistance = (size.x / 2) + (a.radius);
      
      if (distance < minDistance) {
        a.takeDamage(damage, true);
        incrementBounces(-1);
        rebound(a.position);
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
      fill(drawColor);
      rectMode(CENTER);
      translate(position.x, position.y);
      rotate(rotation);
      rect(0, 0, size.x, size. y);
    popMatrix();
    //size.mult(0.99);
  }
  
}
