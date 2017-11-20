import netP5.*;
import oscP5.*;
import processing.serial.*;
import controlP5.*;

ControlP5 controlP5;

Serial serial;

Channel[] channels = new Channel[11];
Monitor[] monitors = new Monitor[10];
Graph graph;
ConnectionLight connectionLight;

int packetCount = 0;
int globalMax = 0;
String scaleMode;
int index = 0;
int[] packet = new int[256];

 
void setup() {
  // Set up window
  size(1024, 768);
  frameRate(60);
  smooth();
  surface.setTitle("Rama's Visualizer");  

  // Set up serial connection
  println("Find the headset serial port in the list below, note its [index]:\n");
  
  for (int i = 0; i < Serial.list().length; i++) {
    println("[" + i + "] " + Serial.list()[i]);
  }
  
  // Put the index found above here:
  serial = new Serial(this, Serial.list()[3], 9600);

  serial.bufferUntil(10);
  delay(1000);

  // Set up the ControlP5 knobs and dials
  controlP5 = new ControlP5(this);
  
  controlP5.setColorValueLabel(color(0));
  controlP5.setColorCaptionLabel(color(0)); 
  controlP5.setColorBackground(color(0));
  controlP5.disableShortcuts(); 
  controlP5.setMouseWheelRotation(0);
  controlP5.setMoveable(false);
  // Create the channel objects
 channels[0] = new Channel("Signal Quality", color(0), "");
  channels[1] = new Channel("Attention", color(182,36,79), "");
  channels[2] = new Channel("Meditation", color(251,183,192), "");
  channels[3] = new Channel("Delta", color(255,180,163), "Dreamless Sleep");
  channels[4] = new Channel("Theta", color(222,197,227), "Drowsy");
  channels[5] = new Channel("Low Alpha", color(205,237,253), "Relaxed");
  channels[6] = new Channel("High Alpha", color(182,220,254), "Relaxed");
  channels[7] = new Channel("Low Beta", color(169,248,251), "Alert");
  channels[8] = new Channel("High Beta", color(129,247,229), "Alert");
  channels[9] = new Channel("Low Gamma", color(189,228,167), "Multi-sensory processing");
  channels[10] = new Channel("High Gamma", color(255,253,152), "???");

  // Manual override for a couple of limits.
  channels[0].minValue = 0;
  channels[0].maxValue = 200;
  channels[1].minValue = 0;
  channels[1].maxValue = 100;
  channels[2].minValue = 0;
  channels[2].maxValue = 100;
  channels[0].allowGlobal = false;
  channels[1].allowGlobal = false;
  channels[2].allowGlobal = false;

  // Set up the monitors, skip the signal quality
  for (int i = 0; i < monitors.length; i++) {
    monitors[i] = new Monitor(channels[i + 1], i * (width / 10), height / 2, width / 10, height / 2);
  }

  monitors[monitors.length - 1].w += width % monitors.length;

  // Set up the graph
  graph = new Graph(0, 0, width, height / 2);

  // Set up the connection light
  connectionLight = new ConnectionLight(width - 140, 10, 20);
}

void draw() {
  // Keep track of global maxima
  if (scaleMode == "Global" && (channels.length > 3)) {
    for (int i = 3; i < channels.length; i++) {
      if (channels[i].maxValue > globalMax) globalMax = channels[i].maxValue;
    }
  }

  // Clear the background
  background(255);

  // Update and draw the main graph
  graph.update();
  graph.draw();

  // Update and draw the connection light
  connectionLight.update();
  connectionLight.draw();

  // Update and draw the monitors
  for (int i = 0; i < monitors.length; i++) {
    monitors[i].update();
    monitors[i].draw();

  }
}

void serialEvent(Serial p) {
packetCount++;
int generatedChecksum = 0; 
for (int i = 0; i < 4; i++){
  packet[i] = p.read();
  generatedChecksum += packet[3];
  generatedChecksum += packet[4];
  generatedChecksum += packet[5];
  generatedChecksum += packet[6];
 int checksum = packet[7];
  generatedChecksum = 255 - checksum;   //Take one's compliment of generated checksum
 if (checksum == generatedChecksum) { println("checksum valid");}
 
}


}



  
  



   //<>//



 

// Utilities

// Extend Processing's built-in map() function to support the Long datatype
long mapLong(long x, long in_min, long in_max, long out_min, long out_max) { 
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

// Extend Processing's built-in constrain() function to support the Long datatype
long constrainLong(long value, long min_value, long max_value) {
  if (value > max_value) return max_value;
  if (value < min_value) return min_value;
  return value;
}