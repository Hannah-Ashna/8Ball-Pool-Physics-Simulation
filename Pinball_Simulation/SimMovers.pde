// SimSphere Physics
class SimSphereMover extends SimSphere{
  
 public Mover physics;
   
 public SimSphereMover(PVector startPos, float rad) {
    // this calls the base-class SimSphere constructor setting the radius
    super(rad);
    
    // instantiate out Mover class variable, called "physics"
    physics = new Mover();
    
    // move the SimSphereMover to its start position
    setTransformAbs(1,0,0,0, startPos);
    
    // set the location of the physics object to be the same as the 
    // SimSphereMover
    physics.location = this.getOrigin();
    
  }
  
  
  public void drawMe(){
    // updates the physics (if you applied any forces etc)
    // this then works out the new position of the SimSphereMover
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
  
  public SimBoxMover(PVector startPos, PVector c1, PVector c2){
    super(c1, c2);
    
    physics = new Mover();
    setTransformAbs(1,0,0,0, startPos);
    physics.location = this.getOrigin();
    
  }
  
  public void drawMe(){
    physics.update();
    
    setTransformAbs(1,0,0,0, physics.location);
    
    super.drawMe();
  }
}
