#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- ENCODER - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::encoderPageSetup() {
    formEncoder.setup(assemblyDiameter / 1.25);
    
    ofAddListener(formEncoder.oscOutputPercent, this, &ofApp::sendFormEncoder);
}

//--------------------------------------------------------------

void ofApp::encoderPageUpdate() {
    if (irisButton.action && irisButton.clicked) {
        irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
        irisButton.action = false;
        parameterShow = "IRIS"; formEncoder.update("iris"); formParameter = "iris";
    } else if (edgeButton.action && edgeButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
        edgeButton.action = false;
        parameterShow = "EDGE"; formEncoder.update("edge"); formParameter = "edge";
    } else if (zoomButton.action && zoomButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
        zoomButton.action = false;
        parameterShow = "ZOOM"; formEncoder.update("zoom"); formParameter = "zoom";
    } else if (frostButton.action && frostButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
        frostButton.action = false;
        parameterShow = "FROST"; formEncoder.update("diffusion"); formParameter = "diffusion";
    } else if (!irisButton.clicked && !edgeButton.clicked && !zoomButton.clicked && !frostButton.clicked) {
        parameterShow = "FORM"; formEncoder.update("form"); formParameter = "form";
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

void ofApp::encoderPageDraw() {
    
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

void ofApp::encoderPageTouchDown(ofTouchEventArgs & touch) {
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

void ofApp::encoderPageTouchMoved(ofTouchEventArgs & touch) {
    formEncoder.touchMoved(touch, fineButton.clicked);
}


void ofApp::encoderPageTouchUp(ofTouchEventArgs & touch) {
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
    sendEncoder(formEncoder.parameter, oscOutputPercent);
}
