PImage mapImage;
import processing.serial.*;
import cc.arduino.*;
import eeml.*;
import pachuino.*;

Pachuino p;

void setup() {
  size(200, 400);
  mapImage = loadImage("lightboxes.png");
   // p = new Pachuino(this, Arduino.list()[0], 115200);   
   // p.setPort(5230);  
   // p.setKey("iiKTx_Gwh1U32YVmQ-eaymM_LE81P3dZ8FYlKqckHvs");  
    
   // local sensors  
   //  for (int i = 0; i < 16; i++) {
   //   p.addLocalSensor("analog", i,"local"+i);
      
    // Color mode taken from "Hue" example
    colorMode(HSB, 360, height, height);
    // }
}

void draw(){
   // float tempVal1 = p.localSensor[3].value;
    background(255);
    image(mapImage, 0, 0);
    
    ellipseMode(CENTER);
    ellipse(100, 70, 100, 100);
    ellipse(100, 200, 100, 100);
    ellipse(100, 320, 100, 100);
    
}

void onReceiveRequest(DataOut d){
    p.updateLocalSensors(d);
}
