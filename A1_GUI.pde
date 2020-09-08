GUIClass gui = new GUIClass();
page1Class page1 = new page1Class();
page2Class page2 = new page2Class();
page3Class page3 = new page3Class();

float settingsBarHeight, settingsBarStrokeWeight, buttonCorner, smallButtonWidth, activeChannelWidth, row1Padding, genericButtonWidth, plusMinusButtonWidth, row2Padding, row3Padding,
row4Padding, guiLeftAlign, guiCenterAlign, guiRightAlign, buttonHeight, buttonStrokeWeight, largeTextSize, mediumTextSize, smallTextSize, tinyTextSize, parameterButtonWidth, row5Padding,
consoleWidth, consoleHeight, consolePadding;
boolean oscPackageSendLight = false;
boolean oscPackageReceiveLight = false;

float channelFlashIntensity;

void guiInit() {
  //1440 x 2960
  guiLeftAlign = centerX - centerX / 1.5;
  guiCenterAlign = centerX;
  guiRightAlign = centerX + centerX / 1.5;
  buttonHeight = height / 19.7;
  settingsBarHeight = height / 20;
  settingsBarStrokeWeight = 5;
  smallButtonWidth = width / 10;
  activeChannelWidth = (width / 4.5) * 1.5;
  plusMinusButtonWidth = width / 6;
  genericButtonWidth = width / 4.5;
  parameterButtonWidth = genericButtonWidth / 1.25;
  buttonCorner = width / 57.6;
  buttonStrokeWeight = width / 144;
  row1Padding = settingsBarHeight + buttonHeight;
  row2Padding = row1Padding + height / 11.84;
  row3Padding = row2Padding + height / 11.84;
  row4Padding = row3Padding + buttonHeight / 2;
  row5Padding = height - height / 15;
  consoleWidth = width / 1.25;
  consoleHeight = height / 20;
  consolePadding = height / 2;

  largeTextSize = width / 19.2; //75
  mediumTextSize = width / 22.15; //65
  smallTextSize = width / 32; //45
  tinyTextSize = width / 57.6; //25
}

void guiDraw() {
  guiBackground();
  gui.show();
  handleOSC.oscLightTimer();
}

void guiBackground() {
  push();
  stroke(black);
  fill(EOSDarkGrey);
  rect(0, 0, width, settingsBarHeight);
  stroke(shutterOutsideStroke);
  strokeWeight(settingsBarStrokeWeight);
  line(0, settingsBarHeight + settingsBarStrokeWeight / 2, width, settingsBarHeight + settingsBarStrokeWeight / 2);
  pop();
}