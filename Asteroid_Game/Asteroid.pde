ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

float asteroidBaseHealth = 5;
float asteroidBaseDamage = 1;
float asteroidBaseRadius = 15;
float asteroidMinSpeed = 4;
float asteroidMaxSpeed = 12;
float asteroidMaxLevel = 7;

int maxAsteroids = 15;
int spawnInterval = 2;
int spawnIntervalVariance = 1;


void initAsteroids() {
  for (int i = 0; i < maxAsteroids; i++) {
    new Asteroid();
  }
}

void runAsteroids() {
  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid a = asteroids.get(i);
    a.run();
  }
}

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
  
  Asteroid() {
    asteroids.add(this);
  }
  
  void takeDamage(float damage) {
    health -= damage;
    if (health <= 0) {
       destroy();
    }
  }
  
  void rebound(PVector fromPosition) {
    //PVector direction = PVector.sub(fromPositon, position);
    velocity.mult(-1);
    
  }
  
  void destroy() {
    timeDestroyed = millis();
    asteroidSounds.get(floor(random(0, 3))).play();
    spawned = false;
    velocity = new PVector(0,0);
    position = new PVector(width * 2, height * 2);
    spawn();
  }
  
  void spawn() {
    if (spawned) { return; }
    if (millis() < timeDestroyed + (1000 * (spawnInterval + random(-spawnIntervalVariance, spawnIntervalVariance)))) { return; }

    level = random(1, asteroidMaxLevel);
    maxHealth = level * asteroidBaseHealth;
    health = maxHealth;
    damage = level * asteroidBaseDamage;
    radius = level * asteroidBaseRadius;
    
    if (round(random(0, 1)) == 1) {
      position = new PVector(random(0, width), height * round(random(0, 1)));
    } else {
      position = new PVector(width * round(random(0, 1)), random(0, height));
    }

    velocity = PVector.sub(ply.getPosition(), position).setMag(random(asteroidMinSpeed, asteroidMaxSpeed));
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
    
    float distance = PVector.sub(ply.getPosition(), position).mag();
    float minDistance = 20 + radius;
      
    if ((distance < minDistance) && collisionTime > lastCollided + 100){
      ply.takeDamage(damage);
      takeDamage(damage);
      rebound(ply.getPosition());
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
      textSize(20);
      textAlign(CENTER, CENTER);
      text(ceil(health), position.x, position.y);
    popMatrix();
  }
}
