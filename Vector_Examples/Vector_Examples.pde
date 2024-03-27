ArrayList<Mover> Movers = new ArrayList<Mover>();
ArrayList<SlideyMover> SlideyMovers = new ArrayList<SlideyMover>();
ArrayList<Projectile> Projectiles = new ArrayList<Projectile>();

Mover mover1;
Mover mover2;

void setup() {
  size(1920, 1080);
  frameRate(238);
  //new Mover(new PVector(2, 0), new PVector(1, 0), new PVector(width / 2, height / 2));
  //mover1 = new Mover(new PVector(2, 1), new PVector(0, 0), new PVector(width / 2,height / 1.2));
  //mover2 = new Mover(new PVector(1, 2), new PVector(0, 0), new PVector(width / 2,height / 1.2));
  
  for (int i = 0; i <= 10000; i++) {
    new Mover(new PVector(random(-3, 3), random(-3, 3)), new PVector(), new PVector(width / 2,height / 2));
  }
  
  new SlideyMover(new PVector(width / 2,height / 2));
  
}

void draw() {
  background(0);
  for (Mover m : Movers) {
    m.Move();
    m.Draw();
    m.Shoot(new PVector(random(-3, 3), random(-3, 3)));
  }
  

  for (int i = Projectiles.size() - 1; i >= 0; i--) {
    Projectile p = Projectiles.get(i);
    
    if (p.destroyed == true) {
      Projectiles.remove(p);
      continue;
    }
    
    p.Move();
    p.Draw();
   
  }
  
  for (SlideyMover s : SlideyMovers) {
    s.Control();
    s.Move();
    s.Draw();
  }
  
 // mover1.Shoot(new PVector(0, -3));
  //mover2.Shoot(new PVector(-1, -2));
}
