class ObjectHandler {
  ArrayList<Bullet> bullets;
  ArrayList<Asteroid> asteroids;
  ArrayList<DamageEffect> damageEffects;
  ArrayList<Powerup> powerups;
  
  ObjectHandler() {
    createArrays();
  }
  
  void createArrays() {
    bullets = new ArrayList<Bullet>();
    asteroids = new ArrayList<Asteroid>();
    damageEffects = new ArrayList<DamageEffect>();
    powerups = new ArrayList<Powerup>();
  }
  
  void run() {
    // RUN ASTEROIDS
    for (int i = asteroids.size() - 1; i >= 0; i--) {
      Asteroid a = asteroids.get(i);
      a.run();
    }
     
    // RUN DAMAGE EFFECTS
    for (int i = damageEffects.size() - 1; i >= 0; i--) {
      DamageEffect de = damageEffects.get(i);        
       if (de.completed == true) {
         damageEffects.remove(de);
         continue;
       }        
      de.run();
    }
    
    // RUN BULLETS
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);    
      if (b.destroyed == true) {
        bullets.remove(b);
        continue;
      }
      b.run();
    }
    
    // RUN POWERUPS
    for (int i = powerups.size() - 1; i >= 0; i--) {
      Powerup p = powerups.get(i);    
      if (p.expired == true) {
        powerups.remove(p);
        continue;
      }
      p.run();
    }
  }
}
