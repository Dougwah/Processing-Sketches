//Q1
//1.1
// False as the type is declared as an int not an int array
//1.2
// False as the type is declared as an array of ints not an array of int arrays
//1.3
// True
//1.4
// True
//1.5
// True

//Q2
//int[][] arr = new int[3][3];
//for(int i = 0; i < arr.length; i++) {
//  for(int k = 0; k < arr.length; k++) {
//    arr[i][k] = i; 
//  }
//}

//for(int i = 0; i < arr.length; i++) {
//  for(int k = 0; k < arr.length; k++) {
//    arr[i][k] = k;
//  }
//}

//for(int i = 0; i < arr.length; i++) {
//  for(int k = 0; k < arr.length; k++) {
//    arr[i][k] = i + k;
//  }
//}

//for(int i = 0; i < arr.length; i++) {
//  for(int k = 0; k < arr.length; k++) {
//    arr[i][k] = k + k * i;
//  }
//}


void setup() {
  println(nZeroSubArrays(new int[][] {{0,0}, {1,0}, {0,1}, {0,0}, {0,0}}));
  println();
  
  int [][] arr = { {3, -4}, {-7}, {5, -6, -1} };
    
  println(highestIn2D(arr));
  println();
  makeAbsolute(arr); 
  //arr should become  { {3, 4}, {7}, {5, 6, 1} }
  for (int i=0; i < arr.length; i++) {
     for (int k=0; k < arr[i].length; k++) {
       print (arr[i][k]+" ");
     }
     println ();
  }
  println();
  println(sumArray(new int[][] {{1, 4}, {5, 9, 3, 7}, {6}}, 1));

}

//Q3
int nZeroSubArrays(int[][] x) {
  int result = 0;
  for(int i = 0; i < x.length; i++) {
    boolean only0 = true;
    for(int k = 0; k < x[i].length && only0; k++) {
      if(x[i][k] != 0) {
        only0 = false;  
      }
    }
    if (only0) {
      result++;  
    }
  }
  return result;
}

//Q4
void makeAbsolute(int[][] x) {
  for(int i = 0; i < x.length; i++) {
    for(int k = 0; k < x[i].length; k++) {
      x[i][k] = abs(x[i][k]);  
    }
  }
}

//Q5
int highestIn2D(int[][] x) {
  int result = 0; 
  for(int i = 0; i < x.length; i++) {
     for(int k = 0; k < x[i].length; k++) {
       result = max(x[i][k], result);  
     }
   }
  return result;
}

//Q6
int sumArray(int[][] x, int idx) {
  int result = 0;
  for(int i = 0; i < x[idx].length; i++) {
    result +=  x[idx][i];
  }
  return result;
}
