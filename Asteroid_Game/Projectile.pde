//class Projectile {
//  private PVector Velocity = new PVector();
  
//  private PVector Pos;
//  private PVector StartPos;
//  private PVector EndPos;
  
//  private PShape Shape;

 
//  Projectile(PShape shape, float vecMulti, PVector startPos, PVector endPos, PVector initialVelocity) {
//    Pos = startPos.copy();
//    PVector.sub(endPos, startPos, Velocity);
    
//    //Velocity.setMag(vecMulti);
//    Velocity.add(initialVelocity);
//    //Velocity = endPos.copy().sub(startPos).normalize().setMag(speed);
//    Shape = shape;
    
//    StartPos = startPos;
//    EndPos = endPos;
//  }
  
//  void Draw() {
//    Pos.add(Velocity);
//    shape(Shape, Pos.x, Pos.y);
//  }
//}

class Projectile {
  private PVector Velocity = new PVector();
  private PVector Pos;
  private PShape Shape;

 
  Projectile(PShape shape, PVector startPos, PVector velocity) {
    Pos = startPos.copy();
    Velocity = velocity.copy();
    Shape = shape;
  }
  
  void Draw() {
    Pos.add(Velocity);
    shape(Shape, Pos.x, Pos.y);
  }
}
