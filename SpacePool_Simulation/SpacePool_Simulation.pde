import processing.sound.*; //<>//
SoundFile hitSFX;

ArrayList<SimSphereMover> otherBalls;
ArrayList<Integer> ballType;
SimObjectManager simObjectManager = new SimObjectManager();

SimSphereMover ball;
SimSphereMover pocket1;
SimSphereMover pocket2;
SimSphereMover pocket3;
SimSphereMover pocket4;
SimSphereMover pocket5;
SimSphereMover pocket6;

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
SimRay cueBallRay;
PVector gravity;
PVector ballHitDirectionVec;
boolean enabledPvC;
boolean pickedCueBall;
float ballHitForce;
float ballMass;
int playerScore;
int computerScore;

void setup(){
  size(900, 700, P3D);
  frameRate(120);
  init();
  
  // Create the SimCamera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(-26.465195, -355.21072, 283.11923),vec(-26.465223, -354.4004, 282.53326)); 
  myCamera.isMoving = false;
  myCamera.setHUDArea(20,20,220,500);
  
  initUI();
}

void init() {
  tableBase = new SimBoxMover(vec(-125, 0, -205), 0,0,0, vec(0, 0, 0), vec(250,-5,420), color(0,103,8));
  tableBase.physics.frictionAmount = 0.1;
  
  wallLeft = new SimBoxMover(vec(-125, -5, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400), color(170,103,8));
  wallRight = new SimBoxMover(vec(110, -5, -200), 0,0,0, vec(0, 0, 0), vec(15,-20,400), color(170,103,8));
  wallTop = new SimBoxMover(vec(-125, -5, -200), 0,0,0, vec(0, 0, 0), vec(250,-20,15), color(170,103,8));
  wallBottom = new SimBoxMover(vec(-125, -5, 200), 0,0,0, vec(0, 0, 0), vec(250,-20,15), color(170,103,8));
  
  pocket1 = new SimSphereMover(vec(-105,-10,-177), 10.0f);
  pocket2 = new SimSphereMover(vec(105,-10,-177), 10.0f);
  pocket3 = new SimSphereMover(vec(-105,-10,0), 10.0f);
  pocket4 = new SimSphereMover(vec(105,-10,0), 10.0f);
  pocket5 = new SimSphereMover(vec(-105,-10,195), 10.0f);
  pocket6 = new SimSphereMover(vec(105,-10,195), 10.0f);
  
  fan_L = new SimModelMover("fan.obj", vec(0,0,0), 3, 0, 0, 0, vec(-200, -25, 0));
  fan_R = new SimModelMover("fan.obj", vec(0,0,0), 3, 0, 0, 0, vec(200, -25, 0));
  fan_T = new SimModelMover("fan.obj", vec(0,0,0), 3, PI/2, 0, PI/2, vec(0, -25, -260));
  fan_B = new SimModelMover("fan.obj", vec(0,0,0), 3, PI/2, 0, PI/2, vec(0, -25, 240));
  RFO_L = new RadialForceObject(vec(-140, -5, 0), 2000);
  RFO_R = new RadialForceObject(vec(140, -5,  0), 2000);
  RFO_T = new RadialForceObject(vec(0, -5, -250), 2000);
  RFO_B = new RadialForceObject(vec(0, -5, 250), 2000);
  
  enabledPvC = false;
  pickedCueBall = false;
  ballHitForce = 1000;
  playerScore = 0;
  computerScore = 0;
  ballMass = 1;
  gravity = new PVector(0, 100, 0);
  ballHitDirectionVec = new PVector (0,0,0);
  
  // Setup Arrays
  otherBalls = new ArrayList<SimSphereMover>();
  ballType = new ArrayList<Integer>();
  
  // Setup Main Ball
  ball = new SimSphereMover(vec(0,-14,0), 10.0f);
  ball.physics.mass = ballMass;
  ball.physics.frictionAmount = 0.3;
  otherBalls.add(ball);
  ballType.add(0);
  simObjectManager.addSimObject(ball, "ball");
  cueBallRay = new SimRay(ball.getOrigin(), PVector.add(ball.getOrigin(),vec(0,0,0)));
  
  // Setup Balls
  for (int i = 0; i < 15; i++) {
    float XLoc = random(-60, 60);
    float YLoc = -14;
    float ZLoc = random(-140, 140);
    
    SimSphereMover newBall = new SimSphereMover(vec(XLoc, YLoc, ZLoc), 10.0f);
    
    newBall.physics.radius = 10.0f;
    newBall.physics.velocity =  new PVector(0,0,0);
    newBall.physics.mass = ballMass;
    newBall.physics.frictionAmount = 0.3;
       
    otherBalls.add(newBall);
    
    if (0 <= i && i <= 6){
      ballType.add(1);
    } else if (7 <= i && i<= 13){
      ballType.add(2);
    }  else {
      ballType.add(3);
    } 
  }
}

void initUI(){
  // Setup UI
  gameUI = new SimpleUI();
  Widget w;
  
  gameUI.addToggleButton("PvC", 30, 30);
  w = gameUI.getWidget("PvC");
  w.setBounds(30, 30, 50, 30);
  gameUI.addTextDisplayBox("Turn", 90, 30, " Solo");
  w = gameUI.getWidget("Turn");
  w.setBounds(90, 30, 120, 30);
  
  gameUI.addToggleButton("Fan (L)", 30, 65);
  w = gameUI.getWidget("Fan (L)");
  w.setBounds(30, 65, 50, 30);
  gameUI.addSlider("Fan Strength (L)", 90, 65).setSliderValue(1);
  w = gameUI.getWidget("Fan Strength (L)");
  w.setBounds(90, 65, 120, 30);
  
  gameUI.addToggleButton("Fan (R)", 30, 100);
  w = gameUI.getWidget("Fan (R)");
  w.setBounds(30, 100, 50, 30);
  gameUI.addSlider("Fan Strength (R)", 90, 100).setSliderValue(1);
  w = gameUI.getWidget("Fan Strength (R)");
  w.setBounds(90, 100, 120, 30);
  
  gameUI.addToggleButton("Fan (T)", 30, 135);
  w = gameUI.getWidget("Fan (T)");
  w.setBounds(30, 135, 50, 30);
  gameUI.addSlider("Fan Strength (T)", 90, 135).setSliderValue(1);
  w = gameUI.getWidget("Fan Strength (T)");
  w.setBounds(90, 135, 120, 30);
  
  gameUI.addToggleButton("Fan (B)", 100, 170);
  w = gameUI.getWidget("Fan (B)");
  w.setBounds(30, 170, 50, 30);
  gameUI.addSlider("Fan Strength (B)", 90, 170).setSliderValue(1);
  w = gameUI.getWidget("Fan Strength (B)");
  w.setBounds(90, 170, 120, 30);
  
  gameUI.addTextDisplayBox("Player Score", 30, 210, " 0");
  w = gameUI.getWidget("Player Score");
  w.setBounds(30, 210, 180, 20);
  gameUI.addTextDisplayBox("Opponent Score", 100, 240, " 0");
  w = gameUI.getWidget("Opponent Score");
  w.setBounds(30, 240, 180, 20);
  
  gameUI.addSlider("Ball Force", 30, 270).setSliderValue(0.5);
  w = gameUI.getWidget("Ball Force");
  w.setBounds(30, 270, 180, 30);
  gameUI.addSlider("Ball Mass", 30, 305).setSliderValue(0.1);
  w = gameUI.getWidget("Ball Mass");
  w.setBounds(30, 305, 180, 30);
  gameUI.addSlider("Table Friction", 30, 340).setSliderValue(0.1);
  w = gameUI.getWidget("Table Friction");
  w.setBounds(30, 340, 180, 30);
  gameUI.addSlider("Gravity", 30, 375).setSliderValue(0.1);
  w = gameUI.getWidget("Gravity");
  w.setBounds(30, 375, 180, 30);
  
  gameUI.addSimpleButton("Restart", 30, 410);
  String[] styleMenuItems = {"Standard","Dracula","Icy"};
  gameUI.addMenu("Table Styles", 110, 410, styleMenuItems);
  
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
  
  fill(105,105,105);
  pocket1.drawMe();
  pocket2.drawMe();
  pocket3.drawMe();
  pocket4.drawMe();
  pocket5.drawMe();
  pocket6.drawMe();
  
  
  drawRay(cueBallRay, color(255,0,0));
  //println ("P: " + pickedCueBall, " E: " + enabledPvC, " M: " +(ball.physics.velocity.mag()));
  
  // Check if Computer is allowed to and capable of making the next move
  if (pickedCueBall && enabledPvC && (ball.physics.velocity.mag() <= 2)){
    float XForce = 5;
    float ZForce = 5;
    
    if (random(0, 10) > 4 ) { XForce = XForce * -1; }
    if (random(0, 10) > 4 ) { ZForce = ZForce * -1; }
    
    PVector computerHit = new PVector(XForce, 0, ZForce).mult(ballHitForce);
    //println("Computer Hit: " + computerHit);
    ball.physics.addForce(computerHit);
    
    gameUI.setText("Turn", " Player");
    pickedCueBall = false;
    
  }

  // Check for collisions with other balls
  for(int n = 0; n < otherBalls.size(); n++){
    SimSphereMover thisBall = otherBalls.get(n);
    SimSphereMover otherBall = findCollisionWithOtherBalls(thisBall,n);

    if(otherBall != null) {
      // if this ball collides with some other SimMover 
      thisBall.physics.collisionResponse(otherBall.physics);
      // Get Ambience Audio Setup
    }
    
    if(ballType.get(n) == 0){
      fill(255,255,255);
    } else if (ballType.get(n) == 1){
      fill(26,70,156);
    } else if (ballType.get(n) == 2){
      fill(192,15,15);
    } else{
      fill(0,0,0);
    }
 
    // Apply Gravitational Pull
    thisBall.physics.addForce(gravity);
    //println("Gravity: ", gravity);
 
    thisBall.physics.update();
    thisBall.physics.setMass(ballMass);
    thisBall.setRadius(thisBall.physics.radius);
    thisBall.drawMe();
    
    // Table Wall Collision
    wallCollisionChecks(thisBall);
    
    // Fan Radial Force Checks
    fanRadialForceChecks(thisBall);
    
    // Table Pocket Collision
    boolean removeBall = pocketCollisionChecks(thisBall);
    if (removeBall && n != 0){
      hitSFX = new SoundFile(this, "ballHitSFX.wav");
      
      if (ballType.get(n) == 1) {
        playerScore++;
        gameUI.setText("Player Score", " " + playerScore);
        hitSFX.play();
      } else if (ballType.get(n) == 2) {
        computerScore++;
        gameUI.setText("Opponent Score", " " + computerScore); 
        hitSFX.play();
      } else if (ballType.get(n) == 3 && !enabledPvC && otherBalls.size() > 2) {
        gameUI.setText("Player Score", " GAME OVER - LOST" ); 
        hitSFX.play();
      } else {
        println("Uh OH: " + ballType.get(n));
      }
      
      otherBalls.remove(n);
      ballType.remove(n);
    } else if (removeBall && n == 0 ) {
      thisBall.physics.velocity = new PVector(0,0,0);
      thisBall.physics.location = new PVector(0,-14,0);
    }
  }

  if (RFO_L.isActive){ fan_L.Rx += 0.1; fan_L.drawMe(); }
  if (RFO_R.isActive){ fan_R.Rx += 0.1; fan_R.drawMe(); }
  if (RFO_T.isActive){ fan_T.Rz += 0.1; fan_T.drawMe(); }
  if (RFO_B.isActive){ fan_B.Rz += 0.1; fan_B.drawMe(); }

  myCamera.update();
  myCamera.startDrawHUD();
  gameUI.update();
  myCamera.endDrawHUD();
  //drawMajorAxis(new PVector(0,0,0), 200); 
}

void drawRay(SimRay r, color c){
  PVector farPoint = r.getPointAtDistance(1000);
  pushStyle();  
  stroke(c); 
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
  updateMouseTrackerRay();
}

void mouseDragged(){
  updateMouseTrackerRay();
}

void mouseReleased(){
  updateMouseTrackerHit();
}

void updateMouseTrackerRay(){
  if(mouseButton == RIGHT) return;
  
  int totalObjs = simObjectManager.getNumSimObjects();
  
  for (int n = 0; n < totalObjs; n++){
    SimTransform obj = simObjectManager.getSimObject(n);
    SimRay mouseRay = myCamera.getMouseRay();
    mouseRay.setID("Mouse Ray");

    if(mouseRay.calcIntersection(obj)){
      PVector intersectionPoint = mouseRay.getIntersectionPoint();
      PVector ballPos = ball.physics.location;
      float dist = intersectionPoint.dist(ballPos);
      
      println("D: " + dist + " R" + ball.physics.radius);
      
      if (dist < ball.physics.radius + 5){
        ballHitDirectionVec = PVector.sub(ballPos, intersectionPoint);
        ballHitDirectionVec.y = 0;
        cueBallRay = new SimRay(ball.getOrigin(), PVector.add(ball.getOrigin(),ballHitDirectionVec));
      }
      break;
    } 
  }
}

void updateMouseTrackerHit(){
  if(mouseButton == RIGHT) return;
  
  int totalObjs = simObjectManager.getNumSimObjects();
  
  for (int n = 0; n < totalObjs; n++){
    SimTransform obj = simObjectManager.getSimObject(n);
    SimRay mouseRay = myCamera.getMouseRay();
    mouseRay.setID("Mouse Ray");

    if(mouseRay.calcIntersection(obj)){
      PVector intersectionPoint = mouseRay.getIntersectionPoint();
      PVector ballPos = ball.physics.location;
      float dist = intersectionPoint.dist(ballPos);
      
      if (dist < ball.physics.radius + 5){
        cueBallRay = new SimRay(ball.getOrigin(), PVector.add(ball.getOrigin(),vec(0,0,0)));
        ballHitDirectionVec.mult(ballHitForce);
        ball.physics.addForce(ballHitDirectionVec);
        
        pickedCueBall = true;
        if (enabledPvC){ gameUI.setText("Turn", "Computer"); }
      }
      break;
    } 
  }  
}


void keyPressed(){
  
  if(key == 'r'){
    myCamera.setPositionAndLookat(vec(-26.465195, -355.21072, 283.11923),vec(-26.465223, -354.4004, 282.53326));
  }

  if(key == 'c'){ 
     // toggle the camera isActive field
     myCamera.isMoving = !myCamera.isMoving;
  }

  if( myCamera.isMoving ){
    //println("camera pos ", myCamera.cameraPos, " looKat ", myCamera.cameraLookat);
    return;
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

boolean pocketCollisionChecks(SimSphereMover thisBall){
  if(thisBall.collidesWith(pocket1) ){
    return true;
  }
  if(thisBall.collidesWith(pocket2) ){
    return true;
  }
  if(thisBall.collidesWith(pocket3) ){
    return true;
  }
  if(thisBall.collidesWith(pocket4) ){
    return true;
  }
  if(thisBall.collidesWith(pocket5) ){
    return true;
  }
  if(thisBall.collidesWith(pocket6) ){
    return true;
  }
  
  return false;
}

void handleUIEvent(UIEventData  uied){
  uied.print(0);
  
  // Reset Game
  if(uied.eventIsFromWidget("Restart") ){   
    init();
    gameUI.setText("Player Score", " " + playerScore); 
    gameUI.setText("Opponent Score", " " + computerScore);
    gameUI.setText("Turn", "Solo");
    enabledPvC = false;
  }
  
  // Toggle PvC
  if(uied.eventIsFromWidget("PvC") ){   
    enabledPvC = !enabledPvC;
    
    if (!enabledPvC) {
      gameUI.setText("Turn", "Solo");
    } 
    else { 
      gameUI.setText("Turn", " "); 
    }
  }
  
  // Set Table Friction Value
  if(uied.eventIsFromWidget("Table Friction") ){
    float frictionVal = uied.sliderValue * 2;
    tableBase.physics.frictionAmount = frictionVal;
  }
  
    // Set Gravity Value
  if(uied.eventIsFromWidget("Gravity") ){
    if (uied.sliderValue <= 0.5) {
      gravity = new PVector(0, -100, 0);
    } else {
      gravity = new PVector(0, 100, 0);
    }     
  }
  
  // Set Ball Hit Force Value
  if(uied.eventIsFromWidget("Ball Force") ){
    ballHitForce = uied.sliderValue * 2000;
  }
  
  // Set Ball Mass Value
  if(uied.eventIsFromWidget("Ball Mass") ){
    if (uied.sliderValue * 2 < 1){ ballMass = 1;}
    else {ballMass = uied.sliderValue * 2; }
    //println("New Mass: " + ballMass);
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
