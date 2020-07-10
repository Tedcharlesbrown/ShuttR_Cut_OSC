#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::pageTwoSetup() {
    encoder.load("Encoder.png");
    encoder.resize(assemblyDiameter / 1.25, assemblyDiameter / 1.25);
}

//--------------------------------------------------------------

void GUI::pageTwoUpdate() {
    if (irisButton.action && irisButton.clicked) {
        irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
        irisButton.action = false;
        parameterShow = "IRIS"; parameter = "iris";
    } else if (edgeButton.action && edgeButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
        edgeButton.action = false;
        parameterShow = "EDGE"; parameter = "edge";
    } else if (zoomButton.action && zoomButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
        zoomButton.action = false;
        parameterShow = "ZOOM"; parameter = "zoom";
    } else if (frostButton.action && frostButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
        frostButton.action = false;
        parameterShow = "FROST"; parameter = "diffusion";
    } else if (!irisButton.clicked && !edgeButton.clicked && !zoomButton.clicked && !frostButton.clicked) {
        parameterShow = "FORM"; parameter = "form";
    }
    //PERCENT BUTTON SEND OSC
    if (minusPercentButton.action && parameter != "form") { //if param is form, don't send.
        oscSent(ofGetElapsedTimeMillis());
        osc.sendEncoderPercent(parameter, -1);
        minusPercentButton.action = false;
    } else if (homeButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendEncoderPercent(parameter, 0);
        homeButton.action = false;
    } else if (plusPercentButton.action && parameter != "form") { //if param is form, don't send.
        oscSent(ofGetElapsedTimeMillis());
        osc.sendEncoderPercent(parameter, 1);
        plusPercentButton.action = false;
    }
}

void GUI::pageTwoDraw() {
    irisButton.showBig("IRIS",irisPercent, guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    edgeButton.showBig("EDGE",edgePercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    zoomButton.showBig("ZOOM",zoomPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    frostButton.showBig("FROST",frostPercent, guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    
    minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show(parameterShow, "HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight);
    plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    
    
    ofPushMatrix();
    ofTranslate(centerX, centerY);
    ofRotateRad(encoderPosition + ofDegToRad(-90));
    encoder.draw(- encoder.getWidth() / 2, - encoder.getHeight() / 2);
    ofPopMatrix();
}

void GUI::pageTwoTouchDown(ofTouchEventArgs & touch) {
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
}

void GUI::pageTwoTouchMoved(ofTouchEventArgs & touch) {
    if (ofDist(touch.x, touch.y, centerX, centerY) < encoder.getWidth() / 2 || encoderClicked) {
        encoderClicked = true;
        lastPosition = encoderPosition;
        encoderPosition = atan2(touch.y - centerY, touch.x - centerX);
        encoderPosition = ofDegToRad(ofMap(encoderPosition, -PI, PI, 0, 360));
        if (parameter != "form") { //if param is form, don't send.
            if (lastPosition < encoderPosition) {
                oscSent(ofGetElapsedTimeMillis());
                osc.sendEncoder(parameter, 1, fineButton.clicked);
            } else if (lastPosition > encoderPosition) {
                oscSent(ofGetElapsedTimeMillis());
                osc.sendEncoder(parameter, -1, fineButton.clicked);
            }
        }
    }
}


void GUI::pageTwoTouchUp(ofTouchEventArgs & touch) {
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
    
    encoderClicked = false;
}
