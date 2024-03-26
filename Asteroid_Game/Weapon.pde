//class Weapon {
//  private int Damage;
//  private int FireRate;
//  private int BulletSizeMulti;
//  private float BulletSpeedMulti;
  
//  private int LastFired;
  
//  private ArrayList<Projectile> Bullets = new ArrayList<Projectile>(); 
  
//  Weapon(int damage, int fireRate, int bulletSize, float bulletSpeedMulti) {
//    Damage = damage;
//    FireRate = fireRate;
//    BulletSizeMulti = bulletSize;
//    BulletSpeedMulti = bulletSpeedMulti;
//    LastFired = millis();
//   }
  
//  void FireWeapon(PVector startPos, PVector endPos, PVector initialVelocity) {
//    if (millis() > LastFired + (1000 / FireRate)) {
//      int bulletSizeX = 10 * BulletSizeMulti;
//      int bulletSizeY = 10 * BulletSizeMulti;
//      pushMatrix();
//        fill(255, 0, 0);
//        PShape shape = createShape(RECT, 0, 0, bulletSizeX, bulletSizeY);
//      popMatrix();
//      startPos.x -= (bulletSizeX / 2);
//      endPos.x -= (bulletSizeX / 2);
//      PVector velocity = new PVector();
//      PVector.sub(endPos, startPos, velocity);
//      Bullets.add(new Projectile(shape, BulletSpeedMulti, startPos, endPos, initialVelocity));
//      LastFired = millis();

//    }
//  }
  
//  void DrawBullets() {
//    for (int i = 0; i < Bullets.size(); i++) {
//      Bullets.get(i).Draw();
//    }
//  }
//}

// calculate the velocity by subtracting the endPos from the startPos
// normalize then set its magnitude to the bullet speed variable
// add the initial velocity to the vector
// modify the projectile class to accept a vector instead of the bullet speed and initial velocity


class Weapon {
  private int Damage;
  private int FireRate;
  private int BulletSizeMulti;
  private float BulletSpeedMulti;
  
  private int LastFired;
  
  private ArrayList<Projectile> Bullets = new ArrayList<Projectile>(); 
  
  Weapon(int damage, int fireRate, int bulletSize, float bulletSpeedMulti) {
    Damage = damage;
    FireRate = fireRate;
    BulletSizeMulti = bulletSize;
    BulletSpeedMulti = bulletSpeedMulti;
    LastFired = millis();
   }
  
  void FireWeapon(PVector startPos, PVector endPos, PVector initialVelocity) {
    if (millis() > LastFired + (1000 / FireRate)) {
      int bulletSizeX = 10 * BulletSizeMulti;
      int bulletSizeY = 10 * BulletSizeMulti;
      
      pushMatrix();
        fill(255, 0, 0);
        PShape shape = createShape(RECT, 0, 0, bulletSizeX, bulletSizeY);
      popMatrix();
      println(initialVelocity);
      
      startPos.x -= (bulletSizeX / 2);
      endPos.x -= (bulletSizeX / 2);

      
      initialVelocity.copy();
      println(initialVelocity);
      initialVelocity.normalize();
      initialVelocity.setMag(BulletSpeedMulti);

      PVector velocity = new PVector();
      PVector.sub(endPos, startPos, velocity);
      
      velocity.add(initialVelocity);
      velocity.normalize().setMag(BulletSpeedMulti);


      println(velocity);
      Bullets.add(new Projectile(shape, startPos, velocity));
      LastFired = millis();

    }
  }
  
  void DrawBullets() {
    for (int i = 0; i < Bullets.size(); i++) {
      Bullets.get(i).Draw();
    }
  }
}
