SimSurfaceMesh terrain; 
SimSphereMover ball1;
SimBoxMover box1;

SimCamera myCamera;

void setup(){
  size(900, 700, P3D);
  
  
  ////////////////////////////
  // create the SimCamera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(  -66.66498, -37.02684, 175.28958),vec(-66.19523, -37.103973, 174.41016)); 
  myCamera.isMoving = false;
  
  
  ////////////////////////////
  // add a terrian, made from 20x20 facets, each 20 units in size
  // shifted so that it is centered around the scene's origin
  terrain = new SimSurfaceMesh(20, 20, 20.0);
  terrain.setTransformAbs( 1, 0,0,0, vec(-200,0,-200));
  
  
  ball1 = new SimSphereMover(vec(40,-100,40), 8.0f);
  box1 = new SimBoxMover(vec(40, -100, 40), vec(10,10,10), vec(20,20,20));
  
}


void draw(){
  background(0);
  lights();
  
  // draw the 3d stuff
  stroke(255,255,255);
  fill(150,200, 150 );
  noStroke();
  terrain.drawMe(); 

  fill(255,0,0);
  //ball1.drawMe();
  
  box1.drawMe();
  
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
    // away from the user
    moveObject(0,0, -force);
    }
  
  if(key == 's'){
    // towards the user
    moveObject(0,0,force);
    }
  
  if(key == CODED){
    if(keyCode == LEFT){
      moveObject(-force,0,0);
      }
    if(keyCode == RIGHT){ 
     moveObject(force,0,0);
      }
    if(keyCode == UP){
      moveObject(0,-force, 0);
      }
     if(keyCode == DOWN){
      moveObject(0,force, 0);
       }  
    }
}

void moveObject(float x, float y, float z){
 
  PVector force = new PVector(x, y, z);
  
  //ball1.physics.addForce(force);
  box1.physics.addForce(force);
}

void handleUIEvent(UIEventData  uied){}
