#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- PAN TILT PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::panTiltPageSetup(){
    focusEncoder.setup(assemblyDiameter / 1.25);
    
    ofAddListener(focusEncoder.oscOutputPercent, this, &ofApp::sendFocusEncoder);
}
//--------------------------------------------------------------
void ofApp::panTiltPageUpdate(){
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
        sendEncoderPercent(focusParameter, 0);
        homeButton.action = false;
    } else if (plusPercentButton.action && focusParameter != "focus") { //if param is focus, don't send.
        sendEncoderPercent(focusParameter, 1);
        plusPercentButton.action = false;
    }
}

//--------------------------------------------------------------
void ofApp::panTiltPageDraw(){
    
    panButton.showBig("PAN",panPercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    tiltButton.showBig("TILT",tiltPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    
    minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show(panTiltShow, "HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight);
    plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    
    focusEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::panTiltPageTouchDown(ofTouchEventArgs & touch){
    minusButton.touchDown(touch);
    plusButton.touchDown(touch);
    fineButton.touchDown(touch, true);
    highButton.touchDown(touch, true);
    flashButton.touchDown(touch);
    channelButton.touchDown(touch, true);
    
    panButton.touchDown(touch, true);
    tiltButton.touchDown(touch, true);
    
    minusPercentButton.touchDown(touch);
    homeButton.touchDown(touch);
    plusPercentButton.touchDown(touch);
    
    focusEncoder.touchDown(touch);
}

//--------------------------------------------------------------
void ofApp::panTiltPageTouchMoved(ofTouchEventArgs & touch){
    focusEncoder.touchMoved(touch);
}

//--------------------------------------------------------------
void ofApp::panTiltPageTouchUp(ofTouchEventArgs & touch){
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    thrustButton.touchUp(touch);
    angleButton.touchUp(touch);
    shutterButton.touchUp(touch);
    
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
    
    focusEncoder.touchUp(touch);
}

//--------------------------------------------------------------
void ofApp::panTiltPageDoubleTap(ofTouchEventArgs & touch){

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
