ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void runBullets() {
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    
    if (b.destroyed == true) {
      bullets.remove(b);
      continue;
    }
    b.run();
  }
}

class Bullet {
  private PVector position, size, velocity = new PVector();
  private float damage;
  private int lifeSpan;
  private int spawnTime;
  
  private boolean destroyed = false;

  Bullet(PVector _position, PVector _velocity, PVector _size, int _lifeSpan, float _damage) {
    position = _position;
    velocity = _velocity;
    size = _size;
    damage = _damage;
    lifeSpan = _lifeSpan;

    spawnTime = millis();
    
    bullets.add(this);
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
    
    for (int i = asteroids.size() - 1; i >= 0; i--) {
      Asteroid a = asteroids.get(i);
      
      float distance = PVector.sub(a.position, position).mag();
      float minDistance = (size.x / 2) + (a.radius);
      
      if (distance < minDistance) {
        destroyed = true;
        a.takeDamage(damage);
      }
    }
  }
  
  void move() {
    position.add(velocity);
  }
  
  void drawShape() {
    pushMatrix();
      fill(0, 255, 0);
      rect(position.x, position.y, size.x, size. y);
    popMatrix();
  }
}
