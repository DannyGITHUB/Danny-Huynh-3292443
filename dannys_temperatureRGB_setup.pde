// Danny Huynh's Temperature RGB LED setup
// Based on code taken from Circuit 10 in Sparksfun Circuit to read and print temperature output.
// http://ardx.org/CODE10
// Copyright 2011 : Danny Huynh, z3292443, UNSW

//TMP36 Pin Variables
int temperaturePin = 0; //the analog pin the TMP36's Vout (sense) pin is connected to
                        //the resolution is 10 mV / degree centigrade 
                        //(500 mV offset) to make negative temperatures an option

/*
 * setup() - this function runs once when you turn your Arduino on
 * We initialize the serial connection with the computer
 */
 
 // This is a modification to the code, I have added a RGB LED component to the board.
 // These variables will assign a different colour to each pin of the RGB LED.
 // LED leads connected to PWM pins
const int RED_LED_PIN = 9;  // Sets LED pin 9 to colour red
const int GREEN_LED_PIN = 10;  // Sets LED pin 10 to colour green
const int BLUE_LED_PIN = 11;  // Sets LED pin 11 to colour blue

// Here I have modified the original code by adding some temperature range variables
// these variables will set a limit for temperature readings from the TMP36 component.

int MaxTemp = 40;    // The max temperature range limit the sensor will peak at
int MinTemp = 10;    // The minimum temperature range limit the sensor will peak
int sensorValue = 0; // Value output given by the sensor
int smoothing = 4;   // Smoothing function variable used from: http://www.arduino.cc/en/Tutorial/Smoothing

void setup()
{
  Serial.begin(9600);  //Start the serial connection with the copmuter
                       //to view the result open the serial monitor 
                       //last button beneath the file bar (looks like a box with an antenae)
}
 
void loop()                     // run over and over again
{
 float temperature = getVoltage(temperaturePin);  //getting the voltage reading from the temperature sensor
 temperature = (temperature - .5) * 100;          //converting from 10 mv per degree wit 500 mV offset
                                                  //to degrees ((volatge - 500mV) times 100)
 //Serial.println(temperature);                     //printing the result
 
 
 // Smoothing function added in to help fade RGB light colours
 // Source taken from : http://www.arduino.cc/en/Tutorial/Smoothing
 // This is used to prevent colour changing to spike so inconsistently.
 // Equation demonstrates a gradual process of gain rather dramatic shifting values.
 
 sensorValue = ((sensorValue * smoothing) + temperature)/(smoothing+1);
 temperature = sensorValue;
 
 // At this point we have temperature in C
 // we map it to 0 to 360 hue
  // Play with the saturation and brightness values
  // to see what they do
  
  float saturation = 1; // Between 0 and 1 (0 = gray, 1 = full color)
  float brightness = 1; // Between 0 and 1 (0 = dark, 1 is full brightness)
  float hue = map(temperature, MinTemp, MaxTemp, 200, 360);
  hue = constrain(hue, 0, 360);
  //float hue = (colorNumber / float(numColors)) * 360; // Number between 0 and 360
  long color = HSBtoRGB(hue, saturation, brightness);
  Serial.print(temperature);
   Serial.print(",");
  Serial.print(hue);
   Serial.print(",");
  Serial.println(sensorValue);
  

  // Get the red, blue and green parts from generated color
  int red = color >> 16 & 255;
  int green = color >> 8 & 255;
  int blue = color & 255;

// Assigning a colour to each PIN of the RGB light component.
 analogWrite(GREEN_LED_PIN, green);
 analogWrite(RED_LED_PIN, red);
 analogWrite(BLUE_LED_PIN, blue);

 delay(200);                                     //waiting a second
}

/*
 * getVoltage() - returns the voltage on the analog input defined by
 * pin
 */
float getVoltage(int pin){
 return (analogRead(pin) * .004882814); //converting from a 0 to 1024 digital range
                                        // to 0 to 5 volts (each 1 reading equals ~ 5 millivolts

}

// The following code used below was sourced from Action Script;
// http://www.actionscript.org/forums/showthread.php3?t=15155
// Code functions as a converter for changing a hue, saturation and brightness 

long HSBtoRGB(float _hue, float _sat, float _brightness) {
    float red = 0.0;
    float green = 0.0;
    float blue = 0.0;
    
    if (_sat == 0.0) {
        red = _brightness;
        green = _brightness;
        blue = _brightness;
    } else {
        if (_hue == 360.0) {
            _hue = 0;
        }

        int slice = _hue / 60.0;
        float hue_frac = (_hue / 60.0) - slice;

        float aa = _brightness * (1.0 - _sat);
        float bb = _brightness * (1.0 - _sat * hue_frac);
        float cc = _brightness * (1.0 - _sat * (1.0 - hue_frac));
        
        switch(slice) {
            case 0:
                red = _brightness;
                green = cc;
                blue = aa;
                break;
            case 1:
                red = bb;
                green = _brightness;
                blue = aa;
                break;
            case 2:
                red = aa;
                green = _brightness;
                blue = cc;
                break;
            case 3:
                red = aa;
                green = bb;
                blue = _brightness;
                break;
            case 4:
                red = cc;
                green = aa;
                blue = _brightness;
                break;
            case 5:
                red = _brightness;
                green = aa;
                blue = bb;
                break;
            default:
                red = 0.0;
                green = 0.0;
                blue = 0.0;
                break;
        }
    }

    long ired = red * 255.0;
    long igreen = green * 255.0;
    long iblue = blue * 255.0;
    
    return long((ired << 16) | (igreen << 8) | (iblue));
} 



