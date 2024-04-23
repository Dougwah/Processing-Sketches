int start;
int end;
int update;
int result;
int resultUpdate;

boolean checkingAnswer = false;

void setup() {
  size(500, 500);
}

void draw() {
  
}

void mousePressed() {
  if(checkingAnswer) {
    checkAnswer();
  } else {
    generateQuestion();  
  }
  
  checkingAnswer = !checkingAnswer;
}

void generateQuestion() {
  start = (int)random(-10, 10);
  end = (int)random(start, start + 20);
  update = (int)random(1, 5);
  result = (int)random(-5, 5);
  resultUpdate = (int)random(-5, 5);
  
  
  println("result = " + result + "\nfor(int i = " + start + "; i < " + end + "; i += " + update + ")\n  result += " + resultUpdate + ";\n}\nresult = ?");
}

void checkAnswer() {
   for(int i = start; i < end; i += update) {
    result+= resultUpdate;
  }
  println("result = " + result);
}
