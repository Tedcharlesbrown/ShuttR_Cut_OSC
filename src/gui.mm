#include "gui.h"
#include "ofApp.h"

void gui::settingsBar(float _x, float _y, float _width, float _height, ofColor _stroke, float _weight, ofColor _fill) {
    ofSetColor(_fill);
    ofFill();
    ofDrawRectangle(_x, _y, _width, _height);
    ofPushStyle();
    ofSetColor(_stroke);
    ofFill();
    ofDrawRectangle(_x, _height - _weight / 2, _width, _weight);
    ofPopStyle();
    
}

void gui::settingsButton(float _x, float _y, float _width, float _height, float _round, ofColor _stroke, float _weight, ofColor _onFill, ofColor _offFill) {
    this-> settingsX = _x;
    this-> settingsY = _y;
    this-> settingsWidth = _width;
    this-> settingsHeight = _height;
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(_stroke);
    ofFill();
    ofDrawRectRounded(_x + _width / 2, _y + _height / 2, _width, _height, _round);
    
    if (settingsMenu) {
        ofSetColor(_onFill);
    } else {
        ofSetColor(_offFill);
    }
    
    ofFill();
    ofDrawRectRounded(_x + _width / 2, _y + _height / 2, _width - _weight, _height - _weight, _round);
    ofSetColor(_stroke);
    ofFill();
    ofDrawCircle(_x + _width / 2, _y + _height / 2, _width / 4);
    
    ofPopStyle();
}

//--------------------------------------------------------------
void gui::touchDown(ofTouchEventArgs & touch){
    if (touch.x > settingsX && touch.y < settingsHeight) {
        settingsMenu = true;
    }
}

//--------------------------------------------------------------
void gui::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void gui::touchUp(ofTouchEventArgs & touch){
    settingsMenu = false;
}

//--------------------------------------------------------------
void gui::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void gui::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void gui::lostFocus(){

}

//--------------------------------------------------------------
void gui::gotFocus(){

}

//--------------------------------------------------------------
void gui::gotMemoryWarning(){

}

//--------------------------------------------------------------
void gui::deviceOrientationChanged(int newOrientation){

}
