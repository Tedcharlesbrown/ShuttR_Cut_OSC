#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- PAN TILT PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::focusPageSetup(){
    focusEncoder.setup(assemblyDiameter / 1.25);
    
    ofAddListener(focusEncoder.oscOutputEvent, this, &ofApp::sendFocusEncoder);
}
//--------------------------------------------------------------
void ofApp::focusPageUpdate(){
    string _parameter = "";
    if (panButton.action && panButton.clicked) {
        panButton.clicked = true; tiltButton.clicked = false;
        panButton.action = false;
        panTiltShow = "PAN"; focusParameter = "pan";
    } else if (tiltButton.action && tiltButton.clicked) {
        panButton.clicked = false; tiltButton.clicked = true;
        tiltButton.action = false;
        panTiltShow = "TILT"; focusParameter = "tilt";
    } else if (!panButton.clicked && !tiltButton.clicked) {
        panTiltShow = "FOCUS"; focusParameter = "focus";
    }
    
    if (minusPercentButton.action && focusParameter != "focus") { //if param is focus, don't send.
        sendEncoderPercent(focusParameter, -1);
        minusPercentButton.action = false;
    } else if (homeButton.action) {
        if (focusParameter == "focus" && homeButton.doubleClicked) {  //If double tapped, sneak
            sendSneak("focus");
        } else {
            sendEncoderPercent(focusParameter, 0);
        }
        homeButton.action = false;
    } else if (plusPercentButton.action && focusParameter != "focus") { //if param is focus, don't send.
        sendEncoderPercent(focusParameter, 1);
        plusPercentButton.action = false;
    }
}

//--------------------------------------------------------------
void ofApp::focusPageDraw(){
    
    panButton.showBig("PAN",panPercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
    tiltButton.showBig("TILT",tiltPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
    
    minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show(panTiltShow, "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
    plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
    
    focusEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::focusPageTouchDown(ofTouchEventArgs & touch){
    panButton.touchDown(touch, true);
    tiltButton.touchDown(touch, true);
    
    minusPercentButton.touchDown(touch);
    homeButton.touchDown(touch);
    plusPercentButton.touchDown(touch);
    
    focusEncoder.touchDown(touch);
}

//--------------------------------------------------------------
void ofApp::focusPageTouchMoved(ofTouchEventArgs & touch){
    focusEncoder.touchMoved(touch);
}

//--------------------------------------------------------------
void ofApp::focusPageTouchUp(ofTouchEventArgs & touch){  
    thrustButton.touchUp(touch);
    angleButton.touchUp(touch);
    shutterButton.touchUp(touch);
    
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
    
    focusEncoder.touchUp(touch);
}

//--------------------------------------------------------------
void ofApp::focusPageDoubleTap(ofTouchEventArgs & touch){
    homeButton.touchDoubleTap(touch);
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

void ofApp::sendFocusEncoder(float & oscOutputPercent){
    if (focusParameter != "focus") {
        if (fineButton.clicked) {
            sendEncoder(focusParameter, oscOutputPercent / 1000);
        } else {
            sendEncoder(focusParameter, oscOutputPercent * 2);
        }
    }
}
