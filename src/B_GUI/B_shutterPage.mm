#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- SHUTTER PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::shutterPageSetup() {
    bgAssembly.load("IMG_bgAssembly.png");
    bgAssembly.resize(assemblyDiameter * 2, assemblyDiameter * 2);

    thrustA.setup("a"); thrustB.setup("b"); thrustC.setup("c"); thrustD.setup("d");
    angleA.setup("a"); angleB.setup("b"); angleC.setup("c"); angleD.setup("d");
    assembly.setup();
    
    shutterPageAddListeners();
}

//--------------------------------------------------------------

void ofApp::shutterPageUpdate() {
    if (thrustButton.action) {
        if (noneSelected) {
            thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
        } else {
            sendShutterHome("THRUST");
        }
        thrustButton.action = false;
    }
    if (angleButton.action) {
        if (noneSelected) {
            angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
        } else {
            sendShutterHome("ANGLE");
        }
        angleButton.action = false;
    }
    if (shutterButton.action) {
        if (noneSelected) {
            angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
            thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
            assembly.frameX = assembly.defaultX;
        } else {
            sendShutterHome("SHUTTER");
        }
        shutterButton.action = false;
    }
}

//--------------------------------------------------------------

void ofApp::shutterPageDraw() {
    assemblyBackground();
    
    angleA.frameDisplay(thrustA.buttonA.position); angleC.frameDisplay(thrustC.buttonC.position); angleB.frameDisplay(thrustB.buttonB.position); angleD.frameDisplay(thrustD.buttonD.position);
    
    assemblyFront();
    
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
    
    assembly.update();
}

//--------------------------------------------------------------
// MARK: ---------- ASSEMBLY FOREGROUND / BACKGROUND ----------
//--------------------------------------------------------------

void ofApp::assemblyBackground() {
    ofPushStyle(); ofPushMatrix();
    
    ofTranslate(centerX,centerY);

    ofSetColor(shutterColor);
    ofDrawCircle(0, 0, assemblyRadius - outsideWeight); //INSIDE FILL
    
    ofPopStyle(); ofPopMatrix();
}

void ofApp::assemblyFront() {
    ofPushStyle(); ofPushMatrix();
    
    ofSetColor(EOSBackground);
    ofDrawRectangle(0, settingsBarHeight + settingsBarStrokeWeight, width, centerY - bgAssembly.getHeight() / 2); //UPPER FILL
    
    ofTranslate(centerX,centerY);
    
    ofSetColor(EOSBackground);
    bgAssembly.draw(- bgAssembly.getWidth() / 2,- bgAssembly.getHeight() / 2); //BACKGROUND ASSEMBLY PNG
    
    ofPath path;
    path.hasOutline();
    path.setStrokeColor(shutterOutsideStroke);
    path.setFilled(false);
    path.setCircleResolution(128);
    path.setCurveResolution(128);
    path.setStrokeWidth(10);
    
    for (float i = 0; i < outsideWeight; i += 0.85) {
        path.circle(0, 0, assemblyRadius - i);
    }
    path.draw();

    ofRotateDeg(rotation);
    
    ofSetColor(255,25);
    ofDrawRectangle(- assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2, - crosshairWeight / 2); //CROSSHAIR
    ofDrawRectangle(- crosshairWeight / 2, - assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2); //CROSSHAIR
    
    ofPopStyle(); ofPopMatrix();
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::shutterPageTouchDown(ofTouchEventArgs & touch) {
    minusButton.touchDown(touch);
    plusButton.touchDown(touch);
    fineButton.touchDown(touch, true);
    highButton.touchDown(touch, true);
    flashButton.touchDown(touch);
    channelButton.touchDown(touch, true);
    
    thrustButton.touchDown(touch);
    angleButton.touchDown(touch);
    shutterButton.touchDown(touch);
    
    thrustA.touchDown(touch); thrustB.touchDown(touch); thrustC.touchDown(touch); thrustD.touchDown(touch);
    angleA.touchDown(touch); angleB.touchDown(touch); angleC.touchDown(touch); angleD.touchDown(touch);
    assembly.touchDown(touch);
}

//--------------------------------------------------------------

void ofApp::shutterPageTouchMoved(ofTouchEventArgs & touch) {
    thrustA.touchMoved(touch,fineButton.clicked); thrustB.touchMoved(touch,fineButton.clicked); thrustC.touchMoved(touch,fineButton.clicked); thrustD.touchMoved(touch,fineButton.clicked);
    angleA.touchMoved(touch,fineButton.clicked); angleB.touchMoved(touch,fineButton.clicked); angleC.touchMoved(touch,fineButton.clicked); angleD.touchMoved(touch,fineButton.clicked);
    assembly.touchMoved(touch,fineButton.clicked);
}

//--------------------------------------------------------------

void ofApp::shutterPageTouchUp(ofTouchEventArgs & touch) {
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    thrustButton.touchUp(touch);
    angleButton.touchUp(touch);
    shutterButton.touchUp(touch);
    
    thrustA.touchUp(touch); thrustB.touchUp(touch); thrustC.touchUp(touch); thrustD.touchUp(touch);
    angleA.touchUp(touch); angleB.touchUp(touch); angleC.touchUp(touch); angleD.touchUp(touch);
    assembly.touchUp(touch);
}

//--------------------------------------------------------------

void ofApp::shutterPageDoubleTap(ofTouchEventArgs & touch) {
    thrustA.touchDoubleTap(touch); thrustB.touchDoubleTap(touch); thrustC.touchDoubleTap(touch); thrustD.touchDoubleTap(touch);
    angleA.touchDoubleTap(touch); angleB.touchDoubleTap(touch); angleC.touchDoubleTap(touch); angleD.touchDoubleTap(touch);
    assembly.touchDoubleTap(touch);
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------


void ofApp::shutterPageAddListeners() {
    ofAddListener(thrustA.buttonA.oscOutputPercent, this, &ofApp::sendThrustA);
    ofAddListener(thrustB.buttonB.oscOutputPercent, this, &ofApp::sendThrustB);
    ofAddListener(thrustC.buttonC.oscOutputPercent, this, &ofApp::sendThrustC);
    ofAddListener(thrustD.buttonD.oscOutputPercent, this, &ofApp::sendThrustD);

    ofAddListener(angleA.oscOutputPercent, this, &ofApp::sendAngleA);
    ofAddListener(angleB.oscOutputPercent, this, &ofApp::sendAngleB);
    ofAddListener(angleC.oscOutputPercent, this, &ofApp::sendAngleC);
    ofAddListener(angleD.oscOutputPercent, this, &ofApp::sendAngleD);

    ofAddListener(assembly.oscOutputPercent, this, &ofApp::sendAssembly);
}

void ofApp::sendThrustA(float & oscOutputPercent){
    sendShutter("THRUST","a",oscOutputPercent);
}
void ofApp::sendThrustB(float & oscOutputPercent){
    sendShutter("THRUST","b",oscOutputPercent);
}
void ofApp::sendThrustC(float & oscOutputPercent){
    sendShutter("THRUST","c",oscOutputPercent);
}
void ofApp::sendThrustD(float & oscOutputPercent){
    sendShutter("THRUST","d",oscOutputPercent);
}

void ofApp::sendAngleA(float & oscOutputPercent){
    sendShutter("ANGLE","a",oscOutputPercent);
}
void ofApp::sendAngleB(float & oscOutputPercent){
    sendShutter("ANGLE","b",oscOutputPercent);
}
void ofApp::sendAngleC(float & oscOutputPercent){
    sendShutter("ANGLE","c",oscOutputPercent);
}
void ofApp::sendAngleD(float & oscOutputPercent){
    sendShutter("ANGLE","d",oscOutputPercent);
}

void ofApp::sendAssembly(float & oscOutputPercent){
    sendShutter("ASSEMBLY","",oscOutputPercent);
}
