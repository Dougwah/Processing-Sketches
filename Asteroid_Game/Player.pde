class Player {
  private PVector Pos;
  private PVector TargetPos;
  private PVector Velocity;
  private float Ang = 0;
  private int[] MoveDirs = {0, 0};

  private float MaxVel = 5;
  private float Acceleration = 0.01;
  private float RotationVel = 0.02;

  private Weapon Wep;

  Player(float xPos, float yPos) {
    Pos = new PVector(xPos, yPos);
    TargetPos = new PVector(xPos, yPos);
    Velocity = new PVector(0, 0);
  }

  void SetWeapon(Weapon weapon) {
    Wep = weapon;
  }

  void Run() {
    Draw();
    Move();
  }

  void Move() {
    MoveDirs[0] = 0;
    MoveDirs[1] = 0;

    if (keys[87]) { // W
      MoveDirs[1] -= 1;
    }

    if (keys[65]) { // A
      MoveDirs[0] -= 1;
    }

    if (keys[83]) { // S
      MoveDirs[1] += 1;
    }

    if (keys[68]) { // D
      MoveDirs[0] += 1;
    }

    if (keys[37]) { // LEFT
      Ang -= NormalizeFrames(RotationVel);
    }

    if (keys[39]) { // RIGHT
      Ang += NormalizeFrames(RotationVel);
    }

    if (keys[CONTROL]) { // RIGHT
      Ang += 0.010;
    }

    if (keys[32]) { // SPACE

      PVector startPos = Pos.copy();
      PVector endPos = Pos.copy();
      startPos.y += 40;
      endPos.y += 40;

      endPos.x += 40 * cos(Ang - 1.571);
      endPos.y += 40 * sin(Ang - 1.571);

      Wep.FireWeapon(startPos, endPos, Velocity);
    }

    TargetPos.x += MoveDirs[0] * NormalizeFrames(MaxVel);
    TargetPos.y += MoveDirs[1] * NormalizeFrames(MaxVel);
   
    Pos.lerp(TargetPos, NormalizeFrames(Acceleration));
    
    PVector.sub(TargetPos, Pos, Velocity);
  }

  void Draw() {
    if (Pos.x > width) {
      Pos.x -= width;
      TargetPos.x -= width;
    }

    if (Pos.x < 0) {
      Pos.x += width;
      TargetPos.x += width;
    }

    if (Pos.y > height) {
      Pos.y -= height;
      TargetPos.y -= height;
    }

    if (Pos.y < 0) {
      Pos.y += height;
      TargetPos.y += height;
    }

    pushMatrix();
    translate(Pos.x, Pos.y + 45);
    rotate(Ang);
    translate(0, -45);
    beginShape();
    fill(255, 255, 255);
    vertex(0, 0);
    vertex(30, 70);
    vertex(0, 60);
    vertex(-30, 70);
    endShape(CLOSE);
    popMatrix();
  }
}
