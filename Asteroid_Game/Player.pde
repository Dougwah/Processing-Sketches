class Player {
   PVector position, centerPos, velocity = new PVector(), acceleration = new PVector();
  private float rotation = 0;
  
  private float maxVelocity;
  private float accelerationRate;
  private float deccelerationRate;
  private float rotationRate;
  private PVector size = nVector(new PVector(20, 44));
  
  private float maxHealth;
  private float health;
  private color drawColor = color(255, 255, 255);
  private boolean destroyed = false;
  private float invincibleEndTime;
  
  private Weapon weapon;

  Player(PVector _position, float _maxVelocity, float _accelerationRate, float _deccelerationRate, float _rotationRate, int _maxHealth) {
    position = _position.copy();
    maxVelocity = _maxVelocity;
    accelerationRate = _accelerationRate;
    deccelerationRate = _deccelerationRate;
    rotationRate = _rotationRate;
    maxHealth = _maxHealth;
    health = maxHealth;
  }
  
  void addShipSpeed(float shipSpeed) {
    accelerationRate += shipSpeed;
    maxVelocity += shipSpeed * 10;
    rotationRate += shipSpeed * 0.1;
  }
  
  void takeDamage(float damage) {
    if (getInvincible()) {
      playSound(SHIPBLOCKDAMAGE);
      return; 
    }
    health -= damage;
    playSound(SHIPDAMAGE);
    drawColor = color(200, 0 ,0);
    if (health <= 0) {
      kill();
    }
  }
  
  void heal(float _health) {
    if (health == maxHealth) {
      playSound(SHIPHEALTHFULL);
      return;
    }
    health = min(maxHealth, health + _health);
    drawColor = (color(0, 200, 0));
    playSound(SHIPHEAL);
  }
  
   void enableNoDamage(float duration) {
     invincibleEndTime = millis() + duration * 1000;
   }
  
  void kill() {
    playSound(SHIPDEATH);
    destroyed = true; 
  }
  
  void setWeapon(Weapon _weapon) {
    weapon = _weapon;
  }
  
  boolean getDestroyed() {
   return destroyed; 
  }
  
  boolean getInvincible() {
    return invincibleEndTime > millis();
  }
  
  PVector getPosition() {
    return centerPos; 
  }
  
  PVector getVelocity () {
    return velocity; 
  }
  
  PVector getSize() {
    return size;
  }
  
  float getRotation() {
   return rotation; 
  }
  
  float getHealth() {
    return health; 
  }
  
  float getMaxHealth() {
    return maxHealth; 
  }

  void run() {
    control();
    move();
    drawPlayer();
  }
  
  void control() {
   acceleration.mult(0); // reset the active control directions when keys are released 
   
   if (keys[87]) { // W
      acceleration.y = -accelerationRate;
    }

    if (keys[65]) { // A
      acceleration.x = -accelerationRate;
    }

    if (keys[83]) { // S
      acceleration.y = accelerationRate;
    }

    if (keys[68]) { // D
      acceleration.x = accelerationRate;
    }
    
    if (keys[32]) { // SPACE
      PVector endPos = position.copy();
      float offset = size.y / 2;
      endPos.y += offset;
      endPos.x += (100) * cos(rotation - radians(90));
      endPos.y += (100) * sin(rotation - radians(90));
      
      weapon.fire(centerPos.copy(), endPos, velocity.copy());
    }
    
  }
  
  void move() {
    velocity.add(acceleration);
    velocity.limit(maxVelocity);
    
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
    
    if (keys[37] || keys[78]) { // LEFT || N
      rotation -= rotationRate;
    }

    if (keys[39] || keys[77]) { // RIGHT || M
      rotation += rotationRate;
    }
    
    position.add(nVector(velocity));
    velocity.mult(1 - deccelerationRate);
    
    centerPos = position.copy();
    centerPos.y += size.y / 2;
  }
  
  void drawPlayer() {
    pushMatrix();
      drawPlayerShape(position, size, drawColor, rotation);
    popMatrix();
    drawColor = lerpColor(drawColor, color(255, 255, 255), 0.1);
  }
  
}

void drawPlayerShape(PVector position, PVector size, color drawColor, float rotation) {
  translate(position.x, position.y + (size.y / 2));
  rectMode(CENTER);
  fill(0, 255, 0);
  //rect(0, size.y * 0.8, size.x * (health / maxHealth) * 2, 5);
  rotate(rotation);
  translate(0, -size.y / 2);
  fill(drawColor);
  beginShape();
    vertex(0, 0);
    vertex(size.x, size.y);
    vertex(0, size.y * 0.85);
    vertex(-size.x, size.y);
  endShape(CLOSE);
}
