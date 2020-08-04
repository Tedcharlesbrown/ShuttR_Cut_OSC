#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::topBarUpdate() {
    if (shutterPage.action && shutterPage.clicked) {
        shutterPage.clicked = true; encoderPage.clicked = false; directSelectPage.clicked = false;
        shutterPage.action = false;
        settingsMenu = false;
    } else if (encoderPage.action && encoderPage.clicked) {
        shutterPage.clicked = false; encoderPage.clicked = true; directSelectPage.clicked = false;
        encoderPage.action = false;
        settingsMenu = false;
    } else if (directSelectPage.action && directSelectPage.clicked) {
        shutterPage.clicked = false; encoderPage.clicked = false; directSelectPage.clicked = true;
        directSelectPage.action = false;
        settingsMenu = false;
    }
}


//--------------------------------------------------------------

void GUI::topBarDraw() {
    settingsBar(0,0,width,settingsBarHeight,settingsBarStrokeWeight);
    settingsButton(width - smallButtonWidth, 0, smallButtonWidth, settingsBarHeight, buttonStrokeWeight);
    oscLight("TX", smallButtonWidth / 2, settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
    oscLight("RX", smallButtonWidth / 2, settingsBarHeight - settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
}

//--------------------------------------------------------------

void GUI::settingsBar(float _x, float _y, float _w, float _h, float _weight) {
    ofPushStyle();
    ofSetColor(EOSBarState);
    ofDrawRectangle(_x, _y, _w, _h);
    ofSetColor(shutterOutsideStroke);
    ofDrawRectangle(_x, _h, _w, _weight);
    ofPopStyle();
  
    shutterPage.show(centerX - plusMinusButtonWidth * 1.5, settingsBarHeight / 2, plusMinusButtonWidth, settingsBarHeight);
    panTiltPage.show(centerX - plusMinusButtonWidth / 2, settingsBarHeight / 2, plusMinusButtonWidth, settingsBarHeight);
    encoderPage.show(centerX + plusMinusButtonWidth / 2, settingsBarHeight / 2, plusMinusButtonWidth, settingsBarHeight);
    directSelectPage.show(centerX + plusMinusButtonWidth * 1.5, settingsBarHeight / 2, plusMinusButtonWidth, settingsBarHeight);
}

//--------------------------------------------------------------

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

//--------------------------------------------------------------

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
