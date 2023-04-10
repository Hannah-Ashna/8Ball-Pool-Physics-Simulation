///////////////////////////////////////////////////////////////
// This example builds on SimSphereMover1_CodeExample.
// The changes are only in the first tab. The SimSphereMover and other tabs remains unaltered.
// It adds in how you would detect collision between 2 SimSphereMover objects,
// and how you would use the physics component of the SimSphereMover to produce
// the collision response - i.e. how they bounce off each other.

// The scene is set up so that if you just press the "W" key, ball sould move and collide with ball2

SimSphereMover ball;
SimSphereMover ball2;
SimSphereMover ball3;

ArrayList<SimBoxMover> walls = new ArrayList<SimBoxMover>();
SimBoxMover wallLeft;
SimBoxMover wallRight;
SimBoxMover wallTop;
SimBoxMover wallBottom;
SimBoxMover tableBase;
SimModelMover table;

SimCamera myCamera;

void setup(){
  size(900, 700, P3D);
  
  // Setup Table
  //table = new SimModelMover("table.obj", vec(0, 0, 0),5, 0, 0,PI, vec(0, 0, 0));
  // transforms the rocket so it is the right way up etc.
  //table.setTransformAbs();
  //table.setPreferredBoundingVolume("box"); // or "box"
  //table.showBoundingVolume(false);
  
  tableBase = new SimBoxMover(vec(-125, 0, -225), 0,0,0, vec(0, 0, 0), vec(250,-25,430));
  wallLeft = new SimBoxMover(vec(-125, -25, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400));
  wallRight = new SimBoxMover(vec(110, -25, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400));
  wallTop = new SimBoxMover(vec(-125, -25, -200), 0,0,0, vec(0, 0, 0), vec(250,-20,15));
  wallBottom = new SimBoxMover(vec(-125, -25, 200), 0,0,0, vec(0, 0, 0), vec(250,-20,15));
  walls.add(wallLeft);
  walls.add(wallRight);
  walls.add(wallTop);
  walls.add(wallBottom);
   //<>//
  // Setup Ball
  ball = new SimSphereMover(vec(0,-80,0), 10.0f);
  ball2 = new SimSphereMover(vec(30,-40,0), 10.0f);
  ball3 = new SimSphereMover(vec(0,-40,20), 10.0f);
  
  // Create the SimCamera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(-1.8566599, -301.43604, 239.17004),vec(-1.8566885, -300.6257, 238.58406)); 
  myCamera.isMoving = false;
}

void draw(){
  background(0);
  lights();

  //table.drawMe();

  noStroke();
  fill(255,0,0);
  ball.drawMe();
  
  fill(0,103,8);
  tableBase.drawMe();
  //ball2.drawMe();
  //ball3.drawMe();
  
  fill(170,103,8);
  wallLeft.drawMe();
  wallRight.drawMe();
  wallTop.drawMe();
  wallBottom.drawMe();
  
  // Apply Gravitational Pull
  PVector force = new PVector(0, 100, 0);
  ball.physics.addForce(force);
  
  wallCollisionChecks();

  myCamera.update();
  //drawMajorAxis(new PVector(0,0,0), 200); 
  
  ball.physics.update();
}

void drawray(SimRay r){
  PVector farPoint = r.getPointAtDistance(1000);
  pushStyle();  
  stroke(255,100,100); 
  line(r.origin.x, r.origin.y, r.origin.z, farPoint.x, farPoint.y, farPoint.z);
  popStyle();
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
      moveObject(-force,0,0);
      }
    if(keyCode == DOWN){ 
     moveObject(force,0,0);
      }
    if(keyCode == LEFT){
      moveObject(0,0, -force);
      }
     if(keyCode == RIGHT){
      moveObject(0,0,force);
       }  
    }
}

void moveObject(float x, float y, float z){
 
  PVector force = new PVector(x, y, z);
  ball.physics.addForce(force);
}

void wallCollisionChecks(){
  if(ball.collidesWith(ball2) ){
    ball.physics.collisionResponse(ball2.physics);
  }
  if(ball.collidesWith(ball3) ){
    ball.physics.collisionResponse(ball3.physics);
  }
  if(ball.collidesWith(wallLeft) ){
    ball.physics.reverseVelocity(wallLeft.physics);
  }
  if(ball.collidesWith(wallRight) ){
    ball.physics.reverseVelocity(wallRight.physics);
  }
  if(ball.collidesWith(wallTop) ){
    ball.physics.reverseVelocity(wallTop.physics);
  }
  if(ball.collidesWith(wallBottom) ){
    ball.physics.reverseVelocity(wallBottom.physics);
  }
  if(ball.collidesWith(tableBase) ){
    println("Colliding:");
    ball.physics.noPassThrough();
  }
  /*if(ball.collidesWith(table) ){
    println("Colliding");
    //ball.physics.noPassThrough();
  }*/
}

void handleUIEvent(UIEventData  uied){}
