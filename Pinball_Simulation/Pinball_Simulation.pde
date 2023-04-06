///////////////////////////////////////////////////////////////
// This example builds on SimSphereMover1_CodeExample.
// The changes are only in the first tab. The SimSphereMover and other tabs remains unaltered.
// It adds in how you would detect collision between 2 SimSphereMover objects,
// and how you would use the physics component of the SimSphereMover to produce
// the collision response - i.e. how they bounce off each other.

// The scene is set up so that if you just press the "W" key, ball1 sould move and collide with ball2

SimSurfaceMesh terrain; 
SimSphereMover ball1;

ArrayList<SimBoxMover> walls = new ArrayList<SimBoxMover>();
SimBoxMover wallLeft;
SimBoxMover wallRight;
SimBoxMover wallTop;
SimBoxMover wallBottom;
SimBoxMover wallDivider;
SimBoxMover floorBase;

SimBoxMover testBox1;
SimBoxMover testBox2;

SimCamera myCamera;

void setup(){
  size(900, 700, P3D);
  
  // Setup Pinball Machine Walls
  wallLeft = new SimBoxMover(vec(0, -20, 0), vec(0, 0, 0), vec(900,20,20));
  wallRight = new SimBoxMover(vec(0,-20, 700), vec(0, 0, 0), vec(900,20,20));
  wallTop = new SimBoxMover(vec(875,-20,0), vec(0, 0, 0), vec(28,20,700));
  wallBottom = new SimBoxMover(vec(0,-20,0), vec(0, 0, 0), vec(20,20,700));
  wallDivider = new SimBoxMover(vec(0,-20,600), vec(0, 0, 0), vec(600,20,20));
  floorBase = new SimBoxMover(vec(0,0,0), vec(0, 0, 0), vec(900,10,700));
  walls.add(wallLeft);
  walls.add(wallRight);
  walls.add(wallTop);
  walls.add(wallBottom);
  walls.add(wallDivider);
  walls.add(floorBase);
  
  // Setup Ball
  ball1 = new SimSphereMover(vec(800,-15,100), 15.0f);
  
  testBox1 = new SimBoxMover(vec(100,-8,200), vec(0, 0, 0), vec(10,10,10));
  testBox2 = new SimBoxMover(vec(100,-8,250), vec(0, 0, 0), vec(10,10,10));
  
  // Create the SimCamera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(-43.29971, -629.30286, 342.63553),vec(-42.752766, -628.46576, 342.63547)); 
  myCamera.isMoving = false;
}

void draw(){
  background(0);
  lights();

  noStroke();
  fill(255,0,0);
  ball1.drawMe();
  
  fill(100,0,255);
  wallLeft.drawMe();
  wallRight.drawMe();
  wallTop.drawMe();
  wallBottom.drawMe();
  wallDivider.drawMe();
  
  fill(100,0,100);
  floorBase.drawMe();
  
  fill(255,0,0);
  testBox1.drawMe();
  testBox2.drawMe();
  
  // Apply Gravitational Pull
  PVector force = new PVector(-100, 0, 0);
  ball1.physics.addForce(force);
  
  wallCollisionChecks();

  myCamera.update();
  drawMajorAxis(new PVector(0,0,0), 200); 
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
  
  ball1.physics.addForce(force);
  //testBox1.physics.addForce(force);
}

void wallCollisionChecks(){
  if(ball1.collidesWith(wallLeft) ){
    println("colliding - bottom wall");
    ball1.physics.reverseVelocity(wallBottom.physics);
  }
  if(ball1.collidesWith(wallRight) ){
    println("colliding - bottom wall");
    ball1.physics.reverseVelocity(wallBottom.physics);
  }
  if(ball1.collidesWith(wallTop) ){
    println("colliding - bottom wall");
    ball1.physics.reverseVelocity(wallBottom.physics);
  }
  if(ball1.collidesWith(wallBottom) ){
    println("colliding - bottom wall");
    ball1.physics.reverseVelocity(wallBottom.physics);
  }
  if(ball1.collidesWith(wallDivider) ){
    println("colliding - bottom wall");
    ball1.physics.reverseVelocity(wallBottom.physics);
  }
  if(ball1.collidesWith(floorBase) ){
    println("colliding - bottom wall");
    ball1.physics.noPassThrough();
  }
}

void handleUIEvent(UIEventData  uied){}
