PImage mapImage;
import processing.serial.*;
import cc.arduino.*;
import eeml.*;
import pachuino.*;

Pachuino p;

void setup() {
  size(200, 400);
  mapImage = loadImage("lightboxes.png");
    p = new Pachuino(this, Arduino.list()[0], 57600);
    p.manualUpdate("http://www.pachube.com/api/35152.xml");
    p.setKey("iiKTx_Gwh1U32YVmQ-eaymM_LE81P3dZ8FYlKqckHvs");  
       
      p.addLocalSensor("analog", 0, "tempSensor1");
      p.addLocalSensor("analog", 1, "tempSensor2");
      p.addLocalSensor("analog", 2, "tempSensor3");
      
}

void draw(){
   float tempVal1 = p.localSensor[0].value;
   float tempVal2 = p.localSensor[1].value;
   float tempVal3 = p.localSensor[2].value;
   
    print(tempVal1);
    print(",");
    print(tempVal2);
    print(",");
    println(tempVal3);
   
    background(255);
    image(mapImage, 0, 0);
    
    ellipseMode(CENTER);
    ellipse(100, 70, 100, 100);    
    fill(200);
   
    ellipse(100, 200, 100, 100);    
    fill(100);
    
    ellipse(100, 320, 100, 100);
    fill(50);  
}

void onReceiveRequest(DataOut d){
    p.updateLocalSensors(d);
}

