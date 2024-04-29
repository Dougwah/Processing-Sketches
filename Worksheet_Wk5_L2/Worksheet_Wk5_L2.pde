//Q1
//1, true
//2, false
//3, true
//4, true
//5, false
//6, false
//7, true

//Q2
//1
int[] goals = new int[20];
//2
int[] days = new int[12];
//3
float[] salaries = new float[5000];
//4
boolean[] bools = new boolean[666];
//5
char[] consonants = new char[21];

//Q3
//1, 4
//2, 16
//3, 9
//4, 19
//5, 2, 14, 4, 18

//Q4
//1
int[] arr1 = new int[3];
for(int i = 0; i < arr1.length; i++) {
  arr1[i] = i;
}
//2
int[] arr2 = new int[3];
for(int i = 0; i < arr2.length; i++) {
  arr2[i] = 1 + i * 2;  
}
println(arr2);
//3
int[] arr3 = new int[3];
for(int i = 0; i < arr3.length; i++) {
  arr3[i] = arr3.length - i;  
}
println(arr3);
//4
int x = 1;
int[] arr4 = new int[10];
for(int i = 0; i < arr4.length; i++) {
  arr4[i] = x;
  x *= 2;
}
println(arr4);

//Q5
int[] arr = new int[] {53, 4, 23, 1, 3, 5, 6, 100};
int sum = 0;
int itemsGreater5 = 0;
int maxValue = 0;
for(int i = 0; i < arr.length; i++) {
    sum += arr[i];
    if(arr[i] > 5) {
      itemsGreater5++;  
    }
    if(arr[i] > maxValue) {
      maxValue = arr[i];  
    }
}
println(sum, itemsGreater5, maxValue);

//Q6
//1
float[] rand150 = new float[150];
for(int i = 0; i < rand150.length; i++) {
  rand150[i] = random(1, 7);  
}
//2
int[] arr10Plus2 = new int[250];
for(int i = 0; i < arr10Plus2.length; i++) {
  arr10Plus2[i] = 10 + i * 2;  
}
