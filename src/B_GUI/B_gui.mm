#include "A_ofApp.h"

bool settingsMenu = false;

void GUI::setup() {
    settingsHelp.load("settingsHelp.png");
    userInputIP = inputIP;
    userInputID = inputID;
    userInputRX = inputRX;
    userInputTX = inputTX;
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
    
    if (irisButton.action && irisButton.clicked) {
        irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
        irisButton.action = false;
    } else if (edgeButton.action && edgeButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
        edgeButton.action = false;
    } else if (zoomButton.action && zoomButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
        zoomButton.action = false;
    } else if (frostButton.action && frostButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
        frostButton.action = false;
    }
    
    
    if (keyboard.enter) {
        ipFieldButton.clicked = false; idFieldButton.clicked = false; outgoingButton.clicked = false; incomingButton.clicked = false;
        keyboard.close();
        inputIP = userInputIP; inputID = userInputID; inputRX = userInputRX; inputTX = userInputTX;
    } else if (keyboard.clickedOff) {
        ipFieldButton.clicked = false; idFieldButton.clicked = false; outgoingButton.clicked = false; incomingButton.clicked = false;
        keyboard.close();
    } else if (ipFieldButton.action && ipFieldButton.clicked) {
        ipFieldButton.clicked = true; idFieldButton.clicked = false; outgoingButton.clicked = false; incomingButton.clicked = false;
        ipFieldButton.action = false;
        keyboard.open(); keySwitch = 1;
        keyboard.input = userInputIP;
    } else if (idFieldButton.action && idFieldButton.clicked){
        ipFieldButton.clicked = false; idFieldButton.clicked = true; outgoingButton.clicked = false; incomingButton.clicked = false;
        idFieldButton.action = false;
        keyboard.open(); keySwitch = 2;
        keyboard.input = userInputID;
    } else if (outgoingButton.action && outgoingButton.clicked){
        ipFieldButton.clicked = false; idFieldButton.clicked = false; outgoingButton.clicked = true; incomingButton.clicked = false;
        outgoingButton.action = false;
        keyboard.open(); keySwitch = 3;
        keyboard.input = userInputTX;
    } else if (incomingButton.action && incomingButton.clicked){
        ipFieldButton.clicked = false; idFieldButton.clicked = false; outgoingButton.clicked = false; incomingButton.clicked = true;
        incomingButton.action = false;
        keyboard.open(); keySwitch = 4;
        keyboard.input = userInputRX;
    } else if (ipFieldButton.clicked || idFieldButton.clicked || outgoingButton.clicked || incomingButton.clicked){
        keyboard.open();
    } else {
        keyboard.close();
    }
    switch(keySwitch) {
        case 1:
            userInputIP = keyboard.input;
            break;
        case 2:
            userInputID = keyboard.input;
            break;
        case 3:
            userInputTX = keyboard.input;
            break;
        case 4:
            userInputRX = keyboard.input;
            break;
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

//--------------------------------------------------------------

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
        irisButton.show("IRIS", "100%", guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight, true);
        edgeButton.show("EDGE", "40%", guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, true);
        zoomButton.show("ZOOM", "20%", guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, true);
        frostButton.show("FROST", "74%", guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight, true);
        
        minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
        homeButton.show("HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
        plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    }
}

//--------------------------------------------------------------


void GUI::settingsShow() {
    string IP = "IP ADDRESS";
    string ID = "USER";
    string TX = "TX PORT";
    string RX = "RX PORT";
    
    ipFieldButton.show(userInputIP, centerX, row1Padding * 1.25, activeChannelWidth * 2, buttonHeight, "LARGE");
    fontMedium.drawString(IP, centerX - fontMedium.stringWidth(IP) / 2, row1Padding * 1.25 - fontSmall.stringHeight(IP) / 2 - buttonHeight / 2);
    
    idFieldButton.show(userInputID, guiLeftAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE");
    fontMedium.drawString(ID, guiLeftAlign - fontMedium.stringWidth(ID) / 2, row2Padding * 1.25 - fontSmall.stringHeight(ID) / 2 - buttonHeight / 2);
    
    outgoingButton.show(userInputTX, guiRightAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE");
    fontMedium.drawString(TX, guiRightAlign - fontMedium.stringWidth(TX) / 2, row2Padding * 1.25 - fontSmall.stringHeight(TX) / 2 - buttonHeight / 2);
    
    incomingButton.show(userInputRX, guiCenterAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE");
    fontMedium.drawString(RX, guiCenterAlign - fontMedium.stringWidth(RX) / 2, row2Padding * 1.25 - fontSmall.stringHeight(RX) / 2 - buttonHeight / 2);
    
    helpButton.show("?", guiRightAlign + buttonHeight, row1Padding * 1.25, buttonHeight, buttonHeight, "LARGE");
    
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
        fontMedium.drawString(userInputTX, centerX - (fontMedium.stringWidth(userInputTX) / 2) - settingsHelp.getWidth() / 3.75, (height / 2) - fontMedium.stringHeight(userInputTX) / 1.5);
        //TX PORT
        fontMedium.drawString(userInputRX, centerX - (fontMedium.stringWidth(userInputRX) / 2) + settingsHelp.getWidth() / 3.75, (height / 2) - fontMedium.stringHeight(userInputRX) / 1.5);
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
        fineButton.touchDown(touch, true);
        highButton.touchDown(touch, true);
        flashButton.touchDown(touch);
        channelButton.touchDown(touch, true);
    }
    if (pageOne.clicked && !settingsMenu) {
        thrustButton.touchDown(touch);
        angleButton.touchDown(touch);
        shutterButton.touchDown(touch);
    }
    if (pageTwo.clicked && !settingsMenu) {
        irisButton.touchDown(touch, true);
        edgeButton.touchDown(touch, true);
        zoomButton.touchDown(touch, true);
        frostButton.touchDown(touch, true);
        minusPercentButton.touchDown(touch);
        homeButton.touchDown(touch);
        plusPercentButton.touchDown(touch);
    }
    
    
    if (settingsMenu) {
        ipFieldButton.touchDown(touch, true);
        idFieldButton.touchDown(touch, true);
        outgoingButton.touchDown(touch, true);
        incomingButton.touchDown(touch, true);
        helpButton.touchDown(touch, true);
        
    }
    
    if (keyboard.show) {
        keyboard.touchDown(touch);
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
        flashButton.touchUp(touch);
    }
    if (pageOne.clicked && !settingsMenu) {
        thrustButton.touchUp(touch);
        angleButton.touchUp(touch);
        shutterButton.touchUp(touch);
    }
    if (pageTwo.clicked && !settingsMenu) {
        minusPercentButton.touchUp(touch);
        homeButton.touchUp(touch);
        plusPercentButton.touchUp(touch);
    }
    
    keyboard.touchUp(touch);
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
