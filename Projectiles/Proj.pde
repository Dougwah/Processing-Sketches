class Proj{
  PVector position;
  PVector velocity;
  PVector size;
  float rotation;
  
  Proj(PVector _position, PVector _velocity) {
    position = _position;
    velocity = _velocity;
    rotation = 0;
    size = new PVector(10, 30);
  }
  
  void run() {
     checkCollisions();
     move();
     drawProj();
  }
  
  void drawProj() {
    fill(0, 255, 0);
    rectMode(CENTER);
    pushMatrix();
      translate(position.x, position.y);
      rotate(rotation);
      rect(0, 0, size.x, size.y);
    popMatrix();
  }
  
  void move() {
    position.add(velocity);
    rotation = -atan2(velocity.x, velocity.y);
  }
  
  void checkCollisions() {
    if(position.x + size.x / 2 > width || position.x - size.x / 2 < 0) {
      velocity.x *= -1;
    }
    
    if(position.y + size.y / 2 > width || position.y - size.y / 2 < 0) {
      velocity.y *= -1;
    } 
  }
}
