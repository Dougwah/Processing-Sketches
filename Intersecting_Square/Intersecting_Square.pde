PVector obj1Pos;
PVector obj1Size = new PVector(50, 50);

PVector obj2Pos = new PVector();
PVector obj2Size = new PVector(2, 2);

void setup() {
  size(1000, 1000);
  obj1Pos = new PVector(width / 2, height / 2);
}

void draw() {
  if(checkCollisions(obj1Pos, obj1Size, obj2Pos, obj2Size)) {
    background(0);  
  } else {
     background(255);
  }
  
  obj2Pos = new PVector(mouseX, mouseY);
  
  fill(0, 255, 0);
  rect(obj1Pos.x - obj1Size.x / 2, obj1Pos.y - obj1Size.y / 2, obj1Size.x, obj1Size.y);
 
  fill(255, 0, 0);
  rect(obj2Pos.x - obj2Size.x / 2, obj2Pos.y - obj2Size.y / 2, obj2Size.x, obj2Size.y);
  

}

// a point is on a line when its position is greater than the start but less than the end
// if the pos is the center the start pos = center - size / 2 and end pos = center + size / 2
// check if pos2 is greater than pos1 - size / 2 and less than pos1 + size / 2

// check if ((obj1LeftX > obj2LeftX && obj1LeftX < obj2RightX) || (obj1RightX < obj2RightX && obj1RightX > obj2LeftX))



//boolean checkCollisions(PVector obj1Pos, PVector obj1Size, PVector obj2Pos, PVector obj2Size) {
//    boolean result = false;

//    float obj1LeftX = obj1Pos.x - obj1Size.x / 2.0;
//    float obj2LeftX = obj2Pos.x - obj2Size.x / 2.0;
    
//    float obj1RightX = obj1Pos.x + obj1Size.x / 2.0;
//    float obj2RightX = obj2Pos.x + obj2Size.x / 2.0;
    
//    float obj1TopY = obj1Pos.y - obj1Size.y / 2.0;
//    float obj2TopY = obj2Pos.y - obj2Size.y / 2.0;
    
//    float obj1BottomY = obj1Pos.y + obj1Size.y / 2.0;
//    float obj2BottomY = obj2Pos.y + obj2Size.y / 2.0;
    
//
//    if ( ( ( obj1LeftX >= obj2LeftX && obj1LeftX <= obj2RightX ) || ( obj2LeftX >= obj1LeftX && obj2LeftX <= obj1RightX ) ) || ( ( obj1RightX <= obj2RightX && obj1RightX >= obj2LeftX ) || ( obj2RightX <= obj1RightX && obj2RightX >= obj1LeftX ) ) ) {
//      if ( ( (obj1TopY >= obj2TopY && obj1TopY <= obj2BottomY ) || ( obj2TopY >= obj1TopY && obj2TopY <= obj1BottomY ) ) || ( ( obj1BottomY <= obj2BottomY && obj1BottomY >= obj2TopY ) || ( obj2BottomY <= obj1BottomY && obj2BottomY >= obj1TopY ) ) ) {
//        result = true;
//      }
//    }
    
//    return result;
//}

boolean checkCollisions(PVector pos1, PVector size1, PVector pos2, PVector size2) {
  // if right side of rect 1 is less than the left side of rect 2 
  // or the left side of rect 1 is greater than the right side of rect 2
  if (pos1.x + size1.x / 2 < pos2.x - size2.x / 2 || pos1.x - size1.x / 2 > pos2.x + size2.x / 2) {
    return false; 
  }
  
  // if the top side of rect 1 is less than the top side of rect 2
  // or the bottom side of rect 1 is greater than the bottom side of rect 2
  if (pos1.y + size1.y / 2 < pos2.y - size2.y / 2 || pos1.y - size1.y / 2 > pos2.y + size2.y / 2) {
    return false; 
  }
  
  return true;
}
