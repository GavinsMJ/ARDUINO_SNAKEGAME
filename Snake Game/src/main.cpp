/*
    Arduino SNAKE Game Controller

     BY: GAVINS MARAGIA
     
    Connect joystick x and y axes to pins A0 AND A1
         push button to pin 2
         get the com port and write it in the processing file before run 
                                            
                                                                HAVE FUN
*/


#include <Arduino.h>

// Defining variables
  
  //JOYSTICK CONNECTIONS
  const int pinX = A0;
  const int pinY = A1;
  const int RESPIN = 2;
  
  bool reset = false;
  int RESETState = HIGH;              // the current RESET state
  int buttonState = HIGH;             // the current Reading from the input pin
  
  unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
  unsigned long debounceDelay = 100;    // the debounce time; increase if the output flickers

void send_info(){
  // reads the JOYSTICK Inputs 
  // and sends all readings via Serial to pc 
  
  int valX = analogRead(pinX);   
  Serial.print(valX);     
  Serial.print(",");    
  
  int valY = analogRead(pinY);
  Serial.print(valY);
  Serial.print("/");

  Serial.print(RESETState);

  Serial.print(".");
  
  }


void setup()
{
  Serial.begin(115200);     // starts the serial communication
  pinMode(2, INPUT_PULLUP);
}

void loop()
{

  int Reading = digitalRead(RESPIN);
  if (Reading != HIGH) {
    // reset the debouncing timer
    if (reset == false) {
      RESETState = 0;
      lastDebounceTime = millis();
      reset = true;
    } else {
      RESETState = 1;
    }
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // The Reading is longer than the debounce
    // delay, change reset status if button has been letgo

    if (Reading == HIGH) {
      reset = false;
    }

  }
   
   send_info();
 
  delay(30);
}



                                                         /*HAVE FUN*/
                                                                //GM