class Matrix {

  Cell[][] matrix;
  int zCoord;
  int size;//solun koko
  int xsize;//soluja x-suunnassa
  int ysize;//soluja y-suunnassa
  
  
  public Matrix(int x, int y, int z, int size){//size == cellSize
    matrix = new Cell[x][y];
    zCoord = z;
    this.size = size;
    xsize=x;
    ysize=y;
    
    //täytetään matriisi uusilla soluilla
    for(int i=0; i<x; i++){
      for(int j=0; j<y; j++){
        matrix[i][j] = new Cell(size*i - size*x/2, size*j - size*y/2, 0, size, zCoord);
      }
    }
  }
  
  //päivittää matriisin solujen tilat(elävä/kuollut) annetun matriisin mukaisiksi
  //+ solujen läpinäkyvyyden (ehkä tulevaisuudessa myös värit)
  public void Update(Cell[][] info, int opacity, int c){
    
    for(int i=0; i<xsize; i++){
      for(int j=0; j<ysize; j++){
      
        if(info[i][j].GetState()==1){
          matrix[i][j].Spawn();
        }else{
          matrix[i][j].Kill();
        }
        
        matrix[i][j].SetOpacity(opacity);
        matrix[i][j].SetRed(c);
      }
    }        
  }
  
  //palauttaa pelkän matriisin. tarvitaan jälkikuvien päivityksessä
  public Cell[][] GetCells(){
    return this.matrix;
  }
  
  //piirtää matriisin solut
  public void Print(){
     for(int i=0; i<xsize; i++){
      for(int j=0; j<ysize; j++){
      
        noStroke();
        matrix[i][j].draw();
      }
    }
  }  
}
