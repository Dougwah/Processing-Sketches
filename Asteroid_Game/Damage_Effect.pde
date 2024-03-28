class DamageEffect {
  private ArrayList<PVector> positions = new ArrayList<PVector>();
  private ArrayList<PVector> velocities = new ArrayList<PVector>();
  private PVector startPosition;
  private int particleCount;
  private float particleRadius;
  private color particleColor;
  private float sizeLerpRate= 0.95;
  private boolean completed = false;

  DamageEffect(PVector _startPosition, int _particleCount, float _particleRadius, color _particleColor) {
    particleCount = _particleCount;
    startPosition = _startPosition;
    particleRadius = _particleRadius;
    particleColor = _particleColor;
    
    for (int i = 0; i < particleCount; i++) {
      PVector position = _startPosition.copy();
      float angle = random(360);
      position.x += 10 * cos(angle);
      position.y += 10 * sin(angle);
      positions.add(position);
      velocities.add(PVector.sub(startPosition, position));
    }
    
    objHandler.damageEffects.add(this);
  }
  
  void run() {
    for (int i = 0; i < particleCount; i++) {
      PVector position = positions.get(i);
      position.add(velocities.get(i));
      pushMatrix();
        fill(particleColor);
        circle(position.x, position.y, particleRadius);
      popMatrix();
    } 
    particleRadius *= sizeLerpRate;
    if (particleRadius < 0.5) {
      completed = true;
    }
  }
}
