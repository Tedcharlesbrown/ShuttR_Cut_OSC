#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- DIRECT SELECT - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::DSPageSetup(){
    bankOne.setup(1); bankTwo.setup(2);
    
    ofAddListener(bankOne.oscOutputDS, this, &ofApp::parseDirectSelectSend);
}
//--------------------------------------------------------------
void ofApp::DSPageUpdate(){
    bankOne.update(); bankTwo.update();
}

//--------------------------------------------------------------
void ofApp::DSPageDraw(){
    bankOne.draw(row1Padding);
//    bankTwo.draw("21",height - bankTwo.bankHeight + buttonHeight);
//    bankTwo.draw("21", row1Padding + buttonHeight / 4 + bankTwo.bankHeight);
    bankTwo.draw(row1Padding + notchHeight / 2 + bankTwo.bankHeight);
    
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

//--------------------------------------------------------------

void ofApp::parseDirectSelectSend(ofVec3f & dSelect) {
    string directParameter;
    
    
    if (dSelect.y != 0 && dSelect.z == 0) { //QUICK SELECT
        int switchCase = dSelect.y;
        switch(switchCase) {
            case 1:
                directParameter = "chan"; break;
            case 2:
                directParameter = "group"; break;
            case 3:
                directParameter = "ip"; break;
            case 4:
                directParameter = "fp"; break;
            case 5:
                directParameter = "cp"; break;
            case 6:
                directParameter = "bp"; break;
            case 7:
                directParameter = "preset"; break;
            case 8:
                directParameter = "macro"; break;
            case 9:
                directParameter = "fx"; break;
            case 10:
                directParameter = "snap"; break;
            case 11:
                directParameter = "ms"; break;
            case 12:
                directParameter = "scene"; break;
            case 13:
                
                break;
        }
        
        sendDSRequest(ofToString(dSelect.x), directParameter, "20");
            
    } else if (dSelect.y == 0 && dSelect.z != 0) {//DIRECT SELECT BUTTON
        
        sendDS(ofToString(dSelect.x), ofToString(dSelect.z));
        
    }
}
