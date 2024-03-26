boolean[] keys = new boolean[256];
float plyBaseHealth = 50;

void keyPressed() {
  keys[keyCode] = true;
};

void keyReleased() {
  keys[keyCode] = false;
};

class Player {
  private PVector position, centerPos, velocity = new PVector(), acceleration = new PVector();
  private float rotation = 0;
  
  private float maxVelocity = 5;
  private float accelerationRate = 0.03;
  private float deccelerationRate = 0.01;
  private float rotationRate = 0.02;
  
  private float maxHealth = plyBaseHealth;
  private float health = maxHealth;

  private Weapon weapon;

  Player(PVector _position) {
    position = _position.copy();
    centerPos = _position.copy();
    centerPos.y += 40;
  }
  
  void takeDamage(float damage) {
    health -= damage;
    println(health);
    if (health <= 0) {
       endGame();
    }
  }

  void setWeapon(Weapon _weapon) {
    weapon = _weapon;
  }
  
  PVector getPosition() {
    return centerPos; 
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
      
      endPos.y += 40;
      endPos.x += 40 * cos(rotation - 1.571);
      endPos.y += 40 * sin(rotation - 1.571);

      weapon.fire(centerPos, endPos, velocity.copy());
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
    centerPos.y += 40;
  }
  
  void drawPlayer() {

    pushMatrix();
      fill(255, 255, 255);
      translate(position.x, position.y + 45);
      rotate(rotation);
      translate(0, -45);
      beginShape();
        vertex(0, 0);
        vertex(30, 70);
        vertex(0, 60);
        vertex(-30, 70);
    endShape(CLOSE);
    popMatrix();
  }
  
}
