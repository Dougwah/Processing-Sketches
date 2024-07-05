class Ship {
  private ShipType type;
  private int tier;
  private int damage;
  private ArrayList<ArmourModule> armourModules = new ArrayList<ArmourModule>();
  
  Ship(ShipType type, int tier) {
    this.type = type;
    this.tier = tier;
  }
  
  public String getShipName() {
    return type.getShipName();
  }
  
  public String getShipClass() {
    return type.getShipClass();
  }
  
  public int getMaxWeight() {
    return type.getMaxWeight(tier);
  }
  
  public int getMaxHealth() {
    int moduleStats = 0;
    for(int i = 0; i < armourModules.size(); i++) {
      moduleStats += armourModules.get(i).getHealthBonus();
    }
    return type.getHealth(tier) + moduleStats;
  }
  
  public void equipModule(ArmourModule module) {
    armourModules.add(module);
  }
  
  public void unequipModule(ShipModule module) {
    if(module instanceof ArmourModule) {
      armourModules.remove(module);
    }
  }
  
  public void addDamage(int damage) {
    this.damage += damage;
    if(this.damage > getMaxHealth()) {
       
    }
    
  }
  
  public void 
  
  public void repair() {
    damage = 0;
  }
  
  public String toString() {
    return "Module: [ Name: " + getShipName() + " | Class: " + getShipClass()  + " | Tier: " + tier + " | Weight: " + getMaxWeight() + " | Max Health: " + getMaxHealth();
  }
  
  public String modulesToString() {
    return "";
  }
  
}
