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
    if (angleA.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendAngle("a",angleA.anglePercent);
    } else if (angleB.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendAngle("b",angleB.anglePercent);
    } else if (angleC.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendAngle("c",angleC.anglePercent);
    } else if (angleD.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendAngle("d",angleD.anglePercent);
    }
}

//--------------------------------------------------------------

void GUI::pageOneDraw() {
    angleA.frameDisplay(); angleC.frameDisplay(); angleB.frameDisplay(); angleD.frameDisplay();
    
    assemblyBGDraw();
    
    thrustButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight);
    angleButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight);
    shutterButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight);
    
    ofPushMatrix();
    ofRotateDeg(rotation);
    
    angleA.update(); angleB.update(); angleC.update(); angleD.update();
    
    ofPopMatrix();
}

void GUI::assemblyBGDraw() {
    ofPushStyle();
    ofPushMatrix();
    ofTranslate(centerX,centerY);
    
    ofSetColor(EOSBackground);
    bgAssembly.draw(- bgAssembly.getWidth() / 2,- bgAssembly.getHeight() / 2); //BACKGROUND ASSEMBLY PNG
    
    ofSetColor(shutterOutsideStroke); //OUTER STROKE
    ofDrawCircle(0, 0, assemblyRadius); //OUTER STROKE
    
    ofSetColor(shutterBackground); //INSIDE FILL
    ofDrawCircle(0, 0, assemblyRadius - outsideWeight); //INSIDE FILL
    
    ofRotateDeg(rotation);
    
    ofSetColor(255);
    ofDrawRectangle(- assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2, - crosshairWeight / 2); //CROSSHAIR
    ofDrawRectangle(- crosshairWeight / 2, - assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2); //CROSSHAIR
    
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
    
    angleA.touchDown(touch);
    angleB.touchDown(touch);
    angleC.touchDown(touch);
    angleD.touchDown(touch);
}

//--------------------------------------------------------------

void GUI::pageOneTouchMoved(ofTouchEventArgs & touch) {
    angleA.touchMoved(touch);
    angleB.touchMoved(touch);
    angleC.touchMoved(touch);
    angleD.touchMoved(touch);
}

//--------------------------------------------------------------

void GUI::pageOneTouchUp(ofTouchEventArgs & touch) {
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    thrustButton.touchUp(touch);
    angleButton.touchUp(touch);
    shutterButton.touchUp(touch);
    
    angleA.touchUp(touch);
    angleB.touchUp(touch);
    angleC.touchUp(touch);
    angleD.touchUp(touch);
}

//--------------------------------------------------------------
