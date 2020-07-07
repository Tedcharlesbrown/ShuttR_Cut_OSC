#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::pageTwoUpdate() {
    if (irisButton.action && irisButton.clicked) {
        irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
        irisButton.action = false;
        parameter = "iris";
    } else if (edgeButton.action && edgeButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
        edgeButton.action = false;
        parameter = "edge";
    } else if (zoomButton.action && zoomButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
        zoomButton.action = false;
        parameter = "zoom";
    } else if (frostButton.action && frostButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
        frostButton.action = false;
        parameter = "diffusion";
    }
}

void GUI::pageTwoShow() {
    irisButton.showBig("IRIS",irisPercent, guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    edgeButton.showBig("EDGE",edgePercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    zoomButton.showBig("ZOOM",zoomPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    frostButton.showBig("FROST",frostPercent, guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    
    minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show("HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    
    ofPushMatrix();
    ofTranslate(centerX, centerY);
    ofRotateRad(encoderPosition + ofDegToRad(-90));
    encoder.resize(assemblyDiameter / 1.25, assemblyDiameter / 1.25);
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
        if (lastPosition < encoderPosition) {
            oscSent(ofGetElapsedTimeMillis());
            osc.sendEncoder(inputID, parameter, 1);
        } else if (lastPosition > encoderPosition) {
            oscSent(ofGetElapsedTimeMillis());
            osc.sendEncoder(inputID, parameter, -1);
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
