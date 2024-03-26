boolean[] keys = new boolean[256];

void keyPressed() {
  keys[keyCode] = true;
};

void keyReleased() {
  keys[keyCode] = false;
};

class SlideyMover {
  PVector velocity, acceleration, position, size, control = new PVector(0, 0);
  float accelerationRate = 0.04;
  float deccelerationRate = 0.01;
  float maxVelocity = 5;
  float shootDelta = millis();
  float bulletSpeed = 0.5;
  float fireRate = 2;
  
  SlideyMover(PVector pos) {
    position = pos;
    velocity = new PVector();
    acceleration = new PVector();
    size = new PVector(20, 20);
    
    SlideyMovers.add(this);
  }
  
  void Control() {
    control.mult(0);

    if (keys[87]) { // W
      control.y = -accelerationRate;
    }

    if (keys[65]) { // A
      control.x = -accelerationRate;
    }

    if (keys[83]) { // S
      control.y = accelerationRate;
    }

    if (keys[68]) { // D
      control.x = accelerationRate;
    }
    
    if (keys[32]) { // SPACE
      
      Shoot(new PVector(0, -4));
    
    }
    SetAcceleration(control);
  }
  
  void SetAcceleration(PVector acc) {
    acceleration.set(acc);
  }
  
  void Move() {
    
    velocity.add(acceleration);
    velocity.limit(maxVelocity);

    if (position.x > width || position.x < 0) {
      velocity.x *= -1;
    }
    
    if (position.y > height || position.y < 0) {
      velocity.y *= -1;
    }
    
    position.add(velocity);
    velocity.mult(1 - deccelerationRate);
  }
  
  void Shoot(PVector shotVelocity) {
    if (millis() < (shootDelta + 1000 / fireRate)) { 
      return;
    }
    
    PVector initialVelocity = velocity.copy();

    shotVelocity.mult(bulletSpeed).add(initialVelocity);
    
    new Projectile(position, shotVelocity, new PVector(10, 15));
    shootDelta = millis();
  }
  
  void Draw() {
    pushMatrix();
      rectMode(CENTER);
      fill(0, 0, 255);
      rect(position.x, position.y, size.x, size.y);
    popMatrix();
  }
}
