import processing.serial.*;
import cc.arduino.*;
import fullscreen.*;
import ddf.minim.*;

static final int[] PINS = {0, 1, 2, 3};
static final int MAX_PARTICLES = 25;

final Point[] POINTS = new Point[] {
  new Point(100, 0),
  new Point(100, 800),
  new Point(700, 800),
  new Point(700, 0),
};

Arduino arduino;

String[] files = new String[] {
  "ako_pon1.mp3",
  "niwaka.mp3",
  "subara1.mp3",
  "wahaha1.mp3",
  "harbest_time.mp3",
};

Minim minim;
AudioPlayer[] songs = new AudioPlayer[files.length];

ArrayList<Particle> particles = new ArrayList<Particle>();

HashMap<Integer, Boolean> isPause = new HashMap<Integer, Boolean>();

void setup() {
  size(800, 800);
  arduino = new Arduino(this, Arduino.list()[5], 57600);
  minim = new Minim(this);
  
  for (int i=0; i<files.length; i++) {
    songs[i] = minim.loadFile(files[i]);
  }
  
  new FullScreen(this).enter();
  
  for (int pin : PINS) {
    arduino.pinMode(pin, Arduino.INPUT);
    isPause.put(pin, true);
  }
    

//  arduino.pinMode(1, Arduino.INPUT);
}

void draw() {
    fill(0,0,0,210);
    rect(100, 0 ,700, height);
  
  for (int pin : PINS) {
    int sensorValue = arduino.analogRead(pin);
    int ts = 20;
    println("sensorValue"+pin+" : " + sensorValue);
    if (sensorValue > ts) {
      onSwitchPressed(pin);
      isPause.put(pin, true);
      break;
    } else {
      isPause.put(pin, false);
    }
  }
  
  
//    int sensorValue = arduino.analogRead(1);
//    if (sensorValue > 30) {
//      onSwitchPressed(1);
//      isPause = true;
//    } else {
//      isPause = false;
//    }
//  
    for (Particle p : particles) {
      p.draw();
    }
  
}

void stop () {
  for (AudioPlayer song : songs) {
    song.close();
  }
  
  minim.stop();
  super.stop();
}

void onSwitchPressed (int switchId) {
  
  if (isPause.get(switchId)) return ;
  isPause.put(switchId, true);
  
  for (AudioPlayer song : songs) {
    song.rewind();
  }
  
  int mId = (int)random(files.length);
  songs[mId].play();
  
  particles.clear();
  
  int r = (int) random(100, 255);
  int g = (int) random(100, 255);
  int b = (int) random(100, 255);
  for (int i=0; i<MAX_PARTICLES; i++) {
    int x = (int)(random(POINTS[switchId].x - 25, POINTS[switchId].x + 25));
    int y = (int)(random(POINTS[switchId].y - 25, POINTS[switchId].y + 25));
    
    float lower = switchId * PI/2;
    float upper = (switchId+1) * PI/2;
    float rotate = random(lower, upper);
    
    Particle p = new Particle(x, y, rotate);
    p.setColor(r, g, b);
    particles.add(p);
  }
  
}


