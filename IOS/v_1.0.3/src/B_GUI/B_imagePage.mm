#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- PAN TILT PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::imagePageSetup(){
    imageEncoder.setup(assemblyDiameter / 1.25);
    for (int i = 0; i < 2; i++) {
        imageWheel.push_back(wheelButton);
        wheelSelect.push_back("");
        wheelGobo.push_back("");
        wheelPercent.push_back("");
    }
}
//--------------------------------------------------------------
void ofApp::imagePageUpdate(){
    for (int i = 0; i < wheelGobo.size(); i++) {
        if (wheelGobo.at(i) == "1") {
            wheelGobo.at(i) = "OPEN";
        }
    }
}

//--------------------------------------------------------------
void ofApp::imagePageDraw(){
    imageWheel.at(0).showImage(wheelSelect.at(0),wheelGobo.at(0), wheelPercent.at(0), guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight);
    
    imageEncoder.draw(centerX,centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::imagePageTouchDown(ofTouchEventArgs & touch){
    imageEncoder.touchDown(touch);
}

//--------------------------------------------------------------
void ofApp::imagePageTouchMoved(ofTouchEventArgs & touch){
    imageEncoder.touchMoved(touch);
}

//--------------------------------------------------------------
void ofApp::imagePageTouchUp(ofTouchEventArgs & touch){
    imageEncoder.touchUp(touch);
}

//--------------------------------------------------------------
void ofApp::imagePageDoubleTap(ofTouchEventArgs & touch){

}
