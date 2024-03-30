int damageParticleCount = 5;

class Asteroid {
  private PVector position, velocity;
  
  private float maxHealth;
  private float health;
  private float damage;
  private float radius;
  private float level;
  
  private boolean spawned = false;
  private int timeDestroyed = -10000;
  private int lastCollided = 0;
  private color drawColor = color(100, 100, 100);
  
  Asteroid () {
    objHandler.asteroids.add(this); 
  }
  
  void run() {
    spawn();
    if (spawned) {
      checkCollision();
      move();
      drawShape();
    }
  }
  
  void takeDamage(float damage, boolean playerDamage) {
    health -= damage;
    drawColor = color(0, 255, 0);
    if (health <= 0) {
       destroy(playerDamage);
    }
  }
  
  void rebound(PVector fromPosition) {
    PVector direction = PVector.sub(position, fromPosition).normalize();
    velocity.set(direction.mult(velocity.mag()));
  }
  
  void destroy(boolean awardScore) {
    timeDestroyed = millis();

    new DamageEffect(position, 10, radius / 2, color(100, 100, 100));
    if (awardScore) {
      round.addScore(asteroidBaseScore * level);
    }
    playSound(ASTEROIDDEATH);
    spawned = false;
    velocity = new PVector(0,0);
    position = new PVector(width * 2, height * 2);
    spawn();
  }
  
  void spawn() {
    if (spawned) { return; }
    if (millis() < timeDestroyed + (1000 * (asteroidSpawnInterval + random(-asteroidSpawnIntervalVariance, asteroidSpawnIntervalVariance)))) { return; }
    
    drawColor = color(100, 100, 100);
    level = random(asteroidMinLevel * round.difficultyScale, asteroidMaxLevel * round.difficultyScale);
    maxHealth = level * asteroidBaseHealth;
    health = maxHealth;
    damage = 1; //damage = level * asteroidBaseDamage;
    radius = nX(min(asteroidBaseRadius * random(1, 2) + round.difficultyScale, asteroidMaxRadius));
 
    if (round(random(1)) == 1) {
      position = new PVector(random(0, width), height * round(random(1)));
    } else {
      position = new PVector(width * round(random(1)), random(height));
    }

    velocity = nVector(PVector.sub(round.ply.getPosition(), position).normalize().setMag(random(asteroidMinSpeed, min(asteroidMaxSpeed + (round.difficultyScale / 4), 15))));
    spawned = true;
  }
  
  void checkCollision() {
    int collisionTime = millis();
    
    //if (position.x > width || position.x < 0) {
    //  velocity.x *= -1;
    //}
    
    //if (position.y > height || position.y < 0) {
    //  velocity.y *= -1;
    //}
    
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
    
    float distance = PVector.sub(round.ply.getPosition(), position).mag();
    float minDistance = (round.ply.getSize().y / 2) + radius;
    
    if ((distance < minDistance) && collisionTime > lastCollided + 200){
      round.ply.takeDamage(damage);
      takeDamage(damage, false);
      rebound(round.ply.getPosition());
      lastCollided = collisionTime;
    }
    
    //for (Asteroid a : objHandler.asteroids) {
    //  if (a.position == null || a.position == position) { continue; }
    //  distance = PVector.sub(a.position, position).mag();
    //  minDistance = a.radius + radius;
      
    //  if (distance < minDistance) {
    //    rebound(a.position); 
    //  }
    //}
    
  }
  
  void move() {
    position.add(velocity);
  }
  
  void drawShape(){
    pushMatrix();
      fill(drawColor);
      circle(position.x, position.y, radius * 2);
      fill(255, 255, 255);
      textFont(willowFont);
      textSize(20);
      textAlign(CENTER, CENTER);
      text(ceil(health), position.x, position.y);
    popMatrix();
    
    drawColor = lerpColor(drawColor, color(100, 100, 100), 0.2);
  }
}
