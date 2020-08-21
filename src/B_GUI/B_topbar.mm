#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- TOP BAR - UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::topBarUpdate() {
    if (shutterPage.action && shutterPage.clicked) {
        shutterPage.clicked = true; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = false; dSelectPage.clicked = false;
        shutterPage.action = false;
        settingsMenu = false;
    } else if (focusPage.action && focusPage.clicked) {
        shutterPage.clicked = false; focusPage.clicked = true; formPage.clicked = false; imagePage.clicked = false;  dSelectPage.clicked = false;
        focusPage.action = false;
        settingsMenu = false;
    } else if (formPage.action && formPage.clicked) {
        shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = true; imagePage.clicked = false;  dSelectPage.clicked = false;
        formPage.action = false;
        settingsMenu = false;
    } else if (imagePage.action && imagePage.clicked) {
        shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = true;  dSelectPage.clicked = false;
        imagePage.action = false;
        settingsMenu = false;
    } else if (dSelectPage.action && dSelectPage.clicked) {
        shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = false;  dSelectPage.clicked = true;
        dSelectPage.action = false;
        settingsMenu = false;
    }
}

//--------------------------------------------------------------

void ofApp::topBarDraw() {
    statusBarDraw();
    settingsBar(0,notchHeight,width,settingsBarHeight,settingsBarStrokeWeight);
    settingsButton(width - settingsBarHeight, notchHeight, settingsBarHeight, settingsBarHeight, buttonStrokeWeight);
    oscLight("TX", lightWidth / 2, (settingsBarHeight / 4) + notchHeight + settingsBarStrokeWeight, lightWidth, settingsBarHeight / 2, buttonStrokeWeight);
    oscLight("RX", lightWidth / 2, (settingsBarHeight - settingsBarHeight / 4) + notchHeight, lightWidth, settingsBarHeight / 2, buttonStrokeWeight);
}

//--------------------------------------------------------------
// MARK: ---------- SETTINGS - BAR / BUTTON / LIGHT ----------
//--------------------------------------------------------------

void ofApp::settingsBar(float _x, float _y, float _w, float _h, float _weight) {
    ofPushStyle();
    ofSetColor(EOSBarState);
    ofDrawRectangle(_x, _y, _w, _h); //Settings Bar Background
    ofSetColor(shutterOutsideStroke);
    if (notchHeight > 0) {
        ofDrawRectangle(_x, notchHeight, _w, _weight); //TOP BAR
    }
    ofDrawRectangle(_x, _h + notchHeight, _w, _weight); //BOTTOM BAR
    ofPopStyle();
  
    bool imagePageTest = false;
    
    if (imagePageTest) {
        shutterPage.showPage("SHUTTER", centerX - smallButtonWidth * 1.5, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
        focusPage.showPage("FOCUS", centerX - smallButtonWidth / 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
        formPage.showPage("FORM", centerX + smallButtonWidth / 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
        dSelectPage.showPage("DS", centerX + smallButtonWidth * 1.5, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
    } else {
        shutterPage.showPage("SHUTTER", centerX - (smallButtonWidth / 1.1) * 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
        focusPage.showPage("FOCUS", centerX - smallButtonWidth / 1.1, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
        formPage.showPage("FORM", centerX, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
        imagePage.showPage("IMAGE", centerX + smallButtonWidth / 1.1, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
        dSelectPage.showPage("DS", centerX + (smallButtonWidth / 1.1) * 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
    }
}

//--------------------------------------------------------------

void ofApp::settingsButton(float _x, float _y, float _w, float _h, float _weight) {
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

void ofApp::oscLight(string _ID,float _x,float _y,float _w,float _h, float _weight){
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

void ofApp::statusBarDraw() {
    ofPushStyle();
    string amPM = "AM";
    if (ofGetHours() > 11) {
        amPM = "PM";
    }
    string hour = ofToString(ofGetHours() % 12);
    if (hour == "0") {
        hour = "12";
    }
    string minutes = ofToString(ofGetMinutes());
    if (ofGetMinutes() < 10) {
        minutes = "0" + minutes;
    }
    string time = hour + ":" + minutes + " " + amPM;
    string time24 = ofToString(ofGetHours()) + ":" + minutes;
    
    fontSmall.drawString(time, width - fontSmall.stringWidth(time) * 1.1, notchHeight - fontSmall.stringHeight(time) / 2); //TIME
    
    fontSmall.drawString(headerName, centerX - fontSmall.stringWidth(headerName) / 2, notchHeight - fontSmall.stringHeight(headerName) / 2); //APP NAME
    
//    string WIFI = "ShuttR" + version;
//    fontSmall.drawString(WIFI,10, notchHeight - fontSmall.stringHeight("WIFI") / 2); //APP NAME
    
    ofPopStyle();
}
