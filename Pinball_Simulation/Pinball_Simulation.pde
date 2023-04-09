///////////////////////////////////////////////////////////////
// This example builds on SimSphereMover1_CodeExample.
// The changes are only in the first tab. The SimSphereMover and other tabs remains unaltered.
// It adds in how you would detect collision between 2 SimSphereMover objects,
// and how you would use the physics component of the SimSphereMover to produce
// the collision response - i.e. how they bounce off each other.

// The scene is set up so that if you just press the "W" key, ball sould move and collide with ball2

SimSurfaceMesh terrain; 
SimSphereMover ball;

ArrayList<SimBoxMover> walls = new ArrayList<SimBoxMover>();
SimBoxMover wallLeft;
SimBoxMover wallRight;
SimBoxMover wallTop;
SimBoxMover wallBottom;
SimBoxMover wallDivider;
SimBoxMover floorBase;
SimBoxMover angledBox;

SimSphere point;
SimSphere point2;
SimSphere point3;
SimSphere point4;

RadialForceObject RFO;
RadialForceObject RFO2;
RadialForceObject RFO3;
RadialForceObject RFO4;

SimCamera myCamera;

void setup(){
  size(900, 700, P3D);
  
  // Setup Pinball Machine Walls
  wallLeft = new SimBoxMover(vec(0, -20, 0), 0,0,0, vec(0, 0, 0), vec(900,20,20));
  wallRight = new SimBoxMover(vec(0,-20, 700), 0,0,0, vec(0, 0, 0), vec(900,20,20));
  wallTop = new SimBoxMover(vec(875,-20,0), 0,0,0, vec(0, 0, 0), vec(28,20,700));
  wallBottom = new SimBoxMover(vec(0,-20,0), 0,0,0, vec(0, 0, 0), vec(20,20,700));
  wallDivider = new SimBoxMover(vec(0,-20,600), 0,0,0, vec(0, 0, 0), vec(600,20,20));
  floorBase = new SimBoxMover(vec(0,0,0), 0,0,0, vec(0, 0, 0), vec(900,10,700));
  walls.add(wallLeft);
  walls.add(wallRight);
  walls.add(wallTop);
  walls.add(wallBottom);
  walls.add(wallDivider);
  walls.add(floorBase);
  
  // Setup other Items
  angledBox = new SimBoxMover(vec(900, -20, 580), 0, 1.3*PI ,0, vec(0, 0, 0), vec(160,20,20));
  RFO = new RadialForceObject(new PVector(700, -20, 700), 10000);
 //<>//
  point = new SimSphere(vec(900.0, -20.0, 580.0 ), 10.0f);
  point2 = new SimSphere(vec(800, -20, 700), 10.0f);
  point3 = new SimSphere(vec(880, -20, 560), 10.0f);
  point4 = new SimSphere(vec(900.0, 0.0, 580.0 ), 10.0f);

  // Setup Ball
  ball = new SimSphereMover(vec(100,-15,650), 15.0f);
  
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
  ball.drawMe();
  
  fill(100,0,255);
  wallLeft.drawMe();
  wallRight.drawMe();
  wallTop.drawMe();
  wallBottom.drawMe();
  wallDivider.drawMe();
  angledBox.drawMe();
   
  fill(100,0,100);
  floorBase.drawMe();
  
  fill(0,255,0);
  point.drawMe();
  point2.drawMe();
  point3.drawMe();
  point4.drawMe();
  
  // Apply Gravitational Pull
  PVector force = new PVector(-100, 20, 0);
  ball.physics.addForce(force);
  
  wallCollisionChecks();

  myCamera.update();
  drawMajorAxis(new PVector(0,0,0), 200); 
  
  //RFO.display();
  //ball.physics.addForce(RFO.getForce(ball.physics.location));
  
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
      //moveObject(-force,0,0);
      PVector launchForce = new PVector(25000, 0, 0);
      ball.physics.addForce(launchForce);
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
  if(ball.collidesWith(wallDivider) ){
    ball.physics.reverseVelocity(wallDivider.physics);
  }
  if(ball.collidesWith(angledBox) ){
    ball.physics.angularVelocity(angledBox.physics);
  }
  if(ball.collidesWith(floorBase) ){
    ball.physics.noPassThrough();
  }
}

void handleUIEvent(UIEventData  uied){}
