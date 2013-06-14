import SimpleOpenNI.*;
import themidibus.*;

SimpleOpenNI context;
int kinectWidth;
int kinectHeight;
int[] map;
int[] lastMap;
MidiBus myBus;

void setup() {
  frameRate(20);
  size(640, 480);
  context = new SimpleOpenNI(this);
  context.setMirror(false);
  
  myBus.list();
  myBus = new MidiBus(this, -1, "Java Sound Synthesizer");
  
  if(context.enableDepth() == false) {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  kinectWidth = context.depthWidth();
  kinectHeight = context.depthHeight();
}

void draw() {
  background(0,0,0);
  int steps = 80;
  int index;
  
  context.update();
  map = context.depthMap();
  for(int y=0; y < kinectHeight; y+=steps){
    for(int x=0; x < kinectWidth; x+=steps) {
      index = x + y * kinectWidth;
      if (lastMap != null) {
        int d = map[index];
        int p = lastMap[index];
        if (p - d > 3000) {
          set(x, y, color(255, 0, 0));
          int channel = 0;          
          int pitch = (int) map(x, 0, kinectWidth, 30, 110);
          int velocity = (int) map(p - d, 0, 4500, 0, 255);
          println(pitch);
          myBus.sendNoteOn(channel, pitch, velocity);
          
          myBus.sendControllerChange(0, 0, 90); 
        }
      }
    }
  }
  lastMap = new int[map.length];
  arrayCopy(map, lastMap);
  image(context.depthImage(), 0, 0);
}
