#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::shutterPageSetup() {
    bgAssembly.load("IMG_bgAssembly.png");
    bgAssembly.resize(assemblyDiameter * 2, assemblyDiameter * 2);

    thrustA.setup("A"); thrustB.setup("B"); thrustC.setup("C"); thrustD.setup("D");
    angleA.setup("A"); angleB.setup("B"); angleC.setup("C"); angleD.setup("D");
    assembly.setup();
}

//--------------------------------------------------------------

void GUI::shutterPageUpdate() {
    shutterPageAction();
}

//--------------------------------------------------------------

void GUI::shutterPageDraw() {
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
    
    assembly.update();
}

//--------------------------------------------------------------

void GUI::shutterPageAction() {
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
        assembly.frameX = assembly.defaultX;
        osc.sendShutterHome("SHUTTER");
        shutterButton.action = false;
    }
    
    if (thrustA.clicked || thrustA.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("THRUST","a",thrustA.buttonA.output);
    } else if (thrustB.clicked || thrustB.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("THRUST","b",thrustB.buttonB.output);
    } else if (thrustC.clicked || thrustC.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("THRUST","c",thrustC.buttonC.output);
    } else if (thrustD.clicked || thrustD.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("THRUST","d",thrustD.buttonD.output);
    }
    
    if (angleA.clicked || angleA.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("ANGLE","a",angleA.anglePercent);
    } else if (angleB.clicked || angleB.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("ANGLE","b",angleB.anglePercent);
    } else if (angleC.clicked || angleC.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("ANGLE","c",angleC.anglePercent);
    } else if (angleD.clicked || angleD.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("ANGLE","d",angleD.anglePercent);
    }
    
    if (assembly.clicked || assembly.doubleClicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendShutter("ASSEMBLY","",assembly.output);
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
    
    ofSetColor(255,25);
    ofDrawRectangle(- assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2, - crosshairWeight / 2); //CROSSHAIR
    ofDrawRectangle(- crosshairWeight / 2, - assemblyRadius + outsideWeight,crosshairWeight / 2, assemblyDiameter - outsideWeight * 2); //CROSSHAIR
    
    ofPopStyle(); ofPopMatrix();
}

//--------------------------------------------------------------

void GUI::shutterPageTouchDown(ofTouchEventArgs & touch) {
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

void GUI::shutterPageTouchMoved(ofTouchEventArgs & touch) {
    thrustA.touchMoved(touch,fineButton.clicked); thrustB.touchMoved(touch,fineButton.clicked); thrustC.touchMoved(touch,fineButton.clicked); thrustD.touchMoved(touch,fineButton.clicked);
    angleA.touchMoved(touch,fineButton.clicked); angleB.touchMoved(touch,fineButton.clicked); angleC.touchMoved(touch,fineButton.clicked); angleD.touchMoved(touch,fineButton.clicked);
    assembly.touchMoved(touch,fineButton.clicked);
}

//--------------------------------------------------------------

void GUI::shutterPageTouchUp(ofTouchEventArgs & touch) {
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

void GUI::shutterPageDoubleTap(ofTouchEventArgs & touch) {
    thrustA.touchDoubleTap(touch); thrustB.touchDoubleTap(touch); thrustC.touchDoubleTap(touch); thrustD.touchDoubleTap(touch);
    angleA.touchDoubleTap(touch); angleB.touchDoubleTap(touch); angleC.touchDoubleTap(touch); angleD.touchDoubleTap(touch);
    assembly.touchDoubleTap(touch);
}
