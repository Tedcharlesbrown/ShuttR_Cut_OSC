#include "A_ofApp.h"

//--------------------------------------------------------------
void GUI::pageThreeSetup(){
    bankOne.setup(); bankTwo.setup();
}
//--------------------------------------------------------------
void GUI::pageThreeUpdate(){
    bankOne.update(); bankTwo.update();
}

//--------------------------------------------------------------
void GUI::pageThreeDraw(){
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
void GUI::pageThreeTouchDown(ofTouchEventArgs & touch){
    bankOne.touchDown(touch); bankTwo.touchDown(touch);
}

//--------------------------------------------------------------
void GUI::pageThreeTouchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void GUI::pageThreeTouchUp(ofTouchEventArgs & touch){
    bankOne.touchUp(touch); bankTwo.touchUp(touch);
}

//--------------------------------------------------------------
void GUI::pageThreeDoubleTap(ofTouchEventArgs & touch){

}
