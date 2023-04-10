// Some functions to aid with matrix multiplication for collision detection

float[][] PVecToMatrix(PVector v){
  float[][] matrix = new float[3][1];
  matrix[0][0] = v.x;
  matrix[1][0] = v.y;
  matrix[2][0] = v.z;
  
  return matrix;
}

PVector MatrixToPVec(float[][] m){
  PVector vector = new PVector();
  vector.x = m[0][0];
  vector.y = m[1][0];
  if (m.length > 2){
    vector.z = m[2][0];
  }
  
  return vector;
}


float[][] matrixMult(float [][] matrixA, float[][] matrixB){
  int ACols = matrixA[0].length;
  int ARows = matrixA.length;
  
  int BCols = matrixB[0].length;
  int BRows = matrixB.length;
  
  if (ACols != BRows){
    println("Column and Row mis-match!");
    return null;
  }
  
  float result[][] = new float[ARows][BCols];
  for (int i = 0; i < ARows; i++){
    for (int j = 0; j < BCols; j++){
      float sum = 0;
      for (int k = 0; k < ACols; k++){
        sum += matrixA[i][k] * matrixB[k][j];
      }
      
      result[i][j] = sum;
    }
  }
  return result;
}

void printMatrix(float[][] m){
  int cols = m[0].length;
  int rows = m.length;
  println(rows + " x " + cols);
  println("-----------------");
  for (int i = 0; i < rows; i++){
    for (int j = 0; j < cols; j++){
      print(m[i][j] + " ");
    }
    println();
  }
  println();
}
