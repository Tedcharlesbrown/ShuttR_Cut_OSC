#include "D_button.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ----------NO TEXT----------
//--------------------------------------------------------------

void BUTTON::show(float _x, float _y, float _w, float _h) { //NO TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
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

//--------------------------------------------------------------
// MARK: ----------ONE LINE----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, float _x, float _y, float _w, float _h, string _size) { //ONE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSState);
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
    } else if (_size == "SMALL") {
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y + fontSmall.stringHeight(_ID) / 2);//INPUT
    }
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------ONE LINE - WITH COLOR----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, float _x, float _y, float _w, float _h, string _size, ofColor color) { //ONE TEXT WITH COLOR
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(color);
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
    } else if (_size == "SMALL") {
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y + fontSmall.stringHeight(_ID) / 2);//INPUT
    }
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------TWO LINE----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, string _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y );//INPUT
    fontSmall.drawString(_ID2, _x - fontSmall.stringWidth(_ID2) / 2, _y + fontMedium.stringHeight("+") * 1.25);//INPUT
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------TWO LINE - WITH COLOR----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, string _ID2, float _x, float _y, float _w, float _h, string _size, ofColor color) { //DOUBLE TEXT WITH COLOR
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(color);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    if (_size == "LARGE") {
        fontLarge.drawString(_ID, _x - fontLarge.stringWidth(_ID) / 2, _y);
    } else if (_size == "MEDIUM") {
        fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y);
    } else if (_size == "SMALL") {
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y);
    }
    fontSmall.drawString(_ID2, _x - fontSmall.stringWidth(_ID2) / 2, _y + fontMedium.stringHeight("+") * 1.25);//INPUT
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------TWO LINE (WITH BOTTOM)----------
//--------------------------------------------------------------

void BUTTON::showBig(string _ID, string _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT WITH BOTTOM
    this-> x = _x;
    this-> y = _y + _h / 2;
    this-> w = _w;
    this-> h = _h * 1.5;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y + _h / 1.5, _w, _h, buttonCorner);
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y + _h / 1.5, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    
    ofSetColor(EOSState);
    
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y + fontMedium.stringHeight(_ID) / 2);//INPUT
    fontMedium.drawString(_ID2, _x - fontMedium.stringWidth(_ID2) / 2, _y + _h / 1.25 + fontMedium.stringHeight(_ID2) / 2);//INPUT
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------EVENTS----------
//--------------------------------------------------------------

void BUTTON::touchDown(ofTouchEventArgs & touch){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        this-> clicked = true;
        this-> action = true;
    }
}

//--------------------------------------------------------------
void BUTTON::touchDown(ofTouchEventArgs & touch, bool toggle){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        this-> clicked = !clicked;
        this-> action = true;
    }
}

//--------------------------------------------------------------
void BUTTON::touchUp(ofTouchEventArgs & touch){
    if (clicked) {
        this-> released = true;
    }
    this-> clicked = false;
    this-> doubleClicked = false;
}

//--------------------------------------------------------------
void BUTTON::touchDoubleTap(ofTouchEventArgs & touch){
    this-> doubleClicked = true;
}
//--------------------------------------------------------------

