
int cellSize = 10;  //solujen koko
int x = 80;  //solujen määrä x- suunnassa
int y = 80;  //solujen määrä y- suunnassa
int past;  //hetki jona viimeisin päivitys tehtiin
int updateInterval =100;  //päivitysten välinen aika
int likelinessOfStillbirth = 70;  // todennäköisyydellä solu on kuollut kun se alussa luodaan
int tallness = 25;
float zoom = -400;
color coloring = color(0,0,5);
int gap = 0;// kerrosten välinen tila

//luodaan 2d matriisit, johon menee kaikki nyk. ikkunaan sopivat solut
Cell[][] cellMatrix;
Cell[][] tempMatrix;
Matrix[] afterMatrix;

void setup(){
  fullScreen(P3D); //HUOM! countNeighbours- funktio olettaa (ainakin tässä vaiheessa), että canvas on neliö!!
  reset(); //alustaa matriisit & arpoo niille alkutilat 
}

void draw(){
  
  //tutkitaan onko jo aika päivittää ruutu
  if(millis() - past > updateInterval){
    past = millis();
    
    background(0);
    noCursor();
    
    translate(width/2, height/2, zoom);
    rotateY(map(mouseX, 0, width, 0, 2*PI));
    rotateX(map(mouseY, 0, height, 0, 2*PI));
    
   
    
    //Päivitetään tempMatrix tutkimalla cellMatrixin soluja
    for(int i=0; i<x; i++){
      for(int j=0; j<y; j++){
      
        //lasketaan käsiteltävänä olevan solun elävät naapurit
        int neighbours = countNeighbours(i, j, cellMatrix, x);
        
        //jos solulla on <2 tai >3 elävää naapuria, se tapetaan
        if((neighbours > 3) || (neighbours < 2)){
          tempMatrix[i][j].Kill();
        }
        //jos solu on kuollut ja sillä on 3 elävää naapuria, se herää eloon
        if(cellMatrix[i][j].GetState()==0 && neighbours == 3){
          tempMatrix[i][j].Spawn();
        }      
      }
    }
  
    /*päivitetään afterMatrixin solut sen omilla aiemmilla ja viimeisimmällä temp matrixilla.
    update- funktiolle pitää antaa parametreina matrix jonka mukaiseksi matriisi päivitetään, haluttu opacity
    sekä punaisen arvo
    */
    
    for(int i=tallness-1; i>-1; i--){      
      if(i>1){
        afterMatrix[i].Update(afterMatrix[i-1].GetCells(), 255-i*10, 255-i*10);
      }else{
        afterMatrix[i].Update(tempMatrix, 255-i*10, 255-i*10);
      }
    }
    
    stroke(200,20,200);
    //piirretään päivitetty tempmatrix
    for(int i=0; i<x; i++){
      for(int j=0; j<y; j++){
      
        tempMatrix[i][j].draw();
      }
    }
    
    //piirretään päivitetty afterMatrix
    for(int i=0; i<afterMatrix.length; i++){
      afterMatrix[i].Print();
    }
    
    //päivitetään lopuksi cellMatrixin solut tempMatrixin solujen arvoilla.
    //näin saadaan cellMatrix päivitettyä, mutta pidetään kuitenkin matriisit erillisinä
    //cellmatrix=tempmatrix johtaa siihen, että molemmat viittaa samaan matriisiin = fail
    for(int i=0; i<x; i++){
      for(int j=0; j<y; j++){
      
        if(tempMatrix[i][j].GetState()==1){
          cellMatrix[i][j].Spawn();
        }else{
          cellMatrix[i][j].Kill();
        }
      }
    }    
  }
}

//laskee annetun solun elävät naapurisolut annetussa solumatriisissa. size == solujen määrä rivissä
int countNeighbours(int xx, int yy, Cell[][] matrix, int size){
  int count = 0;
  
  for(int i=-1; i<2; i++){
    for(int j=-1; j<2;j++){
      if((i==0 && j==0) || (xx+i<0 || xx+i==size) || (yy+j<0 || yy+j==size)){//oon tarkastanu reunat ja tehny silti erillisen funktion sille? O_o
        continue;
      } else if(isEdgeCell(xx, yy, size)){//skippaa reunasolut
        continue;
      }else {
        count += matrix[xx+i][yy+j].GetState();//lukee solun tilan
      } 
    }
  }
  return count;
}

//tarkastaa onko solu reunasolu
boolean isEdgeCell(int xx, int yy, int size){
  return xx == size-1 || xx==0 || yy==size-1 || yy==0; 
}

//zoomaus hiiren rullalla
void mouseWheel(MouseEvent event) {
  zoom += event.getCount()*100*-1;
}

void mouseClicked(){
  reset();
}

void reset(){
   cellMatrix = new Cell[x][y];
  tempMatrix = new Cell[x][y];
  afterMatrix = new Matrix[tallness];//luodaan aftermatrix generoituvia pylväitä varten.
  
  //täytetään aftermatrixin matriisit soluilla, Matrix- konstruktori huolehtii varsinaisesta täytöstä
  for(int i=0; i<tallness;  i++){
    afterMatrix[i] = new Matrix(x,y,(i+1)*cellSize+gap*i, cellSize);
  }
  
  //täytetään muut matriisit soluilla ja arvotaan alkuun elävät solut 
  for(int i=0; i<x; i++){
    for(int j=0; j<y; j++){
      float chance = random(100); 
      int state = 0;
      if(chance > likelinessOfStillbirth){
        state = 1;
      }
      cellMatrix[i][j] = new Cell(cellSize*i - cellSize*x/2, cellSize*j - cellSize*y/2, state, cellSize, 0);
      tempMatrix[i][j] = new Cell(cellSize*i - cellSize*x/2, cellSize*j - cellSize*y/2, 0, cellSize, 0);
    }
  }
}
