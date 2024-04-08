class BouncyBall {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int speed = 1;
  int diameter;
 
  
  BouncyBall(PVector _position, PVector _velocity, int _diameter) {
    position = _position;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    diameter = _diameter;
  }
  
  void run() {
     checkCollisions();
     move();
     drawBall();
  }
  
  void drawBall() {
    fill(0, 255, 0);
    circle(position.x, position.y, diameter);  
  }
  
  void move() {
    acceleration.set(moveDirection.mult(speed));
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0.95);
  }
  
  void checkCollisions() {
    //if(position.x + diameter / 2 > width || position.x - diameter / 2 < 0) {
    //  velocity.x *= -1;
    //}
    
    //if(position.y + diameter / 2 > width || position.y - diameter / 2 < 0) {
    //  velocity.y *= -1;  
    //}
    
    
  }
  

  
  //void keyReleased() {
  //    switch(key) {
  //    case('w'):
  //      mUp = 0;
  //      break;
  //    case('a'):
  //      mLeft = 0;
  //      break;
  //    case('s'):
  //      mDown = 0;
  //      break;
  //    case('d'):
  //      mRight = 0;
  //      break;
  //  }
  //}
}
