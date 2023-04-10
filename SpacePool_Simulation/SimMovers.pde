// SimSphere Physics
class SimSphereMover extends SimSphere{
  
 public Mover physics;
 float r;
   
 public SimSphereMover(PVector startPos, float rad) {
    // this calls the base-class SimSphere constructor setting the radius
    super(rad);
    r = rad;
    
    // instantiate out Mover class variable, called "physics"
    physics = new Mover();
    physics.radius = r;
    
    // move the SimSphereMover to its start position
    setTransformAbs(1,0,0,0, startPos);
    
    // set the location of the physics object to be the same as the 
    // SimSphereMover
    physics.location = this.getOrigin();
    
  }
  
  
  public void drawMe(){
    // updates the physics (if you applied any forces etc)
    // this then works out the new position of the SimSphereMover
    physics.radius = r;
    physics.update();
    // sets the SimSphereMover to the physics' location
    setTransformAbs(1,0,0,0, physics.location);
    
    // calls the base-class SimSphere's drawMe stuff, to do the rest of th drawing
    super.drawMe();
  }
  
}

// SimBox Physics
class SimBoxMover extends SimBox {
  public Mover physics;
  float Rx;
  float Ry;
  float Rz;
  color c;
  
  public SimBoxMover(PVector startPos, float RX, float RY, float RZ, PVector c1, PVector c2, color boxColor){
    super(c1, c2, startPos, boxColor);
    this.Rx = RX;
    this.Ry = RY;
    this.Rz = RZ;
    this.c = boxColor;
    
    physics = new Mover();
    setTransformAbs(1,Rx,Ry,Rz, startPos);
    physics.location = startPos;
    
    
  }
  
  public void drawMe(){
    physics.update();
    
    setTransformAbs(1,Rx,Ry,Rz, physics.location);
    
    super.drawMe();
  }
}

// SimModel Physics
class SimModelMover extends SimModel {
  public Mover physics;
  float Rx, Ry, Rz;
  float Scale;
  
  public SimModelMover(String filename, PVector startPos, float scale, float rx, float ry, float rz, PVector translate){
    super(filename);
    Rx = rx;
    Ry = rx;
    Rz = rz;
    Scale = scale;
    
    physics = new Mover();
    setTransformAbs(scale,rx,ry,rz, translate);
    physics.location = this.getOrigin();
    
        
  }
  
  public void drawMe(){
    physics.update();   
    println(physics.location);
    setTransformAbs(Scale,Rx,Ry,Rz, physics.location);
    super.drawMe();
  }
}
