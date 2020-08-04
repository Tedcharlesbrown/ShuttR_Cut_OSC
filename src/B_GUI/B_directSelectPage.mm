#include "A_ofApp.h"

//--------------------------------------------------------------
void GUI::DSPageSetup(){
    bankOne.setup(); bankTwo.setup();
}
//--------------------------------------------------------------
void GUI::DSPageUpdate(){
    bankOne.update(); bankTwo.update();
}

//--------------------------------------------------------------
void GUI::DSPageDraw(){
    bankOne.draw("1", row1Padding);
    bankTwo.draw("21", row1Padding * 5.5);
    
    if (bankOne.quickButton.clicked) {
        bankOne.quickSelectsShow();
    }
    if (bankTwo.quickButton.clicked) {
        bankTwo.quickSelectsShow();
    }
}

//--------------------------------------------------------------
void GUI::DSPageTouchDown(ofTouchEventArgs & touch){
    bankOne.touchDown(touch); bankTwo.touchDown(touch);
}

//--------------------------------------------------------------
void GUI::DSPageTouchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void GUI::DSPageTouchUp(ofTouchEventArgs & touch){
    bankOne.touchUp(touch); bankTwo.touchUp(touch);
}

//--------------------------------------------------------------
void GUI::DSPageDoubleTap(ofTouchEventArgs & touch){

}
