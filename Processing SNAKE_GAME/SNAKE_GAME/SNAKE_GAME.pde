/*
    Snake Game 

     GET THE CONTROLLER PORT i.e (COM..)//(dev/tty...)  AND REPLACE IT ON LINE 41 
     HAVE FUN
*/

import processing.serial.*;
import java.awt.event.KeyEvent; 
import java.io.IOException;

Serial port;  

String Serial_data= "";


int index=0;
int index2=0;

String X_axis = "";
String Y_axis = "";
String r_button= "";

int IUPDO = 500;
int ISIDE = 500;
int IRESET = 1;

int angle=0;
int snakesize=5;
int time=0;
int[] headx= new int[2500];
int[] heady= new int[2500];
int applex=(round(random(72))+1)*8;
int appley=(round(random(72))+1)*8;
boolean redo=true;
boolean stopgame=false;


void setup()
{  
  port = new Serial(this,"COM12", 115200); // starts the serial communication
  port.bufferUntil('.'); // reads the data from the serial port from controller
  delay(500); 
  
  restart();
  size(600,600);
  textAlign(CENTER);
  
}

void draw()
{
  
  CHECK_B();
  
  if (stopgame)
  {
    //game over
  }
  else
  { 
    //draw stationary stuff
  time+=1;
  fill(255,0,0);
  stroke(0);
  rect(applex,appley,8,8);
  fill(0);
  stroke(0);
  rect(0,0,width,8);
  rect(0,height-8,width,8);
  rect(0,0,8,height);
  rect(width-8,0,8,height);
  //BY modulating time by 5, we create artificial frames each 5 frames
  //(game speed basically)
  if ((time % 5)==0)
  {
    CHECK_B();
    travel();
    display();
    checkdead();
  
  }
  }
  
}
//controls:
void keyPressed()
{
  
  
  if (key == CODED)
  {
    //what key was pressed? is the previous angle the opposite direction?
    //we wouldn't want to go backwards into our body, that would hurt!
    //also, is the previous body segment in front of the direction? 
    //(based on the previous question, but added for secure turning without suicide)
    if (keyCode == UP && angle!=270 && (heady[1]-8)!=heady[2])
    {
      angle=90;
    }
    if (keyCode == DOWN && angle!=90 && (heady[1]+8)!=heady[2])
    {
      angle=270;
    }if (keyCode == LEFT && angle!=0 && (headx[1]-8)!=headx[2])
    {
      angle=180;
    }if (keyCode == RIGHT && angle!=180 && (headx[1]+8)!=headx[2])
    {
      angle=0;
    }
    if (keyCode == SHIFT)
    {
      //restart the game by pressing shift
      restart();
    }
     
  }
 
}

 //ARDUINO CONTROL
  
 void CHECK_B()
 {

 //////////UP-DOWN//////////////
   
    if(IUPDO >= 1000 && angle!=270 && (heady[1]-8)!=heady[2])
  { 
     angle=90;
   }
if(IUPDO <= 30  && angle!=90 && (heady[1]+8)!=heady[2])
{
 angle=270;
 }
  ////////RIGHT-LEFT/////////////
  
   if(ISIDE > 1000 && angle!=180 && (headx[1]+8)!=headx[2])
{ 
  angle=0;
 }

if(ISIDE <= 30 && angle!=0 && (headx[1]-8)!=headx[2])
{
 angle=180;
 }
    //////////BUTTON/////////
  
    if(IRESET == 0)
{ //restart the game by pressing reset button
      restart();
 }
 
 
 
 }
  
  

void travel()
{
  for(int i=snakesize;i>0;i--)
  {
    if (i!=1)
    {
      //shift all the coordinates back one array
      headx[i]=headx[i-1];
      heady[i]=heady[i-1];
    }
    else
    {
      
      switch(angle)
      {
        case 0:
        headx[1]+=8;
        break;
        case 90:
        heady[1]-=8;
        break;
        case 180:
        headx[1]-=8;
        break;
        case 270:
        heady[1]+=8;
        break;
      }
    }
  }
  
}
void display()
{
  
  if (headx[1]==applex && heady[1]==appley)
  {
       snakesize+=round(random(3)+1);
    redo=true;
    while(redo)
    {
      applex=(round(random(72))+1)*8;
      appley=(round(random(72))+1)*8;
      for(int i=1;i<snakesize;i++)
      {
        
        if (applex==headx[i] && appley==heady[i])
        {
          redo=true;
        }
        else
        {
          redo=false;
          i=1000;
        }
      }
    }
  }
  stroke(sinecolor(1),sinecolor(0),sinecolor(.5));
  fill(0);
  rect(headx[1],heady[1],8,8);
  fill(255);
  rect(headx[snakesize],heady[snakesize],8,8);
  
}
void checkdead()
{
  for(int i=2;i<=snakesize;i++)
  {
    if (headx[1]==headx[i] && heady[1]==heady[i])
    {
      fill(255);
      rect(225,225,160,100);
      fill(0);
      text("GAME OVER",300,250);
      text("Score:  "+str(snakesize-1)+" units long",300,275);
      text("To restart, press reset.",300,300);
      stopgame=true;
    }
    //is the head of the snake hitting the walls?
    if (headx[1]>=(width-8) || heady[1]>=(height-8) || headx[1]<=0 || heady[1]<=0)
    {
      fill(255);
      rect(225,225,160,100);
      fill(0);
      text("GAME OVER",300,250);
      text("Score:  "+str(snakesize-1)+" units long",300,275);
      text("To restart, press reset.",300,300);
      stopgame=true;
    }
  }
}
void restart()
{
  
  background(255);
  headx[1]=200;
  heady[1]=200;
  for(int i=2;i<1000;i++)
  {
    headx[i]=0;
    heady[i]=0;
  }
  stopgame=false;
  applex=(round(random(72))+1)*8;
  appley=(round(random(72))+1)*8;
  snakesize=5;
  time=0;
  angle=0;
  redo=true;
}
float sinecolor(float percent)
{
  float slime=(sin(radians((((time +(255*percent)) % 255)/255)*360)))*255;
  return slime;
}




void serialEvent (Serial port) // reading data from the Serial Port
{
try {
   
Serial_data = port.readStringUntil('.'); // reads the data from the serial port up to the character '.'
Serial_data = Serial_data.substring(0,Serial_data.length()-1); // remove the '.' from the previous read.

// Filtering data from incoming Serial data
index = Serial_data.indexOf(","); 
X_axis = Serial_data.substring(0, index); 

index2 = Serial_data.indexOf("/"); 
Y_axis = Serial_data.substring(index+1, index2); 

r_button = Serial_data.substring(index2+1, Serial_data.length());

// Converting the String variables values into Integer values
IUPDO  = int(X_axis);
ISIDE  = int(Y_axis);
IRESET = int(r_button);
  }
  catch(RuntimeException e) {
    e.printStackTrace();
  }
}
                                                                   /*GM 
                                                                      HAVE FUN
                                                                             ^^*/
