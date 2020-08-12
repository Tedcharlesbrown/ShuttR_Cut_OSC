#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- DIRECT SELECT - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::DSPageSetup(){
    bankOne.setup(); bankTwo.setup();
}
//--------------------------------------------------------------
void ofApp::DSPageUpdate(){
    bankOne.update(); bankTwo.update();
}

//--------------------------------------------------------------
void ofApp::DSPageDraw(){
    bankOne.draw("1", row1Padding);
//    bankTwo.draw("21",height - bankTwo.bankHeight + buttonHeight);
//    bankTwo.draw("21", row1Padding + buttonHeight / 4 + bankTwo.bankHeight);
    bankTwo.draw("21", row1Padding + notchHeight / 2 + bankTwo.bankHeight);
    
    if (bankOne.quickButton.clicked) {
        bankOne.quickSelectsShow();
    }
    if (bankTwo.quickButton.clicked) {
        bankTwo.quickSelectsShow();
    }
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::DSPageTouchDown(ofTouchEventArgs & touch){
    bankOne.touchDown(touch); bankTwo.touchDown(touch);
}

//--------------------------------------------------------------
void ofApp::DSPageTouchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::DSPageTouchUp(ofTouchEventArgs & touch){
    bankOne.touchUp(touch); bankTwo.touchUp(touch);
}

//--------------------------------------------------------------
void ofApp::DSPageDoubleTap(ofTouchEventArgs & touch){

}
