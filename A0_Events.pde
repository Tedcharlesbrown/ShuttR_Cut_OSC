boolean tap = false;
boolean doubleTap = false;
boolean holdStart = false;
float tapTimer, holdTimer;

//------------------------------------------------CLICK EVENTS----------------------------------------------

void mousePressed() {
  eventInit();
  if (gui.page1Menu && !gui.settingsMenu) {
    thrustA.mousePressed(); thrustB.mousePressed(); thrustC.mousePressed(); thrustD.mousePressed();
    angleA.mousePressed(); angleB.mousePressed(); angleC.mousePressed(); angleD.mousePressed();
    frameAssembly.mousePressed();
  } else if (gui.page3Menu && !gui.settingsMenu) {
    page3.mousePressed();
  }
  keyboard.mousePressed();
  gui.mousePressed();
  settings.mousePressed();
}

void eventTimer() {
  if (tap) {
    if (millis() > tapTimer + 350) {
      tap = false;
    }
  }
  if (holdStart) {
    if (millis() > holdTimer + 1000) {
      mouseHeld();
    }
  }
}

void eventInit() {
  if (tap) {
    doubleClicked();
    tap = false;
  } else {
    tap = true;
    tapTimer = millis();
  }
  holdTimer = millis();
  holdStart = true;
}

void mouseHeld() {
  if (gui.page3Menu && !gui.settingsMenu) {
    page3.mouseHeld();
  }
}

void doubleClicked() {
  if (gui.page1Menu && !gui.settingsMenu) {
    thrustA.thrustSliderA.doubleClicked(); thrustB.thrustSliderB.doubleClicked(); thrustC.thrustSliderC.doubleClicked(); thrustD.thrustSliderD.doubleClicked();
    angleA.doubleClicked(); angleB.doubleClicked(); angleC.doubleClicked(); angleD.doubleClicked();
    frameAssembly.doubleClicked();
  } else if (gui.page2Menu && !gui.settingsMenu) {
    page2.doubleClicked();
  }
}

void mouseReleased() {
  holdStart = false;
  if (gui.page1Menu && !gui.settingsMenu) {
    thrustA.mouseReleased(); thrustB.mouseReleased(); thrustC.mouseReleased(); thrustD.mouseReleased();
    angleA.mouseReleased(); angleB.mouseReleased(); angleC.mouseReleased(); angleD.mouseReleased();
    frameAssembly.mouseReleased();
  } else if (gui.page3Menu && !gui.settingsMenu) {
    page3.mouseReleased();
  }
  keyboard.mouseReleased();
  settings.mouseReleased();
  gui.mouseReleased();
}

void mouseDragged() {
  if (gui.page1Menu && !gui.settingsMenu) {
    thrustA.mouseDragged(); thrustB.mouseDragged(); thrustC.mouseDragged(); thrustD.mouseDragged();
    angleA.mouseDragged(); angleB.mouseDragged(); angleC.mouseDragged(); angleD.mouseDragged();
    frameAssembly.mouseDragged(false);
  } else if (gui.page2Menu && !gui.settingsMenu) {
    page2.mouseDragged();
  }
  page3.mouseDragged();
}

void keyPressed() {
  settings.keyPressed();
  gui.keyPressed();
  page3.keyPressed();
}

void oscEvent(OscMessage theOscMessage) {
  handleOSC.oscEvent(theOscMessage);
}