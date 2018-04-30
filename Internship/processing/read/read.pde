import processing.serial.*;
Serial myPort;  // Create object from Serial class

String incomingMsg;
int[] values = new int[6];
boolean flag = false;

void setup() 
{
  size(200, 200);
  
  String portName = "COM3";
  myPort = new Serial(this, portName, 9600);
  
  frameRate(60);
}



void draw()
{
  if(myPort.available()>0)
  {
      incomingMsg = myPort.readStringUntil(13);
      flag = true; 
  }
  
  if(flag && incomingMsg != null && incomingMsg != "No radio available")
  {
    println(incomingMsg);
    //println(split(incomingMsg, ','));
    //values = int(split(incomingMsg, ','));
    //println(values);
  }
}



