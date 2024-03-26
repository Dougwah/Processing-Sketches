class Mover {
  PVector velocity, acceleration, position;
  float shootDelta = millis();
  float fireRate = 5;
  
  Mover(PVector vel, PVector acc, PVector pos) {
    velocity = vel;
    acceleration = acc;
    position = pos;
    
    Movers.add(this);
  }
  
  void Move() {
    velocity.add(acceleration);
    position.add(velocity);
    
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
  }
  
  void Shoot(PVector shotVelocity) {
    if (millis() < (shootDelta + 1000 / fireRate)) { 
      return;
    }

    shotVelocity.add(velocity);
    
    new Projectile(position, shotVelocity, new PVector(3, 3));
    shootDelta = millis();
  }
  
  void Draw() {
    pushMatrix();
      fill(255, 255, 255);
      rect(position.x, position.y, 10, 10);
    popMatrix();
  }
}
