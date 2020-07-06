#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::topBarUpdate() {
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


//--------------------------------------------------------------

void GUI::topBarShow() {
    settingsBar(0,0,width,settingsBarHeight,settingsBarStrokeWeight);
    settingsButton(width - smallButtonWidth, 0, smallButtonWidth, settingsBarHeight, buttonStrokeWeight);
    oscLight("TX", smallButtonWidth / 2, settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
    oscLight("RX", smallButtonWidth / 2, settingsBarHeight - settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
}

//--------------------------------------------------------------

void GUI::settingsBar(float _x, float _y, float _w, float _h, float _weight) {
    ofPushStyle();
    ofSetColor(EOSDarkGrey);
    ofDrawRectangle(_x, _y, _w, _h);
    ofSetColor(shutterOutsideStroke);
    ofDrawRectangle(_x, _h, _w, _weight);
    ofPopStyle();
    
    pageOne.show(centerX - genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight);
    pageTwo.show(centerX, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight);
    pageThree.show(centerX + genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight);
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
