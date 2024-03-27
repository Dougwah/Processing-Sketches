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
  
  Asteroid() {}
  
  void takeDamage(float damage) {
    health -= damage;
    if (health <= 0) {
       destroy();
    }
  }
  
  void rebound(PVector fromPosition) {
    PVector direction = PVector.sub(position, fromPosition).normalize();
    velocity.set(direction.mult(velocity.mag()));
  }
  
  void destroy() {
    timeDestroyed = millis();
    round.addScore(asteroidBaseScore * level);
    playSound(4);
    spawned = false;
    velocity = new PVector(0,0);
    position = new PVector(width * 2, height * 2);
    spawn();
  }
  
  void spawn() {
    if (spawned) { return; }
    if (millis() < timeDestroyed + (1000 * (asteroidSpawnInterval + random(-asteroidSpawnIntervalVariance, asteroidSpawnIntervalVariance)))) { return; }

    level = random(asteroidMinLevel * round.difficultyScale, asteroidMaxLevel * round.difficultyScale);
    maxHealth = level * asteroidBaseHealth;
    health = maxHealth;
    damage = level * asteroidBaseDamage;
    radius = (asteroidBaseRadius + (min((level / 5) * asteroidBaseRadius, 50) ) * random(0.7, 2));
    println(radius);
    
    if (round(random(0, 1)) == 1) {
      position = new PVector(random(0, width), height * round(random(0, 1)));
    } else {
      position = new PVector(width * round(random(0, 1)), random(0, height));
    }

    velocity = PVector.sub(round.ply.getPosition(), position).setMag(random(asteroidMinSpeed, asteroidMaxSpeed));
    spawned = true;
  }
  
  void run() {
    spawn();
    checkCollision();
    move();
    drawShape();
  }
  
  void checkCollision() {
    int collisionTime = millis();
    if (position.x > width || position.x < 0) {
      velocity.x *= -1;
    }
    
    if (position.y > height || position.y < 0) {
      velocity.y *= -1;
    }
    
    float distance = PVector.sub(round.ply.getPosition(), position).mag();
    float minDistance = 20 + radius;
      
    if ((distance < minDistance) && collisionTime > lastCollided + 200){
      round.ply.takeDamage(damage);
      takeDamage(damage);
      rebound(round.ply.getPosition());
      lastCollided = collisionTime;
      //destroy();
    }
    
  }
  
  void move() {
    position.add(velocity);
  }
  
  void drawShape(){
    pushMatrix();
      fill(100, 100, 100);
      circle(position.x, position.y, radius * 2);
      fill(255, 255, 255);
      textFont(willowFont);
      textSize(20);
      textAlign(CENTER, CENTER);
      text(ceil(health), position.x, position.y);
    popMatrix();
  }
}
