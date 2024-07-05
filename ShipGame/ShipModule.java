abstract class ShipModule {
  public static ShipModule[] modules = new ShipModule[100];
  private static int moduleCount = 0;
  
  protected int tier;
  
  private int index;
  
  ShipModule(int tier) {
    this.tier = tier;
    modules[moduleCount] = this;
    index = moduleCount;
    moduleCount++;
  }
  
  abstract String getName();
  
  abstract String getTypeName();
  
  abstract int getWeight();
  
  public String toString() {
    return "Module: [ Name: " + getName() + " | Category: " + getTypeName()  + " | Tier: " + tier + " | Weight: " + getWeight() + " | Index: " + index + " ]";
  }
  
}

class ArmourModule extends ShipModule {
  
  private ArmourModuleType type;
  
  ArmourModule(ArmourModuleType type, int tier) {
    super(tier);
    this.type = type;
  }
  
  public String getName() {
    return type.getArmourName();
  }
  
  public String getTypeName() {
    return "Armour";
  }
  
  public int getHealthBonus() {
    return type.getHealth(tier);
  }
  
  public int getWeight() {
    return type.getWeight();
  }
  
}
