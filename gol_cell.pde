class Cell{

    int state;
    int size;
    PVector location;
    int greyValue;
    int opacity = 255;
    color c = color(180,255,102);
    
    public Cell(int x, int y, int state, int size, int z){
      this.state = state;
      location = new PVector(x,y,z);
      this.size = size;
      
    }
    
    public void draw(){
      if(state == 1){
        fill(c,opacity);
        //stroke(100);
        //noStroke();
        pushMatrix();
        translate(location.x, location.y, location.z);
        box(size);
        popMatrix();
      }
    }
    
    public void SetOpacity(int op){
      this.opacity = op;
    }
    
    public void SetRed(int r){
      c = color(red(c), r, blue(c));
    }
    
    public void Kill(){     
      this.state = 0;
    }
    
    public void Spawn(){
      this.state = 1;
    }
    
    public int GetState() {
      return this.state;
    }
    
    public PVector GetLocation(){
      return this.location;
    }
}
