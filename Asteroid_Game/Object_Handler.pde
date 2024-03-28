class ObjectHandler {
  ArrayList<Bullet> bullets;
  ArrayList<Asteroid> asteroids;
  ArrayList<DamageEffect> damageEffects;
  
  //ArrayList<DamagePowerup> damagePowerups;
  //ArrayList<FireRatePowerup> fireRatePowerups;
  ArrayList<Powerup> powerups;
  
  ObjectHandler() {
    bullets = new ArrayList<Bullet>();
    asteroids = new ArrayList<Asteroid>();
    damageEffects = new ArrayList<DamageEffect>();
    //damagePowerups = new ArrayList<DamagePowerup>();
    //fireRatePowerups = new ArrayList<FireRatePowerup>();
    
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
      
      
  //}
    
    //// RUN POWERUPS
    //for (int i = damagePowerups.size() - 1; i >= 0; i--) {
    //  DamagePowerup dP = damagePowerups.get(i);    
    //  if (dP.expired == true) {
    //    damagePowerups.remove(dP);
    //    continue;
    //  }
    //  dP.run();
    //}
    
    //for (int i = fireRatePowerups.size() - 1; i >= 0; i--) {
    //  FireRatePowerup fRP = fireRatePowerups.get(i);    
    //  if (fRP.expired == true) {
    //    fireRatePowerups.remove(fRP);
    //    continue;
    //  }
    //  fRP.run();
    //}
  }
}
