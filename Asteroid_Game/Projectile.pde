//ArrayList<Projectile> Projectiles = new ArrayList<Projectile>();

//class Projectile {
//  private PVector velocity = new PVector();
//  private PVector position;
//  private PShape shape;
//  private float hitboxRadius;
//  private float damage;
//  private int lifeSpan;
//  private int spawnTime;
//  private boolean isFriendly;
//  private boolean destroyed = false;

 
//  Projectile(PShape _shape, PVector _position, PVector _velocity, int _lifeSpan, float _damage, boolean _isFriendly) {
//    position = _position;
//    velocity = _velocity;
//    shape = _shape;
//    hitboxRadius = shape.width;
//    damage = _damage;
//    lifeSpan = _lifeSpan;
//    isFriendly = _isFriendly;
//    spawnTime = millis();
    
//    Projectiles.add(this);
//  }
  
//  void run() {
//    if (millis() - spawnTime > lifeSpan * 1000) {
//      destroyed = true;
//    }
//    checkCollision();
//    move();
//    drawProjectile();
//  }
  
//  void checkCollision() {
//    if (position.x > width || position.x < 0) {
//      velocity.x *= -1;
//    }
    
//    if (position.y > height || position.y < 0) {
//      velocity.y *= -1;
//    }
    
//    for (int i = Projectiles.size() - 1; i >= 0; i--) {
//      Projectile p = Projectiles.get(i);
      
//      if (p.destroyed == true) {
//        continue;
//      }
      
//      float distance = PVector.sub(p.position, position).mag();
//      print(hitboxRadius);
//      float minDistance = hitboxRadius + p.hitboxRadius;
//      println(minDistance);
//      if (distance < minDistance) {
//        p.destroyed = true;
//      }
//    }
    
    
//  }
  
//  void move() {
//    position.add(velocity);

//  }
  
//  void drawProjectile() {
//    shape(shape, position.x, position.y);
//  }
//}
