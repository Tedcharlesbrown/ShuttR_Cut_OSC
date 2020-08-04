#include "A_ofApp.h"

//--------------------------------------------------------------
void GUI::panTiltPageSetup(){
    ptEncoder.setup(assemblyDiameter / 1.25);
//    panTiltEncoder.load("Encoder.png");
//    panTiltEncoder.resize(assemblyDiameter / 1.25, assemblyDiameter / 1.25);
}
//--------------------------------------------------------------
void GUI::panTiltPageUpdate(){
    string parameter = "";
    if (panButton.action && panButton.clicked) {
        panButton.clicked = true; tiltButton.clicked = false;
        panButton.action = false;
        panTiltShow = "PAN"; //parameter = "iris";
    } else if (tiltButton.action && tiltButton.clicked) {
        panButton.clicked = false; tiltButton.clicked = true;
        tiltButton.action = false;
        panTiltShow = "TILT"; //parameter = "edge";
    } else if (!panButton.clicked && !tiltButton.clicked) {
        panTiltShow = "FOCUS"; //parameter = "edge";
    }

    if (ptEncoder.clicked) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendEncoder(parameter, ptEncoder.output);
    }
}

//--------------------------------------------------------------
void GUI::panTiltPageDraw(){
    
    panButton.showBig("PAN",panPercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    tiltButton.showBig("TILT",tiltPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight);
    
    minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show(panTiltShow, "HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight);
    plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    
    ptEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
void GUI::panTiltPageTouchDown(ofTouchEventArgs & touch){
    minusButton.touchDown(touch);
    plusButton.touchDown(touch);
    fineButton.touchDown(touch, true);
    highButton.touchDown(touch, true);
    flashButton.touchDown(touch);
    channelButton.touchDown(touch, true);
    
    panButton.touchDown(touch, true);
    tiltButton.touchDown(touch, true);
    
    ptEncoder.touchDown(touch);
}

//--------------------------------------------------------------
void GUI::panTiltPageTouchMoved(ofTouchEventArgs & touch){
    ptEncoder.touchMoved(touch, fineButton.clicked);
}

//--------------------------------------------------------------
void GUI::panTiltPageTouchUp(ofTouchEventArgs & touch){
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    thrustButton.touchUp(touch);
    angleButton.touchUp(touch);
    shutterButton.touchUp(touch);
    
    ptEncoder.touchUp(touch);
}

//--------------------------------------------------------------
void GUI::panTiltPageDoubleTap(ofTouchEventArgs & touch){

}
