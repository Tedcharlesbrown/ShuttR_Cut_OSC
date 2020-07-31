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
    if (thrustA.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendThrust("a",thrustA.buttonA.output);
    } else if (thrustB.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendThrust("b",thrustB.buttonB.output);
    } else if (thrustC.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendThrust("c",thrustC.buttonC.output);
    } else if (thrustD.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendThrust("d",thrustD.buttonD.output);
    }
    
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
    pageOneButtonAction();
}

//--------------------------------------------------------------

void GUI::pageOneDraw() {
    assemblyColor();
    
    angleA.frameDisplay(thrustA.buttonA.position); angleC.frameDisplay(thrustC.buttonC.position); angleB.frameDisplay(thrustB.buttonB.position); angleD.frameDisplay(thrustD.buttonD.position);
    
    assemblyBG();
    
    
    thrustButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight);
    angleButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight);
    shutterButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight);
    
    ofPushMatrix();
    ofTranslate(centerX, centerY);
    ofRotateDeg(rotation);
    
    angleA.update(); angleB.update(); angleC.update(); angleD.update();
    thrustA.update(); thrustB.update(); thrustC.update(); thrustD.update();
    thrustA.buttonA.angleLimit(angleA.anglePercent); thrustB.buttonB.angleLimit(angleB.anglePercent); thrustC.buttonC.angleLimit(angleC.anglePercent); thrustD.buttonD.angleLimit(angleD.anglePercent);
    
    ofPopMatrix();
}

//--------------------------------------------------------------

void GUI::pageOneButtonAction() {
    if (thrustButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
        osc.sendShutterHome("THRUST");
        thrustButton.action = false;
    }
    if (angleButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
        osc.sendShutterHome("ANGLE");
        angleButton.action = false;
    }
    if (shutterButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
        thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
        osc.sendShutterHome("SHUTTER");
        shutterButton.action = false;
    }
}

//--------------------------------------------------------------

void GUI::assemblyColor() {
    ofPushStyle(); ofPushMatrix();
    
    ofTranslate(centerX,centerY);

    ofSetColor(shutterOutsideStroke); //OUTER STROKE
    ofDrawCircle(0, 0, assemblyRadius); //OUTER STROKE

    ofSetColor(shutterColor);
    ofDrawCircle(0, 0, assemblyRadius - outsideWeight); //INSIDE FILL
    
    ofPopStyle(); ofPopMatrix();
}

void GUI::assemblyBG() {
    ofPushStyle(); ofPushMatrix();
    
    ofSetColor(EOSBackground);
    ofDrawRectangle(0, settingsBarHeight + settingsBarStrokeWeight, width, centerY - bgAssembly.getHeight() / 2); //UPPER FILL
    
    ofTranslate(centerX,centerY);
    
    ofSetColor(EOSBackground);
    bgAssembly.draw(- bgAssembly.getWidth() / 2,- bgAssembly.getHeight() / 2); //BACKGROUND ASSEMBLY PNG

    ofRotateDeg(rotation);
    
    ofSetColor(255);
    ofDrawRectangle(- assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2, - crosshairWeight / 2); //CROSSHAIR
    ofDrawRectangle(- crosshairWeight / 2, - assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2); //CROSSHAIR
    
    ofPopStyle(); ofPopMatrix();
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
    
    thrustA.touchDown(touch);
    thrustB.touchDown(touch);
    thrustC.touchDown(touch);
    thrustD.touchDown(touch);
    
    angleA.touchDown(touch);
    angleB.touchDown(touch);
    angleC.touchDown(touch);
    angleD.touchDown(touch);
}

//--------------------------------------------------------------

void GUI::pageOneTouchMoved(ofTouchEventArgs & touch) {
    thrustA.touchMoved(touch);
    thrustB.touchMoved(touch);
    thrustC.touchMoved(touch);
    thrustD.touchMoved(touch);
    
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
    
    thrustA.touchUp(touch);
    thrustB.touchUp(touch);
    thrustC.touchUp(touch);
    thrustD.touchUp(touch);
    
    angleA.touchUp(touch);
    angleB.touchUp(touch);
    angleC.touchUp(touch);
    angleD.touchUp(touch);
}

//--------------------------------------------------------------
