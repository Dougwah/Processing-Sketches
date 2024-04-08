int attempts = 1000;
int trueResults = 0;
int falseResults = 0;

void setup() {
  for(int i = 0; i < attempts; i++) {
    int randomInt = (int)random(2);
    boolean randomBool = boolean(randomInt);
    println(randomBool);
    trueResults += randomInt;
  }
  
  falseResults = attempts - trueResults;
  
  for(int i2 = 0; i2 < 100; i2++) {
    println(rollDice(6, 5));  
  }
  
  println(trueResults);
  println(falseResults);
}

boolean rollDice(int sides, int requiredRoll) {
  return (int)random(1, sides + 1) == requiredRoll;
}
