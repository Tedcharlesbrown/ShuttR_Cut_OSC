#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- PAN TILT PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::imagePageSetup(){
    for (int i = 0; i < 2; i++) {
        imageWheel.push_back(wheelButton);
        imageWheelLeft.push_back(wheelButton);
        imageWheelRight.push_back(wheelButton);
//        wheelSelect.push_back("");
//        wheelPercent.push_back("");
    }
}
//--------------------------------------------------------------
void ofApp::imagePageUpdate(){
    for (int i = 0; i < wheelPercent.size(); i++) {
        if (wheelPercent.at(i) == "1") {
            wheelPercent.at(i) = "OPEN";
        }
    }
}

//--------------------------------------------------------------
void ofApp::imagePageDraw(){
    imageWheel.at(0).showBig(wheelSelect.at(0),wheelPercent.at(0), guiCenterAlign, row3Padding, channelButtonWidth, buttonHeight);
    imageWheel.at(0).show("<", guiLeftAlign, row3Padding + buttonHeight / 2, smallButtonWidth, buttonHeight, "MEDIUM");
    imageWheel.at(0).show(">", guiRightAlign, row3Padding + buttonHeight / 2, smallButtonWidth, buttonHeight, "MEDIUM");
    
    imageWheel.at(1).showBig(wheelSelect.at(1),wheelPercent.at(1), guiCenterAlign, row3Padding + buttonHeight * 2.2, channelButtonWidth, buttonHeight);
    imageWheel.at(1).show("<", guiLeftAlign, row3Padding + buttonHeight / 2 + buttonHeight * 2.2, smallButtonWidth, buttonHeight, "MEDIUM");
    imageWheel.at(1).show(">", guiRightAlign, row3Padding + buttonHeight / 2 + buttonHeight * 2.2, smallButtonWidth, buttonHeight, "MEDIUM");
    
    imageWheel.at(1).showBig(wheelSelect.at(1),wheelPercent.at(1), guiCenterAlign, row3Padding + buttonHeight * 4.4, channelButtonWidth, buttonHeight);
    imageWheel.at(1).show("<", guiLeftAlign, row3Padding + buttonHeight / 2 + buttonHeight * 4.4, smallButtonWidth, buttonHeight, "MEDIUM");
    imageWheel.at(1).show(">", guiRightAlign, row3Padding + buttonHeight / 2 + buttonHeight * 4.4, smallButtonWidth, buttonHeight, "MEDIUM");
    
    imageWheel.at(1).showBig(wheelSelect.at(1),wheelPercent.at(1), guiCenterAlign, row3Padding + buttonHeight * 6.6, channelButtonWidth, buttonHeight);
    imageWheel.at(1).show("<", guiLeftAlign, row3Padding + buttonHeight / 2 + buttonHeight * 6.6, smallButtonWidth, buttonHeight, "MEDIUM");
    imageWheel.at(1).show(">", guiRightAlign, row3Padding + buttonHeight / 2 + buttonHeight * 6.6, smallButtonWidth, buttonHeight, "MEDIUM");
    
    imageWheel.at(1).showBig(wheelSelect.at(1),wheelPercent.at(1), guiCenterAlign, row3Padding + buttonHeight * 8.8, channelButtonWidth, buttonHeight);
    imageWheel.at(1).show("<", guiLeftAlign, row3Padding + buttonHeight / 2 + buttonHeight * 8.8, smallButtonWidth, buttonHeight, "MEDIUM");
    imageWheel.at(1).show(">", guiRightAlign, row3Padding + buttonHeight / 2 + buttonHeight * 8.8, smallButtonWidth, buttonHeight, "MEDIUM");
    
    imageWheel.at(1).showBig(wheelSelect.at(1),wheelPercent.at(1), guiCenterAlign, row3Padding + buttonHeight * 11.1, channelButtonWidth, buttonHeight);
    imageWheel.at(1).show("<", guiLeftAlign, row3Padding + buttonHeight / 2 + buttonHeight * 11.1, smallButtonWidth, buttonHeight, "MEDIUM");
    imageWheel.at(1).show(">", guiRightAlign, row3Padding + buttonHeight / 2 + buttonHeight * 11.1, smallButtonWidth, buttonHeight, "MEDIUM");
    
    imageWheel.at(1).showBig(wheelSelect.at(1),wheelPercent.at(1), guiCenterAlign, row3Padding + buttonHeight * 13.3, channelButtonWidth, buttonHeight);
    imageWheel.at(1).show("<", guiLeftAlign, row3Padding + buttonHeight / 2 + buttonHeight * 13.3, smallButtonWidth, buttonHeight, "MEDIUM");
    imageWheel.at(1).show(">", guiRightAlign, row3Padding + buttonHeight / 2 + buttonHeight * 13.3, smallButtonWidth, buttonHeight, "MEDIUM");
    
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::imagePageTouchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::imagePageTouchMoved(ofTouchEventArgs & touch){
}

//--------------------------------------------------------------
void ofApp::imagePageTouchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::imagePageDoubleTap(ofTouchEventArgs & touch){

}
