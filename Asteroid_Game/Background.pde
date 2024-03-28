int starCount = 400;
color[] starColors = {
  color(255, 255, 255),
  color(217, 243, 255),
  color(190, 229, 247),
  color(250, 222, 65),
  color(250, 167, 65),
  color(252, 123, 58),
  color(252, 81, 58),
  //color(134, 77, 247)
};

class Background {
  private ArrayList<PVector> gPositions = new ArrayList<PVector>();
  private color[] gColors = new color[starCount];
  private float[] gSizes = new float[starCount];

  Background() {
    for (int i = 0; i < starCount - 1; i++) {
      PVector gPosition = new PVector(random(0, width), random(0, height));
      gPositions.add(gPosition);
      gColors[i] = starColors[floor(random(starColors.length))];
      gSizes[i] = random(1, 4);
    }
  }
  
  void run() {
    for (int i = 0; i < gPositions.size() - 1; i++)  {
      pushMatrix();
        fill(gColors[i]);
        circle(gPositions.get(i).x, gPositions.get(i).y, gSizes[i]);
      popMatrix();
    }
  }

}
