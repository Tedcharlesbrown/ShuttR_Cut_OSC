#include "D_button.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
void BUTTON::show(string _ID, float _x, float _y, float _w, float _h, string _size) {
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSLive);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    if (_size == "LARGE") {
        fontLarge.drawString(_ID, _x - fontLarge.stringWidth(_ID) / 2, _y + fontLarge.stringHeight(_ID) / 2);//INPUT
    } else if (_size == "MEDIUM") {
        fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y + fontMedium.stringHeight(_ID) / 2);//INPUT
    }
    
    ofPopStyle();
}
//--------------------------------------------------------------
void BUTTON::update() {
    
    
}

//--------------------------------------------------------------
void BUTTON::touchDown(ofTouchEventArgs & touch){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        this-> clicked = true;
        this-> action = true;
    }
}

//--------------------------------------------------------------
void BUTTON::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void BUTTON::touchUp(ofTouchEventArgs & touch){
    this-> clicked = false;
}

//--------------------------------------------------------------
void BUTTON::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void BUTTON::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------


