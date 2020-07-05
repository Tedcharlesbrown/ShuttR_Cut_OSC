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
    
    pageOne.show(centerX - genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight);
    pageTwo.show(centerX, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight);
    pageThree.show(centerX + genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight);
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

void GUI::topUIShow() {
    string channel = "SELECTED CHANNEL";
    if ((pageOne.clicked || pageTwo.clicked) && !settingsMenu) {
        minusButton.show("-",guiLeftAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE");
        plusButton.show("+",guiRightAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE");
        fineButton.show("FINE",guiLeftAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        highButton.show("HIGH",guiCenterAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        flashButton.show("FLASH",guiRightAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        channelButton.show("CHANNEL", centerX,row1Padding, activeChannelWidth, buttonHeight, "LARGE");
        fontTiny.drawString(channel, centerX - fontTiny.stringWidth(channel) / 2, row1Padding - buttonHeight / 2 - fontTiny.stringHeight(channel) / 2);
    }
    if (pageOne.clicked && !settingsMenu) {
        thrustButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight);
        angleButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight);
        shutterButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight);
    }
    if (pageTwo.clicked && !settingsMenu) {
        irisButton.show("IRIS", guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM");
        edgeButton.show("EDGE", guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM");
        zoomButton.show("ZOOM", guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM");
        frostButton.show("FROST", guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM");
        
        minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
        homeButton.show("HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
        plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    }
    if (settingsMenu) {
        ipFieldButton.show("", centerX, row1Padding * 1.25, activeChannelWidth * 2, buttonHeight, "LARGE");
        idFieldButton.show("", centerX, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE");
        about();
    }
}

void GUI::about() {
    string aboutOne = name + " " + version;
    string aboutTwo =  "\nMade by Ted Charles Brown";
    string aboutThree = "\nTedcharlesbrown.com";
    string aboutFour = "\nPlease email all questions / bugs / requests";
    string aboutFive = "\n to Tedcharlesbrown@gmail.com";
    
    fontMedium.drawString(aboutOne, centerX - fontMedium.stringWidth(aboutOne) / 2, height - fontSmall.stringHeight(aboutOne) * 5);
    fontSmall.drawString(aboutTwo, centerX - fontSmall.stringWidth(aboutTwo) / 2, height - fontSmall.stringHeight(aboutOne) * 4);
    fontSmall.drawString(aboutThree, centerX - fontSmall.stringWidth(aboutThree) / 2, height - fontSmall.stringHeight(aboutOne) * 3);
    fontSmall.drawString(aboutFour, centerX - fontSmall.stringWidth(aboutFour) / 2, height - fontSmall.stringHeight(aboutOne) * 2);
    fontSmall.drawString(aboutFive, centerX - fontSmall.stringWidth(aboutFive) / 2, height - fontSmall.stringHeight(aboutOne) * 1);
}

//--------------------------------------------------------------
void GUI::touchDown(ofTouchEventArgs & touch){
    if (touch.x > settingsX && touch.y < settingsHeight) {
        settingsMenu = !settingsMenu;
    }
    pageOne.touchDown(touch);
    pageTwo.touchDown(touch);
    
    if ((pageOne.clicked || pageTwo.clicked) && !settingsMenu) {
        minusButton.touchDown(touch);
        plusButton.touchDown(touch);
        fineButton.touchDown(touch);
        highButton.touchDown(touch);
        flashButton.touchDown(touch);
        channelButton.touchDown(touch);
    }
    if (pageOne.clicked && !settingsMenu) {
        thrustButton.touchDown(touch);
        angleButton.touchDown(touch);
        shutterButton.touchDown(touch);
    }
    if (pageTwo.clicked && !settingsMenu) {
        irisButton.touchDown(touch);
        edgeButton.touchDown(touch);
        zoomButton.touchDown(touch);
        frostButton.touchDown(touch);
        minusPercentButton.touchDown(touch);
        homeButton.touchDown(touch);
        plusPercentButton.touchDown(touch);
    }
    
    pageThree.touchDown(touch);
}

//--------------------------------------------------------------
void GUI::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void GUI::touchUp(ofTouchEventArgs & touch){
    if ((pageOne.clicked || pageTwo.clicked) && !settingsMenu) {
        minusButton.touchUp(touch);
        plusButton.touchUp(touch);
        fineButton.touchUp(touch);
        highButton.touchUp(touch);
        flashButton.touchUp(touch);
        channelButton.touchUp(touch);
    }
    if (pageOne.clicked && !settingsMenu) {
        thrustButton.touchUp(touch);
        angleButton.touchUp(touch);
        shutterButton.touchUp(touch);
    }
    if (pageTwo.clicked && !settingsMenu) {
        irisButton.touchUp(touch);
        edgeButton.touchUp(touch);
        zoomButton.touchUp(touch);
        frostButton.touchUp(touch);
        minusPercentButton.touchUp(touch);
        homeButton.touchUp(touch);
        plusPercentButton.touchUp(touch);
    }
    
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
