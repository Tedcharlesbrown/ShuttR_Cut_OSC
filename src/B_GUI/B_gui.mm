#include "A_ofApp.h"

bool settingsMenu = false;

void GUI::setup() {
    settingsHelp.load("settingsHelp.png");
}

//--------------------------------------------------------------

void GUI::update() {
    keyboard.update();
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
    if (ipFieldButton.clicked) {
        keyboard.open();
    } else {
        keyboard.close();
    }
}

//--------------------------------------------------------------


void GUI::draw() {
    settingsBar(0,0,width,settingsBarHeight,settingsBarStrokeWeight);
    settingsButton(width - smallButtonWidth, 0, smallButtonWidth, settingsBarHeight, buttonStrokeWeight);
    oscLight("TX", smallButtonWidth / 2, settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
    oscLight("RX", smallButtonWidth / 2, settingsBarHeight - settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
    topUIShow();
    if (settingsMenu) {
        settingsShow();
    }
    keyboard.draw();
}

//--------------------------------------------------------------

void GUI::settingsBar(float _x, float _y, float _w, float _h, float _weight) {
    ofPushStyle();
    ofSetColor(EOSDarkGrey);
    ofDrawRectangle(_x, _y, _w, _h);
    ofSetColor(shutterOutsideStroke);
    ofDrawRectangle(_x, _h, _w, _weight);
    ofPopStyle();
    
    pageOne.show(centerX - genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, false);
    pageTwo.show(centerX, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, false);
    pageThree.show(centerX + genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, false);
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

//--------------------------------------------------------------

void GUI::topUIShow() {
    string channel = "SELECTED CHANNEL";
    if ((pageOne.clicked || pageTwo.clicked) && !settingsMenu) {
        minusButton.show("-",guiLeftAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE", false);
        plusButton.show("+",guiRightAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE", false);
        fineButton.show("FINE",guiLeftAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE", false);
        highButton.show("HIGH",guiCenterAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE", false);
        flashButton.show("FLASH",guiRightAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE", false);
        channelButton.show("CHANNEL", centerX,row1Padding, activeChannelWidth, buttonHeight, "LARGE", false);
        fontTiny.drawString(channel, centerX - fontTiny.stringWidth(channel) / 2, row1Padding - buttonHeight / 2 - fontTiny.stringHeight(channel) / 2);
    }
    if (pageOne.clicked && !settingsMenu) {
        thrustButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight, false);
        angleButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight, false);
        shutterButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight, false);
    }
    if (pageTwo.clicked && !settingsMenu) {
        irisButton.show("IRIS", guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM", false);
        edgeButton.show("EDGE", guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM", false);
        zoomButton.show("ZOOM", guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM", false);
        frostButton.show("FROST", guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight, "MEDIUM", false);
        
        minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM", false);
        homeButton.show("HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM", false);
        plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM", false);
    }
}

//--------------------------------------------------------------


void GUI::settingsShow() {
    string IP = "IP ADDRESS";
    string ID = "USER";
    string TX = "TX PORT";
    string RX = "RX PORT";
    TXPort = "8000";
    RXPort = "9000";
    
    ipFieldButton.show("", centerX, row1Padding * 1.25, activeChannelWidth * 2, buttonHeight, "LARGE", true);
    fontMedium.drawString(IP, centerX - fontMedium.stringWidth(IP) / 2, row1Padding * 1.25 - fontSmall.stringHeight(IP) / 2 - buttonHeight / 2);
    
    idFieldButton.show("", guiLeftAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE", true);
    fontMedium.drawString(ID, guiLeftAlign - fontMedium.stringWidth(ID) / 2, row2Padding * 1.25 - fontSmall.stringHeight(ID) / 2 - buttonHeight / 2);
    
    outgoingButton.show("", guiCenterAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE", true);
    fontMedium.drawString(TX, guiCenterAlign - fontMedium.stringWidth(TX) / 2, row2Padding * 1.25 - fontSmall.stringHeight(TX) / 2 - buttonHeight / 2);
    
    incomingButton.show("", guiRightAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE", true);
    fontMedium.drawString(RX, guiRightAlign - fontMedium.stringWidth(RX) / 2, row2Padding * 1.25 - fontSmall.stringHeight(RX) / 2 - buttonHeight / 2);
    
    helpButton.show("?", guiRightAlign + buttonHeight, row1Padding * 1.25, buttonHeight, buttonHeight, "LARGE", true);
    
    if (helpButton.clicked) {
        //HELP IMAGE
        ofPushMatrix();
        ofTranslate(0,-buttonHeight * 1.25);
        float imageResize = width - plusMinusButtonWidth;
        settingsHelp.resize(imageResize, imageResize / 1.5);
        settingsHelp.draw(centerX - settingsHelp.getWidth() / 2,(height / 2) - settingsHelp.getHeight() / 2);
        //IP ADDRESS
        fontMedium.drawString(IPAddress, centerX - (fontMedium.stringWidth(IPAddress) / 2) + settingsHelp.getWidth() / 3.75, (height / 2) + settingsHelp.getHeight() / 2 - fontMedium.stringHeight(IPAddress) / 2);
        //RX PORT
        fontMedium.drawString(RXPort, centerX - (fontMedium.stringWidth(RXPort) / 2) - settingsHelp.getWidth() / 3.75, (height / 2) - fontMedium.stringHeight(RXPort) / 1.5);
        //TX PORT
        fontMedium.drawString(TXPort, centerX - (fontMedium.stringWidth(TXPort) / 2) + settingsHelp.getWidth() / 3.75, (height / 2) - fontMedium.stringHeight(TXPort) / 1.5);
        ofPopMatrix();
    }
    
    about();
}

void GUI::about() {
    string aboutOne = name + " " + version;
    string thisIP = "Local IP Address: " + IPAddress;
    string aboutTwo =  "\nMade by Ted Charles Brown";
    string aboutThree = "\nTedcharlesbrown.com";
    string aboutFour = "\nPlease email all questions / bugs / requests";
    string aboutFive = "\n to Tedcharlesbrown@gmail.com";
    
    fontMedium.drawString(aboutOne, centerX - fontMedium.stringWidth(aboutOne) / 2, height - fontSmall.stringHeight(aboutOne) * 5.75);
    fontMedium.drawString(thisIP, centerX - fontMedium.stringWidth(thisIP) / 2, height - fontSmall.stringHeight(aboutOne) * 4.25);
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
    pageThree.touchDown(touch);
    
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
    
    
    if (settingsMenu) {
        ipFieldButton.touchDown(touch);
        idFieldButton.touchDown(touch);
        outgoingButton.touchDown(touch);
        incomingButton.touchDown(touch);
        helpButton.touchDown(touch);
        
    }
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
