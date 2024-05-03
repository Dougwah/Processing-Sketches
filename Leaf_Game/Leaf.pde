class Leaf {
  PVector pos;
  PVector vel;
  float rot;
  int type;
  PVector size;
  float friction;
  color col;
  boolean active = false;
  
  Leaf() {    
    spawn();
  }
    
  void spawn() {
    pos = new PVector(random(width), random(height));
    vel = new PVector();
    rot = random(10);
    type = 0;
    
    for(int i = leafNames.length - 1; i >= 1; i--) {
      if((int)random(101) <= leafSpawnChances[i]) {
        type = i;  
        break;
      }
    }
    
    col = leafColors[type];
    size = leafSizes[type];
    friction = leafFriction[type];
    active = true;
  }
  
  void despawn() {
    ply.updateLeaves(type, 1);
    active = false;
    spawn();
  }
  
  void move() {
    pos.add(vel);
    vel.mult(1 - friction);
    rot += 0.01 * vel.mag();
  }
  
  void addVel(PVector _vel) {
    vel = _vel;
  }
  
  void drawLeaf() {
    noStroke();
    fill(col);
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(rot);
      rect(-size.x / 2, -size.y / 2, size.x, size.y); 
    popMatrix();
  }
  
  void checkInBounds() {
    if(pos.y + size.y * 0.5 < 0 || pos.y - size.y * 0.5 > height) {
      despawn();
      return;
    }
    if(pos.x + size.x * 0.5 < 0 || pos.x - size.x * 0.5 > width) {
      despawn();
      return;
    }
  }
  
  void run() {
    if(!active) {
      return;
    }
    move();
    checkInBounds();
    drawLeaf();  
  }
  
}
