public enum ArmourModuleType {
  PLASTEEL (new int[] {50, 75, 80, 95, 100}, 20, "Plasteel");
  
  private final int[] healths;
  private final int weight;
  private final String armourName;

  private ArmourModuleType(int[] healths, int weight, String armourName) {
    this.healths = healths;
    this.weight = weight;
    this.armourName = armourName;
  }

  public int[] getHealths() {
    return healths;
  }
  
  public int getHealth(int tier) {
    return healths[tier];
  }

  public int getWeight() {
    return weight;
  }

  public String getArmourName() {
    return armourName;
  }

}
