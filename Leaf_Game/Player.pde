class Player {
  float[] leavesOwned = new float[leafNames.length];
  boolean[] leavesUnlocked = new boolean[leafNames.length];
  int[] upgradeLevels = new int[upgradeNames.length];
  int selectedTool;
  
  Player() {
    selectedTool = 0;
  }
  
  void drawPlayer() {
    fill(255);
    circle(mouseX, mouseY, playerSize);  
  }
  
  void run() {
    drawPlayer();
  }
  
  void setTool(int type) {
    selectedTool = type;  
  }
  
  int getTool() {
    return selectedTool;  
  }
  
  void setLeaves(int type, float amount) {
    leavesOwned[type] = amount;
  }
  
  float getLeaves(int type) {
    return leavesOwned[type];
  }
  
  void updateLeaves(int type, float amount) {
    println(amount);
    setLeaves(type, getLeaves(type) + amount);
  }
  
  void buyUpgrade(int type) {
    float cost = upgradeBaseCost[type] + getUpgradeLevel(type) * upgradeCostExponent[type];
    int leafCostType = upgradeCostType[type];
    if(getLeaves(leafCostType) >= cost) {
      upgradeLevels[type]++;
      updateLeaves(leafCostType, -cost);
    }
  }
  
  int getUpgradeLevel(int type) {
    return upgradeLevels[type];
  }
}
