class Player {
   PVector position, centerPos, velocity = new PVector(), acceleration = new PVector();
  private float rotation = 0;
  
  private float maxVelocity;
  private float accelerationRate;
  private float deccelerationRate;
  private float rotationRate;
  private PVector size = new PVector(20, 44);
  
  private float maxHealth;
  private float health;
  private color drawColor = color(255, 255, 255);
  private boolean destroyed = false;

  private Weapon weapon;

  Player(PVector _position, float _maxVelocity, float _accelerationRate, float _deccelerationRate, float _rotationRate, int _maxHealth) {
    position = _position.copy();
    maxVelocity = _maxVelocity;
    accelerationRate = _accelerationRate;
    deccelerationRate = _deccelerationRate;
    rotationRate = _rotationRate;
    maxHealth = _maxHealth;
    health = maxHealth;
    
    centerPos = _position.copy();
    centerPos.y += 40;
  }
  
  void addShipSpeed(float shipSpeed) {
    accelerationRate += shipSpeed;
    maxVelocity += shipSpeed * 10;
    rotationRate += shipSpeed * 0.1;
  }
  
  void takeDamage(float damage) {
    health -= damage;
    playSound(3);
    drawColor = color(200, 0 ,0);

    if (health <= 0) {
      kill();
    }
  }
  
  boolean getDestroyed() {
   return destroyed; 
  }
  
  void kill() {
    playSound(2);
    destroyed = true; 
  }

  void setWeapon(Weapon _weapon) {
    weapon = _weapon;
  }
  
  PVector getPosition() {
    return centerPos; 
  }
  
  PVector getSize() {
    return size;
  }
  
  float getRotation() {
   return rotation; 
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
      endPos.x += (100) * cos(rotation - 1.571);
      endPos.y += (100) * sin(rotation - 1.571);
      
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
    
    if (keys[37]) { // LEFT
      rotation -= rotationRate;
    }

    if (keys[39]) { // RIGHT
      rotation += rotationRate;
    }
    
    position.add(velocity);
    velocity.mult(1 - deccelerationRate);
    
    centerPos = position.copy();
    centerPos.y += size.y / 2;
  }
  
  void drawPlayer() {

    pushMatrix();
      translate(position.x, position.y + (size.y / 2));
      rectMode(CENTER);
      fill(0, 255, 0);
      rect(0, size.y * 0.8, size.x * (health / maxHealth) * 2, 5);
      rotate(rotation);
      translate(0, -size.y / 2);
      fill(drawColor);
      beginShape();
        vertex(0, 0);
        vertex(size.x, size.y);
        vertex(0, size.y * 0.85);
        vertex(-size.x, size.y);
      endShape(CLOSE);
    popMatrix();
    drawColor = lerpColor(drawColor, color(255, 255, 255), 0.1);
    
  }
  
}
