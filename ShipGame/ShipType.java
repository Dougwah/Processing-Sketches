public enum ShipType {
  HARRIER("Harrier", "Frigate", new int[] {20, 40}, new int[] {150, 200}, 50, 1, 1, 0),
  GENESIS("Genesis", "Cruiser", new int[] {100, 120}, new int[] {200, 260}, 80, 2, 2, 0),
  LONGSWORD("Longsword", "Destroyer", new int[] {150, 180}, new int[] {180, 220}, 60, 3, 0, 1),
  RANCOR("Rancor", "Battleship", new int[] {250, 300}, new int[] {250, 300}, 100, 4, 1, 1);
  
  private final String shipName;
  private final String shipClass;
  private final int[] healths;
  private final int[] maxWeights;
  private final int weight;
  private final int weaponModuleSlots;
  private final int armourModuleSlots;
  private final int shieldModuleSlots;
  
  ShipType(String shipName, String shipClass, int[] healths, int[] maxWeights, int weight, int wepModSlots, int armModSlots, int shldModSlots) {
    this.shipName = shipName;
    this.shipClass = shipClass;
    this.healths = healths;
    this.maxWeights = maxWeights;
    this.weight = weight;
    this.weaponModuleSlots = wepModSlots;
    this.armourModuleSlots = armModSlots;
    this.shieldModuleSlots = shldModSlots;
  }

  public String getShipName() {
    return shipName;
  }

  public String getShipClass() {
    return shipClass;
  }

  public int[] getHealths() {
    return healths;
  }
  
  public int getHealth(int tier) {
    return healths[tier];
  }

  public int[] getMaxWeights() {
    return maxWeights;
  }
  
  public int getMaxWeight(int tier) {
    return maxWeights[tier];
  }

  public int getWeight() {
    return weight;
  }

  public int getWeaponModuleSlots() {
    return weaponModuleSlots;
  }

  public int getArmourModuleSlots() {
    return armourModuleSlots;
  }

  public int getShieldModuleSlots() {
    return shieldModuleSlots;
  }
  
}
