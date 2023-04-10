///////////////////////////////////////////////////////////////
// This example builds on SimSphereMover1_CodeExample.
// The changes are only in the first tab. The SimSphereMover and other tabs remains unaltered.
// It adds in how you would detect collision between 2 SimSphereMover objects,
// and how you would use the physics component of the SimSphereMover to produce
// the collision response - i.e. how they bounce off each other.

// The scene is set up so that if you just press the "W" key, ball sould move and collide with ball2

ArrayList<SimSphereMover> otherBalls;
SimObjectManager simObjectManager = new SimObjectManager();

SimSphereMover ball;

SimBoxMover wallLeft;
SimBoxMover wallRight;
SimBoxMover wallTop;
SimBoxMover wallBottom;
SimBoxMover tableBase;

SimModelMover fan_L;
SimModelMover fan_R;
SimModelMover fan_T;
SimModelMover fan_B;
RadialForceObject RFO_L;
RadialForceObject RFO_R;
RadialForceObject RFO_T;
RadialForceObject RFO_B;

SimCamera myCamera;
SimpleUI gameUI;

void setup(){
  size(900, 700, P3D);
  frameRate(120);
  init();
  
  // Create the SimCamera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(-26.465195, -355.21072, 283.11923),vec(-26.465223, -354.4004, 282.53326)); 
  myCamera.isMoving = false;
  myCamera.setHUDArea(20,20,220,400);
  
  initUI(); //<>//
}

void init() {
  tableBase = new SimBoxMover(vec(-125, 0, -205), 0,0,0, vec(0, 0, 0), vec(250,-5,420), color(0,103,8));
  tableBase.physics.frictionAmount = 0.1;
  
  wallLeft = new SimBoxMover(vec(-125, -5, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400), color(170,103,8));
  wallRight = new SimBoxMover(vec(110, -5, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400), color(170,103,8));
  wallTop = new SimBoxMover(vec(-125, -5, -200), 0,0,0, vec(0, 0, 0), vec(250,-20,15), color(170,103,8));
  wallBottom = new SimBoxMover(vec(-125, -5, 200), 0,0,0, vec(0, 0, 0), vec(250,-20,15), color(170,103,8));
  
  fan_L = new SimModelMover("fan.obj", vec(0,0,0), 3, 0, 0, 0, vec(-200, -25, 0));
  fan_R = new SimModelMover("fan.obj", vec(0,0,0), 3, 0, 0, 0, vec(200, -25, 0));
  fan_T = new SimModelMover("fan.obj", vec(0,0,0), 3, PI/2, 0, PI/2, vec(0, -25, -260));
  fan_B = new SimModelMover("fan.obj", vec(0,0,0), 3, PI/2, 0, PI/2, vec(0, -25, 240));
  RFO_L = new RadialForceObject(vec(-140, -5, 0), 2000);
  RFO_R = new RadialForceObject(vec(140, -5,  0), 2000);
  RFO_T = new RadialForceObject(vec(0, -5, -250), 2000);
  RFO_B = new RadialForceObject(vec(0, -5, 250), 2000);
  
  // Setup Main Ball
  ball = new SimSphereMover(vec(0,-14,0), 10.0f);
  otherBalls = new ArrayList<SimSphereMover>();
  otherBalls.add(ball);
  simObjectManager.addSimObject(ball, "ball");
  
  // Setup Other Balls
  for (int i = 0; i < 15; i++) {
    float XLoc = random(-80, 80);
    float YLoc = -14;
    float ZLoc = random(-160, 160);
    
    SimSphereMover newBall = new SimSphereMover(vec(XLoc, YLoc, ZLoc), 10.0f);
    
    newBall.physics.radius = 10.0f;
    newBall.physics.velocity =  new PVector(0,0,0);
    newBall.physics.setMass(0.5);
    newBall.physics.frictionAmount = 0.3;
       
    otherBalls.add(newBall);
  }
  
}

void initUI(){
  // Setup UI
  gameUI = new SimpleUI();
  
  gameUI.addSimpleButton("Restart", 30, 30);
  
  gameUI.addToggleButton("Fan (L)", 30, 65);
  gameUI.addToggleButton("Fan (R)", 100, 65);
  gameUI.addToggleButton("Fan (T)", 30, 95);
  gameUI.addToggleButton("Fan (B)", 100, 95);
  
  gameUI.addSlider("Fan Strength (L)", 30, 140).setSliderValue(1);
  gameUI.addSlider("Fan Strength (R)", 30, 170).setSliderValue(1);
  gameUI.addSlider("Fan Strength (T)", 30, 200).setSliderValue(1);
  gameUI.addSlider("Fan Strength (B)", 30, 230).setSliderValue(1);
  gameUI.addSlider("Friction", 30, 260).setSliderValue(0.1);
  
  String[] styleMenuItems = {"Standard","Dracula","Icy"};
  gameUI.addMenu("Table Styles", 30, 300, styleMenuItems);
  
  
}

void draw(){
  background(0);
  lights();
  
  noStroke();
  
  tableBase.drawMe();
  wallLeft.drawMe();
  wallRight.drawMe();
  wallTop.drawMe();
  wallBottom.drawMe();
  
  // Apply Gravitational Pull
  PVector force = new PVector(0, 100, 0);
  ball.physics.addForce(force);
  
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
    } else if (n > 8){
      fill(26,70,156);
    } else {
      fill(192,15,15);
    } 
    
    if(n == 14){
      fill(0,0,0);
    }
    
    thisBall.physics.update();
    thisBall.drawMe();
    
    // Table Wall Collision
    wallCollisionChecks(thisBall);
    
    // Fan Radial Force Checks
    fanRadialForceChecks(thisBall);

  }
  
  if (RFO_L.isActive){ fan_L.Rx += 0.1; fan_L.drawMe(); }
  if (RFO_R.isActive){ fan_R.Rx += 0.1; fan_R.drawMe(); }
  if (RFO_T.isActive){ fan_T.Rz += 0.1; fan_T.drawMe(); }
  if (RFO_B.isActive){ fan_B.Rz += 0.1; fan_B.drawMe(); }
  
  ball.physics.update();
  
  myCamera.update();
  myCamera.startDrawHUD();
  gameUI.update();
  myCamera.endDrawHUD();
  //drawMajorAxis(new PVector(0,0,0), 200); 

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

void mousePressed(){
  updateMouseTracker();
}

void mouseDragged(){
  updateMouseTracker();
}

void updateMouseTracker(){
  if(mouseButton == RIGHT) return;
  boolean pickedCueBall = false;
  
  int totalObjs = simObjectManager.getNumSimObjects();
  
  for (int n = 0; n < totalObjs; n++){
    SimTransform obj = simObjectManager.getSimObject(n);
    SimRay mouseRay = myCamera.getMouseRay();
    mouseRay.setID("Mouse Ray");
    
    if(mouseRay.calcIntersection(obj)){
      PVector intersectionPoint = mouseRay.getIntersectionPoint();
      PVector ballPos = ball.physics.location;
      float dist = intersectionPoint.dist(ballPos);
      
      if (dist < ball.physics.radius+1){
        PVector directionVec = PVector.sub(ballPos, intersectionPoint);
        directionVec.mult(1500);
        ball.physics.addForce(directionVec);
      }
      
      println(dist);
      
      pickedCueBall = true;
      break;
    }
  }
  
  //if (pickedCueBall) { return; }
}


void keyPressed(){

  float force = 3000f;
  
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
  
  /*if(key == 'w'){
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
    }*/
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
    thisBall.physics.noPassThrough(tableBase.physics);
  }
}

void fanRadialForceChecks(SimSphereMover thisBall){
  if (RFO_L.isActive){
    thisBall.physics.addForce(RFO_L.getForce(thisBall.physics.location));
  }
  if (RFO_R.isActive){
    thisBall.physics.addForce(RFO_R.getForce(thisBall.physics.location));
  }
  if (RFO_T.isActive){
    thisBall.physics.addForce(RFO_T.getForce(thisBall.physics.location));
  }
  if (RFO_B.isActive){
    thisBall.physics.addForce(RFO_B.getForce(thisBall.physics.location));
  }
}

void handleUIEvent(UIEventData  uied){
  uied.print(0);
  
  // Reset Game
  if(uied.eventIsFromWidget("Restart") ){   
    // Not working yet???
    init();
  }
  
  // Set Table Friction Value
  if(uied.eventIsFromWidget("Friction") ){
    float frictionVal = uied.sliderValue * 5;
    tableBase.physics.frictionAmount = frictionVal;
  }
  
  // Fan Toggle + Slider Checks
  if(uied.eventIsFromWidget("Fan (L)") ){
    RFO_L.toggleActive();
  }
  if(uied.eventIsFromWidget("Fan Strength (L)") ){
    float forceVal = uied.sliderValue * 2000;
    RFO_L.forceAmount = forceVal;
  }
  
  if(uied.eventIsFromWidget("Fan (R)") ){
    RFO_R.toggleActive();
  }
  if(uied.eventIsFromWidget("Fan Strength (R)") ){
    float forceVal = uied.sliderValue * 2000;
    RFO_R.forceAmount = forceVal;
  }
  
  if(uied.eventIsFromWidget("Fan (T)") ){
    RFO_T.toggleActive();
  }
  if(uied.eventIsFromWidget("Fan Strength (T)") ){
    float forceVal = uied.sliderValue * 2000;
    RFO_T.forceAmount = forceVal;
  }
  
  if(uied.eventIsFromWidget("Fan (B)") ){
    RFO_B.toggleActive();
  }
  if(uied.eventIsFromWidget("Fan Strength (B)") ){
    float forceVal = uied.sliderValue * 2000;
    RFO_B.forceAmount = forceVal;
  }
  
  // Check for Style Choices
  if(uied.menuItem.equals("Standard") ){
    tableBase.updateColour(color(0,103,8));
    
    wallLeft.updateColour(color(170,103,8));
    wallRight.updateColour(color(170,103,8));
    wallTop.updateColour(color(170,103,8));
    wallBottom.updateColour(color(170,103,8));
  }   
  
  if(uied.menuItem.equals("Dracula") ){
    tableBase.updateColour(color(110,18,18));
    
    wallLeft.updateColour(color(98,74,74));
    wallRight.updateColour(color(98,74,74));
    wallTop.updateColour(color(98,74,74));
    wallBottom.updateColour(color(98,74,74));
  }
  
  if(uied.menuItem.equals("Icy") ){
    tableBase.updateColour(color(149,249,246));
    
    wallLeft.updateColour(color(28,162,158));
    wallRight.updateColour(color(28,162,158));
    wallTop.updateColour(color(28,162,158));
    wallBottom.updateColour(color(28,162,158));
  }
}
