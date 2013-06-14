import SimpleOpenNI.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

SimpleOpenNI context;
int[] map;
int[] lastMap;
Minim minim;
AudioOutput out;

void setup() {
  frameRate(20);
  size(640, 480);
  context = new SimpleOpenNI(this);
  context.setMirror(false);
  
  minim = new Minim(this);
  out = minim.getLineOut();
  
  if(context.enableDepth() == false) {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  smooth();
}

void draw() {
  background(0,0,0);
  int steps = 100;
  int index;
  
  context.update();
  map = context.depthMap();
  for(int y=0; y < context.depthHeight(); y+=steps){
    for(int x=0; x < context.depthWidth(); x+=steps) {
      index = x + y * context.depthWidth();
      if (lastMap != null) {
        int d = map[index];
        int p = lastMap[index];
        if (p - d > 1000) {
          println(p - d);
          set(x, y, color(255, 0, 0));
          float freq = map(index, 0, map.length, 440, 800);
          out.playNote(0, 0.3, freq); 
        }
      }
    }
  }
  lastMap = new int[map.length];
  arrayCopy(map, lastMap);
}
