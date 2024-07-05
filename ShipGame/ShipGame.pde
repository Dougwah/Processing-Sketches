void setup() {
    ArmourModule module = new ArmourModule(ArmourModuleType.PLASTEEL, 1);
    System.out.println(module);
    
    System.out.println(ArmourModuleType.PLASTEEL.getWeight());
    
    Ship ship = new Ship(ShipType.RANCOR, 1);
    System.out.println(ship);
    ship.equipModule(module);
    System.out.println(ship);
    ship.unequipModule(module);
    System.out.println(ship);
    
}
