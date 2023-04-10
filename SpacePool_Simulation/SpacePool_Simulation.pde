///////////////////////////////////////////////////////////////
// This example builds on SimSphereMover1_CodeExample.
// The changes are only in the first tab. The SimSphereMover and other tabs remains unaltered.
// It adds in how you would detect collision between 2 SimSphereMover objects,
// and how you would use the physics component of the SimSphereMover to produce
// the collision response - i.e. how they bounce off each other.

// The scene is set up so that if you just press the "W" key, ball sould move and collide with ball2

ArrayList<SimSphereMover> otherBalls = new ArrayList<SimSphereMover>();

SimSphereMover ball;

SimBoxMover wallLeft;
SimBoxMover wallRight;
SimBoxMover wallTop;
SimBoxMover wallBottom;
SimBoxMover tableBase;
SimModelMover table;

SimCamera myCamera;

void setup(){
  size(900, 700, P3D);
  frameRate(60);
  
  // Setup Table
  //table = new SimModelMover("table.obj", vec(0, 0, 0),5, 0, 0,PI, vec(0, 0, 0));
  // transforms the rocket so it is the right way up etc.
  //table.setTransformAbs();
  //table.setPreferredBoundingVolume("box"); // or "box"
  //table.showBoundingVolume(false);
  
  tableBase = new SimBoxMover(vec(-125, 0, -225), 0,0,0, vec(0, 0, 0), vec(250,-5,430));
  wallLeft = new SimBoxMover(vec(-125, -5, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400));
  wallRight = new SimBoxMover(vec(110, -5, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400));
  wallTop = new SimBoxMover(vec(-125, -5, -200), 0,0,0, vec(0, 0, 0), vec(250,-20,15));
  wallBottom = new SimBoxMover(vec(-125, -5, 200), 0,0,0, vec(0, 0, 0), vec(250,-20,15));
   //<>//
  // Setup Main Ball
  ball = new SimSphereMover(vec(0,-40,0), 10.0f);
  otherBalls.add(ball);
  
  // Setup Other Balls
  for (int i = 0; i < 16; i++) {
    float XLoc = random(-110, 100);
    float YLoc = -14;
    float ZLoc = random(-180, 180);
    
    SimSphereMover newBall = new SimSphereMover(vec(XLoc, YLoc, ZLoc), 10.0f);
    
    newBall.physics.velocity =  new PVector(0,0,0);
    newBall.physics.setMass(0.5);
    newBall.physics.frictionAmount = 0.3;
       
    otherBalls.add(newBall);
  }
  
  // Create the SimCamera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(-1.8566599, -301.43604, 239.17004),vec(-1.8566885, -300.6257, 238.58406)); 
  myCamera.isMoving = false;
}

void draw(){
  background(0);
  lights();
  
  noStroke();
  //fill(255,0,0);
  //ball.drawMe();
  
  fill(0,103,8);
  tableBase.drawMe();
  
  fill(170,103,8);
  wallLeft.drawMe();
  wallRight.drawMe();
  wallTop.drawMe();
  wallBottom.drawMe();
  
  // Apply Gravitational Pull
  PVector force = new PVector(0, 100, 0);
  ball.physics.addForce(force);
  
  

  myCamera.update();
  //drawMajorAxis(new PVector(0,0,0), 200); 
  
  // Check for collisions with other balls
  for(int n = 0; n < otherBalls.size(); n++){
    SimSphereMover thisBall = otherBalls.get(n);
    SimSphereMover otherBall = findCollisionWithOtherBalls(thisBall,n);

    if(otherBall != null) {
      // if this ball collides with some other SimMover 
      thisBall.physics.collisionResponse(otherBall.physics);
    }
    
    if(n == 0){
      fill(255,255,255);
    } else {
      fill(255,0,0);
    }
    
    thisBall.physics.update();
    thisBall.drawMe();
    
    // Table Wall Collision
    wallCollisionChecks(thisBall);
  }
  
  ball.physics.update();
}

void drawray(SimRay r){
  PVector farPoint = r.getPointAtDistance(1000);
  pushStyle();  
  stroke(255,100,100); 
  line(r.origin.x, r.origin.y, r.origin.z, farPoint.x, farPoint.y, farPoint.z);
  popStyle();
}

SimSphereMover findCollisionWithOtherBalls(SimSphereMover thisBall, int thisBallsListPos){
   
  for (int x = thisBallsListPos + 1; x < otherBalls.size(); x++) {
      SimSphereMover otherBall = otherBalls.get(x);
      
      if( thisBall.collidesWith(otherBall) ) {
        return otherBall;
      }
  }
    
  return null;
}



void keyPressed(){

  float force = 1000f;
  
  if(key == 'c'){ 
     // toggle the camera isActive field
     myCamera.isMoving = !myCamera.isMoving;
  }

  // if the camera is active don't want the oject to move
  // so return now
  if( myCamera.isMoving ){
    //println("camera pos ", myCamera.cameraPos, " looKat ", myCamera.cameraLookat);
    return;
  }
  
  if(key == 'w'){
    // UP
    moveObject(0,-force, 0);
    }
  
  if(key == 's'){
    // DOWN
    moveObject(0,force, 0);
    }
  
  if(key == CODED){
    if(keyCode == UP){
      moveObject(0,0, -force);
      }
    if(keyCode == DOWN){ 
       moveObject(0,0,force);
      }
    if(keyCode == LEFT){
      moveObject(-force,0,0);
      }
     if(keyCode == RIGHT){
       moveObject(force,0,0);   
       }  
    }
}

void moveObject(float x, float y, float z){
 
  PVector force = new PVector(x, y, z);
  ball.physics.addForce(force);
}

void wallCollisionChecks(SimSphereMover thisBall){
  if(thisBall.collidesWith(wallLeft) ){
    thisBall.physics.reverseVelocity(wallLeft.physics);
  }
  if(thisBall.collidesWith(wallRight) ){
    thisBall.physics.reverseVelocity(wallRight.physics);
  }
  if(thisBall.collidesWith(wallTop) ){
    thisBall.physics.reverseVelocity(wallTop.physics);
  }
  if(thisBall.collidesWith(wallBottom) ){
    thisBall.physics.reverseVelocity(wallBottom.physics);
  }
  if(thisBall.collidesWith(tableBase) ){
    thisBall.physics.noPassThrough();
  }
  /*if(ball.collidesWith(table) ){
    println("Colliding");
    //ball.physics.noPassThrough();
  }*/
}

void handleUIEvent(UIEventData  uied){}
