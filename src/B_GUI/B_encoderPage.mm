#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::encoderPageSetup() {
    encoder.load("Encoder.png");
    encoder.resize(assemblyDiameter / 1.25, assemblyDiameter / 1.25);
}

//--------------------------------------------------------------

void GUI::encoderPageUpdate() {
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

void GUI::encoderPageDraw() {
    irisButton.showBig("IRIS",irisPercent, guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    edgeButton.showBig("EDGE",edgePercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    zoomButton.showBig("ZOOM",zoomPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    frostButton.showBig("FROST",frostPercent, guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight);
    
    minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show(parameterShow, "HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight);
    plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    
    ofPushMatrix();
    ofTranslate(centerX, centerY);
    ofRotateRad(ofDegToRad(encoderPosition) + ofDegToRad(150));
    encoder.draw(- encoder.getWidth() / 2, - encoder.getHeight() / 2);
    ofPopMatrix();
}

void GUI::encoderPageTouchDown(ofTouchEventArgs & touch) {
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

void GUI::encoderPageTouchMoved(ofTouchEventArgs & touch) {
    if (ofDist(touch.x, touch.y, centerX, centerY) < encoder.getWidth() / 2 || encoderClicked) {
        encoderClicked = true;
        
        ofVec2f center;
        ofVec2f prevTouch;
        ofVec2f currentTouch;
        center.set(centerX, centerY);
        prevTouch.set(ofGetPreviousMouseX(),ofGetPreviousMouseY());
        currentTouch.set(touch.x,touch.y);
        
        ofVec2f oldVector;
        oldVector = prevTouch - center;
        float angleOld = oldVector.angle(prevTouch);
        
        ofVec2f newVector;
        newVector = currentTouch - center;
        float angleNew = newVector.angle(currentTouch);
        
        encoderPosition = -angleNew; //ROTATE ENCODER
        
        float diff = ofDegToRad(angleOld - angleNew);

        if (diff > 1) {
            diff = 0;
        } else if (diff>PI) {
            diff = TWO_PI - diff;
        } else if (diff<-PI) {
            diff = TWO_PI + diff;
        }
        
        int direction = 0;
        if (diff > 0) { //CLOCKWISE
            oscSent(ofGetElapsedTimeMillis());
            direction = 1;
        } else if (diff < 0) { //COUNTER-CLOCKWISE
            oscSent(ofGetElapsedTimeMillis());
            direction = -1;
        }
        
        if (fineButton.clicked) {
            if (parameter == "edge") {
                direction *= 100;
            } else if (parameter == "zoom") {
                direction *= 500;
            }
            osc.sendEncoder("fine/" + parameter, direction);
        } else {
            osc.sendEncoder(parameter, direction);
        }
    }
}


void GUI::encoderPageTouchUp(ofTouchEventArgs & touch) {
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
    
    encoderClicked = false;
}
