#include "B_page.h"
#include "A_ofApp.h"

bool settingsMenu = false;

void GUI::update() {
    if (ofGetElapsedTimeMillis() > sentTime + 200) {
        oscSendLight = false;
    }
    if (ofGetElapsedTimeMillis() > receivedTime + 200) {
        oscReceiveLight = false;
    }
    //--------------------------------------------------------------
    if (pageOne.action && pageOne.clicked) {
        pageOne.clicked = true; pageTwo.clicked = false; pageThree.clicked = false;
        pageOne.action = false;
        settingsMenu = false;
    } else if (pageTwo.action && pageTwo.clicked) {
        pageOne.clicked = false; pageTwo.clicked = true; pageThree.clicked = false;
        pageTwo.action = false;
        settingsMenu = false;
    } else if (pageThree.action && pageThree.clicked) {
        pageOne.clicked = false; pageTwo.clicked = false; pageThree.clicked = true;
        pageThree.action = false;
        settingsMenu = false;
    }
}



void GUI::settingsBar(float _x, float _y, float _w, float _h, float _weight) {
    ofPushStyle();
    ofSetColor(EOSDarkGrey);
    ofDrawRectangle(_x, _y, _w, _h);
    ofSetColor(shutterOutsideStroke);
    ofDrawRectangle(_x, _h, _w, _weight);
    ofPopStyle();
    
    pageOne.pageButton(centerX - genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonStrokeWeight);
    pageTwo.pageButton(centerX, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonStrokeWeight);
    pageThree.pageButton(centerX + genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonStrokeWeight);
}

void GUI::settingsButton(float _x, float _y, float _w, float _h, float _weight) {
    this-> settingsX = _x;
    this-> settingsY = _y;
    this-> settingsWidth = _w;
    this-> settingsHeight = _h;
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(shutterOutsideStroke); //stroke
    ofDrawRectRounded(_x + _w / 2, _y + _h / 2, _w, _h, buttonCorner); //outer
    
    if (settingsMenu) {
        ofSetColor(white); //fill
    } else {
        ofSetColor(black); //fill
    }
    ofDrawRectRounded(_x + _w / 2, _y + _h / 2, _w - _weight, _h - _weight, buttonCorner); //inner
    ofSetColor(shutterOutsideStroke); //stroke
    ofDrawCircle(_x + _w / 2, _y + _h / 2, _w / 5); //circle
    
    ofPopStyle();
}

void GUI::oscLight(string _ID,float _x,float _y,float _w,float _h, float _weight){
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    if (_ID == "TX") {
        ofSetColor(black); //stroke
        ofFill();
        ofDrawRectRounded(_x, _y, _w, _h, buttonCorner / 2); //outer
        if (oscSendLight) {
            ofSetColor(EOSLightGreen); //fill
        } else {
            ofSetColor(EOSGreen); //fill
        }
        ofFill();
        ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, buttonCorner / 2);
    } else if (_ID == "RX") {
        ofSetColor(black); //stroke
        ofFill();
        ofDrawRectRounded(_x, _y, _w, _h, buttonCorner / 2);
        if (oscReceiveLight) {
            ofSetColor(EOSLightRed); //fill
        } else {
            ofSetColor(EOSRed); //fill
        }
        ofFill();
        ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, buttonCorner / 2);
    }
    ofPopStyle();
}

//--------------------------------------------------------------
void GUI::touchDown(ofTouchEventArgs & touch){
    if (touch.x > settingsX && touch.y < settingsHeight) {
        settingsMenu = !settingsMenu;
    }
    pageOne.touchDown(touch);
    pageTwo.touchDown(touch);
    pageThree.touchDown(touch);
}

//--------------------------------------------------------------
void GUI::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void GUI::touchUp(ofTouchEventArgs & touch){
    
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

void PAGE::pageButton(float _x, float _y, float _w, float _h, float _weight) {
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    ofSetColor(shutterOutsideStroke); //stroke
    ofFill();
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    if (this-> clicked && !settingsMenu) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofFill();
    ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, buttonCorner);
    ofPopStyle();
}

//--------------------------------------------------------------
void PAGE::touchDown(ofTouchEventArgs & touch){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        this-> clicked = true;
        this-> action = true;
    }
}
