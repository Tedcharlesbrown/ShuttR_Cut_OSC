#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- TOP BAR - UPDATE / DRAW ----------
//--------------------------------------------------------------

void GUI::topBarUpdate() {
    if (shutterPage.action && shutterPage.clicked) {
        shutterPage.clicked = true; panTiltPage.clicked = false; encoderPage.clicked = false; directSelectPage.clicked = false;
        shutterPage.action = false;
        settingsMenu = false;
    } else if (panTiltPage.action && panTiltPage.clicked) {
        shutterPage.clicked = false; panTiltPage.clicked = true; encoderPage.clicked = false; directSelectPage.clicked = false;
        panTiltPage.action = false;
        settingsMenu = false;
    } else if (encoderPage.action && encoderPage.clicked) {
        shutterPage.clicked = false; panTiltPage.clicked = false; encoderPage.clicked = true; directSelectPage.clicked = false;
        encoderPage.action = false;
        settingsMenu = false;
    } else if (directSelectPage.action && directSelectPage.clicked) {
        shutterPage.clicked = false; panTiltPage.clicked = false; encoderPage.clicked = false; directSelectPage.clicked = true;
        directSelectPage.action = false;
        settingsMenu = false;
    }
}

//--------------------------------------------------------------

void GUI::topBarDraw() {
    statusBarDraw();
    settingsBar(0,notchHeight,width,settingsBarHeight,settingsBarStrokeWeight);
    settingsButton(width - settingsBarHeight, notchHeight, settingsBarHeight, settingsBarHeight, buttonStrokeWeight);
    oscLight("TX", smallButtonWidth / 2, (settingsBarHeight / 4) + notchHeight + settingsBarStrokeWeight, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
    oscLight("RX", smallButtonWidth / 2, (settingsBarHeight - settingsBarHeight / 4) + notchHeight, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
}

//--------------------------------------------------------------
// MARK: ---------- SETTINGS - BAR / BUTTON / LIGHT ----------
//--------------------------------------------------------------

void GUI::settingsBar(float _x, float _y, float _w, float _h, float _weight) {
    ofPushStyle();
    ofSetColor(EOSBarState);
    ofDrawRectangle(_x, _y, _w, _h); //Settings Bar Background
    ofSetColor(shutterOutsideStroke);
    if (notchHeight > 0) {
        ofDrawRectangle(_x, notchHeight, _w, _weight); //TOP BAR
    }
    ofDrawRectangle(_x, _h + notchHeight, _w, _weight); //BOTTOM BAR
    ofPopStyle();
  
    shutterPage.show(centerX - plusMinusButtonWidth * 1.5, (settingsBarHeight / 2) + notchHeight, plusMinusButtonWidth, settingsBarHeight);
    panTiltPage.show(centerX - plusMinusButtonWidth / 2, (settingsBarHeight / 2) + notchHeight, plusMinusButtonWidth, settingsBarHeight);
    encoderPage.show(centerX + plusMinusButtonWidth / 2, (settingsBarHeight / 2) + notchHeight, plusMinusButtonWidth, settingsBarHeight);
    directSelectPage.show(centerX + plusMinusButtonWidth * 1.5, (settingsBarHeight / 2) + notchHeight, plusMinusButtonWidth, settingsBarHeight);
}

//--------------------------------------------------------------

void GUI::settingsButton(float _x, float _y, float _w, float _h, float _weight) {
    this-> settingsX = _x;
    this-> settingsY = _y;
    this-> settingsWidth = _w;
    this-> settingsHeight = _h + notchHeight;
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

//--------------------------------------------------------------
// MARK: ---------- STATUS BAR DRAW ----------
//--------------------------------------------------------------

void GUI::statusBarDraw() {
    ofPushStyle();
    string amPM = "AM";
    if (ofGetHours() > 12) {
        amPM = "PM";
    }
    string hour = ofToString(ofGetHours() % 12);
    string minutes = ofToString(ofGetMinutes());
    if (ofGetMinutes() < 10) {
        minutes = "0" + minutes;
    }
    string time = hour + ":" + minutes + " " + amPM;
    string time24 = ofToString(ofGetHours()) + ":" + minutes;
    
    fontSmall.drawString(time, width - 150, notchHeight - fontSmall.stringHeight(time) / 2); //TIME
    
    fontSmall.drawString(appNameV, centerX - fontSmall.stringWidth(appNameV) / 2, notchHeight - fontSmall.stringHeight(appNameV) / 2); //APP NAME
    
    string WIFI = "BarbsWiFi 5G";
    fontSmall.drawString(WIFI,10, notchHeight - fontSmall.stringHeight("WIFI") / 2); //APP NAME
    ofPopStyle();
}
