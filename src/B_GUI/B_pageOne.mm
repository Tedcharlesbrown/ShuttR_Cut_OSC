#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::pageOneSetup() {
    bgAssembly.load("IMG_bgAssembly.png");
    bgAssembly.resize(assemblyDiameter * 2, assemblyDiameter * 2);
    
    thrustA.setup("A"); thrustB.setup("B"); thrustC.setup("C"); thrustD.setup("D");
    angleA.setup("A"); angleB.setup("B"); angleC.setup("C"); angleD.setup("D");
    
}

//--------------------------------------------------------------

void GUI::pageOneUpdate() {
    
}

//--------------------------------------------------------------

void GUI::pageOneDraw() {
    //assemblyBGDraw();
    
    thrustButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight);
    angleButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight);
    shutterButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight);
    
    ofPushMatrix();
    ofTranslate(centerX, centerY);
    angleA.update(); angleB.update(); angleC.update(); angleD.update();
    
    ofPopMatrix();
}

void GUI::assemblyBGDraw() {
    ofPushStyle();
    ofPushMatrix();
    ofTranslate(centerX,centerY);
    
    ofSetColor(EOSBackground);
    bgAssembly.draw(centerX - bgAssembly.getWidth() / 2,centerY - bgAssembly.getHeight() / 2); //BACKGROUND ASSEMBLY PNG
    
    ofSetColor(shutterOutsideStroke); //OUTER STROKE
    ofDrawCircle(0, 0, assemblyRadius); //OUTER STROKE
    
    ofSetColor(shutterBackground); //INSIDE FILL
    ofDrawCircle(0, 0, assemblyRadius - outsideWeight); //INSIDE FILL
    
    ofRotateDeg(rotation);
    
    ofSetColor(255);
    ofDrawRectangle(- assemblyRadius + outsideWeight, crosshairWeight / 2, assemblyDiameter - outsideWeight * 2, - crosshairWeight / 2); //CROSSHAIR
    ofDrawRectangle(crosshairWeight / 2, - assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2); //CROSSHAIR
    
    ofPopMatrix();
    
    ofPopStyle();
}

//--------------------------------------------------------------

void GUI::pageOneTouchDown(ofTouchEventArgs & touch) {
    minusButton.touchDown(touch);
    plusButton.touchDown(touch);
    fineButton.touchDown(touch, true);
    highButton.touchDown(touch, true);
    flashButton.touchDown(touch);
    channelButton.touchDown(touch, true);
    
    thrustButton.touchDown(touch);
    angleButton.touchDown(touch);
    shutterButton.touchDown(touch);
}

//--------------------------------------------------------------

void GUI::pageOneTouchUp(ofTouchEventArgs & touch) {
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    thrustButton.touchUp(touch);
    angleButton.touchUp(touch);
    shutterButton.touchUp(touch);
}

//--------------------------------------------------------------
