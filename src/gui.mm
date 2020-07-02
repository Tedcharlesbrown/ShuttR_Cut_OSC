#include "gui.h"
#include "ofApp.h"

void gui::settingsBar(float _x, float _y, float _w, float _h, ofColor _stroke, float _weight, ofColor _fill) {
    ofSetColor(_fill);
    ofFill();
    ofDrawRectangle(_x, _y, _w, _h);
    ofPushStyle();
    ofSetColor(_stroke);
    ofFill();
    ofDrawRectangle(_x, _h, _w, _weight);
    ofPopStyle();
    
}

void gui::settingsButton(float _x, float _y, float _w, float _h, float _r, ofColor _stroke, float _weight, ofColor _onFill, ofColor _offFill) {
    this-> settingsX = _x;
    this-> settingsY = _y;
    this-> settingsWidth = _w;
    this-> settingsHeight = _h;
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(_stroke);
    ofFill();
    ofDrawRectRounded(_x + _w / 2, _y + _h / 2, _w, _h, _r);
    
    if (settingsMenu) {
        ofSetColor(_onFill);
    } else {
        ofSetColor(_offFill);
    }
    
    ofFill();
    ofDrawRectRounded(_x + _w / 2, _y + _h / 2, _w - _weight, _h - _weight, _r);
    ofSetColor(_stroke);
    ofFill();
    ofDrawCircle(_x + _w / 2, _y + _h / 2, _w / 5);
    
    ofPopStyle();
}

void gui::oscLight(string _ID,float _x,float _y,float _w,float _h,float _r,ofColor _stroke,float _weight, ofColor _onSend,ofColor _offSend,ofColor _onGet,ofColor _offGet){
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    if (_ID == "TX") {
        ofSetColor(_stroke);
        ofFill();
        ofDrawRectRounded(_x, _y, _w, _h, _r / 2);
        ofSetColor(_offSend);
        ofFill();
        ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, _r / 2);
    } else if (_ID == "RX") {
        ofSetColor(_stroke);
        ofFill();
        ofDrawRectRounded(_x, _y, _w, _h, _r / 2);
        ofSetColor(_offGet);
        ofFill();
        ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, _r / 2);
    }
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
