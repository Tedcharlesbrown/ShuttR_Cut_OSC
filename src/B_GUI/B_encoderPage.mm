#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- ENCODER - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::formPageSetup() {
    formEncoder.setup(assemblyDiameter / 1.25);
    
    ofAddListener(formEncoder.oscOutputPercent, this, &ofApp::sendFormEncoder);
}

//--------------------------------------------------------------

void ofApp::formPageUpdate() {
    if (irisButton.action && irisButton.clicked) {
        irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
        irisButton.action = false;
        parameterShow = "IRIS"; formParameter = "iris";
    } else if (edgeButton.action && edgeButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
        edgeButton.action = false;
        parameterShow = "EDGE"; formParameter = "edge";
    } else if (zoomButton.action && zoomButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
        zoomButton.action = false;
        parameterShow = "ZOOM"; formParameter = "zoom";
    } else if (frostButton.action && frostButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
        frostButton.action = false;
        parameterShow = "FROST"; formParameter = "diffusion";
    } else if (!irisButton.clicked && !edgeButton.clicked && !zoomButton.clicked && !frostButton.clicked) {
        parameterShow = "FORM"; formParameter = "form";
    }
    
    if (minusPercentButton.action && formParameter != "form") { //if param is form, don't send.
        sendEncoderPercent(formParameter, -1);
        minusPercentButton.action = false;
    } else if (homeButton.action) {
        sendEncoderPercent(formParameter, 0);
        homeButton.action = false;
    } else if (plusPercentButton.action && formParameter != "form") { //if param is form, don't send.
        sendEncoderPercent(formParameter, 1);
        plusPercentButton.action = false;
    }
}

//--------------------------------------------------------------

void ofApp::formPageDraw() {
    
    irisButton.showBig("IRIS",irisPercent, guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    edgeButton.showBig("EDGE",edgePercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    zoomButton.showBig("ZOOM",zoomPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    frostButton.showBig("FROST",frostPercent, guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    
    minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show(parameterShow, "HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight);
    plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    
    formEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::formPageTouchDown(ofTouchEventArgs & touch) {
    minusButton.touchDown(touch);
    plusButton.touchDown(touch);
    fineButton.touchDown(touch, true);
    highButton.touchDown(touch, true);
    flashButton.touchDown(touch);
    channelButton.touchDown(touch, true);
    
    irisButton.touchDown(touch, true);
    edgeButton.touchDown(touch, true);
    zoomButton.touchDown(touch, true);
    frostButton.touchDown(touch, true);
    minusPercentButton.touchDown(touch);
    homeButton.touchDown(touch);
    plusPercentButton.touchDown(touch);
    
    formEncoder.touchDown(touch);
}

void ofApp::formPageTouchMoved(ofTouchEventArgs & touch) {
    formEncoder.touchMoved(touch);
}


void ofApp::formPageTouchUp(ofTouchEventArgs & touch) {
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
    
    formEncoder.touchUp(touch);
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

void ofApp::sendFormEncoder(float & oscOutputPercent){
    if (formParameter != "form") {
        if (fineButton.clicked) {
            sendEncoder(formParameter, oscOutputPercent / 1000);
        } else {
            sendEncoder(formParameter, oscOutputPercent * 2);
        }
    }
}
