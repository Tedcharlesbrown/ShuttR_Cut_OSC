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

    topBarUpdate();
    
    //--------------------------------------------------------------
    
    pageTwoUpdate();
    
    //--------------------------------------------------------------
    
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
    topBarShow();
    
    if ((pageOne.clicked || pageTwo.clicked) && !settingsMenu) {
        string channel = "SELECTED CHANNEL";
        minusButton.show("-",guiLeftAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE");
        plusButton.show("+",guiRightAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE");
        fineButton.show("FINE",guiLeftAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        highButton.show("HIGH",guiCenterAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        flashButton.show("FLASH",guiRightAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        channelButton.show("CHANNEL", centerX,row1Padding, activeChannelWidth, buttonHeight, "LARGE");
        fontTiny.drawString(channel, centerX - fontTiny.stringWidth(channel) / 2, row1Padding - buttonHeight / 2 - fontTiny.stringHeight(channel) / 2);
    }
    if (pageOne.clicked && !settingsMenu) {
        pageOneShow();
    }
    if (pageTwo.clicked && !settingsMenu) {
        pageTwoShow();
    }
    if (settingsMenu) {
        settingsShow();
    }
    keyboard.draw();
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
