#include "B_gui.h"
#include "A_ofApp.h"


void GUI::update() {
    if (ofGetElapsedTimeMillis() > sentTime + 200) {
        oscSendLight = false;
    }
    if (ofGetElapsedTimeMillis() > receivedTime + 200) {
        oscReceiveLight = false;
    }
}



void GUI::settingsBar(float _x, float _y, float _w, float _h, ofColor _stroke, float _weight, ofColor _fill) {
    ofPushStyle();
    ofSetColor(_fill);
    ofFill();
    ofDrawRectangle(_x, _y, _w, _h);
    ofSetColor(_stroke);
    ofFill();
    ofDrawRectangle(_x, _h, _w, _weight);
    ofPopStyle();
}

void GUI::settingsButton(float _x, float _y, float _w, float _h, float _r, ofColor _stroke, float _weight, ofColor _onFill, ofColor _offFill) {
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

void GUI::oscLight(string _ID,float _x,float _y,float _w,float _h,float _r,ofColor _stroke,float _weight, ofColor _onSend,ofColor _offSend,ofColor _onGet,ofColor _offGet){
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    if (_ID == "TX") {
        ofSetColor(_stroke);
        ofFill();
        ofDrawRectRounded(_x, _y, _w, _h, _r / 2);
        if (oscSendLight) {
            ofSetColor(_onSend);
        } else {
            ofSetColor(_offSend);
        }
        ofFill();
        ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, _r / 2);
    } else if (_ID == "RX") {
        ofSetColor(_stroke);
        ofFill();
        ofDrawRectRounded(_x, _y, _w, _h, _r / 2);
        if (oscReceiveLight) {
            ofSetColor(_onGet);
        } else {
            ofSetColor(_offGet);
        }
        ofFill();
        ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, _r / 2);
    }
    ofPopStyle();
}

//--------------------------------------------------------------
void GUI::touchDown(ofTouchEventArgs & touch){
    if (touch.x > settingsX && touch.y < settingsHeight) {
        settingsMenu = true;
    }
}

//--------------------------------------------------------------
void GUI::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void GUI::touchUp(ofTouchEventArgs & touch){
    settingsMenu = false;
}

//--------------------------------------------------------------
void GUI::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void GUI::touchCancelled(ofTouchEventArgs & touch){
    
}


//--------------------------------------------------------------


void GUI::oscSent(int _sentTime){
    sentTime = _sentTime;
    oscSendLight = true;
}


void GUI::oscEvent(int _receivedTime) {
    receivedTime = _receivedTime;
    oscReceiveLight = true;
}

//--------------------------------------------------------------
void GUI::lostFocus(){
    
}

//--------------------------------------------------------------
void GUI::gotFocus(){
    
}

//--------------------------------------------------------------
void GUI::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void GUI::deviceOrientationChanged(int newOrientation){
    
}

//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------

void PAGE::pageButton(float _x, float _y, float _w, float _h, float _r, ofColor _stroke, float _weight, ofColor _onFill, ofColor _offFill) {
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    ofSetColor(_stroke);
    ofFill();
    ofDrawRectRounded(_x, _y, _w, _h, _r);
    if (this-> clicked) {
        ofSetColor(_onFill);
    } else {
    ofSetColor(_offFill);
    }
    ofFill();
    ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, _r);
    ofPopStyle();
}

//--------------------------------------------------------------
void PAGE::touchDown(ofTouchEventArgs & touch){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        this-> clicked = true;
        this-> action = true;
    }
}
