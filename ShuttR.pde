import netP5.*;
import oscP5.*;
import java.net.*;

Settings settings;
Keyboard keyboard;

String name = "ShuttR Cut OSC";
String version = "v0.5.0 (ALPHA)";

float centerX, centerY, assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
int assemblyDiameter;
float rotation = radians(0);

PImage IMGSplash, IMGEncoder;

void variableInit() {
  clickDiameter = width / 9.6; //150
  clickRadius = clickDiameter / 2;
  encoderDiameter = width / 6;
  float screenAdjust = (float(height) / float(width) - 1);
  assemblyDiameter = int(width - int(clickDiameter + (clickRadius / 2)) / screenAdjust);
  //assemblyDiameter = width - int(clickDiameter + (clickRadius / 2));
  assemblyRadius = assemblyDiameter / 2;
  thrustDiameter = assemblyRadius - clickDiameter;
  centerX = width / 2;
  centerY = height - assemblyDiameter + assemblyRadius / 3;
}

void setup() {
  fullScreen(); //PIXEL DIMENSIONS = 1440 x 2960
  settings = new Settings(this);
  keyboard = new Keyboard();
  //size(480, 986); //2
  //size(480, 854); //1.77
  //size(480, 800); //1.6
  imageMode(CENTER);
  variableInit();
  oscP5tcpServer = new OscP5(this, 3032, OscP5.TCP);
  oscP5tcpClient = new OscP5(this, "", 3032, OscP5.TCP);
  IMGSplash = loadImage("icon-512.png");
  IMGEncoder = loadImage("Encoder.png");
  page1.frameAssemblyInit();
  guiInit();
  gui.page1Menu = true;
}

void draw() {
  background(EOSBackground);
  if (millis() < 7500) { //7500
    image(IMGSplash, width / 2, height / 4, width / 1.5, width / 1.5);
    settings.about();
    settings.startup();
  } else {
    if (gui.settingsMenu) {
      guiDraw();
      settings.draw();
    } else if (gui.page1Menu) {
      page1.show();
      guiDraw();
    } else if (gui.page2Menu) {
      page2.show();
      guiDraw();
    } else if (gui.page3Menu) {
      page3.show();
      guiDraw();
    }
    eventTimer();
    keyboard.show();
  }
}
