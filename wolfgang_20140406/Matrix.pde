class Matrix
{
  int rows;
  int columns;
  float data[][];
  
  Matrix (int ir, int ic, float il[][])
  {
    rows = ir;
    columns = ic;
    data = new float[rows][columns];
    for (int i = 0; i < rows; i++)
    {
      for (int ii = 0; ii < columns; i++)
      {
        data[i][ii] = il[i][ii];
      }
    }
  }
  

  Matrix product(Matrix min)
  {
    float product[][] = new float[rows][min.columns];
    for (int i = 0 ; i < rows; i++ )
    {
      for (int ii = 0 ; ii < min.columns; ii++ )
      {
        float sum = 0;
        for (int iii = 0 ; iii < min.rows; iii++ )
        {
          sum += data[i][iii] * min.data[iii][ii];
        }
        
        product[i][ii] = sum;
      }
    }
    return new Matrix(rows, min.columns, product);
  }
}
