#include "D_button.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
void BUTTON::show(float _x, float _y, float _w, float _h, bool toggle) { //NO TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    this-> toggle = toggle;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(shutterOutsideStroke);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked && !settingsMenu) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofPopStyle();
}

void BUTTON::show(string _ID, float _x, float _y, float _w, float _h, string _size, bool toggle) { //ONE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    this-> toggle = toggle;
    
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
        fontLarge.drawString(_ID, _x - fontLarge.stringWidth(_ID) / 2, _y + fontLarge.stringHeight("+") / 1.25);//INPUT
    } else if (_size == "MEDIUM") {
        fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y + fontMedium.stringHeight(_ID) / 2);//INPUT
    }
    
    ofPopStyle();
}

void BUTTON::show(string _ID, string _ID2, float _x, float _y, float _w, float _h, bool toggle) { //DOUBLE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    this-> toggle = toggle;
    
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
    fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y);//INPUT
    fontSmall.drawString(_ID2, _x - fontSmall.stringWidth(_ID2) / 2, _y + fontMedium.stringHeight("+") * 1.25);//INPUT
    
    ofPopStyle();
}


//--------------------------------------------------------------
void BUTTON::touchDown(ofTouchEventArgs & touch, bool toggle){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        if (toggle && clicked) {
            this-> clicked = false;
        } else {
            this-> clicked = true;
            this-> action = true;
        }
    }
}

//--------------------------------------------------------------
void BUTTON::touchUp(ofTouchEventArgs & touch){
    if (!toggle) {
        this-> clicked = false;
    }
}

//--------------------------------------------------------------
void BUTTON::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
