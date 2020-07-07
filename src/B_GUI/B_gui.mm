#include "A_ofApp.h"

bool settingsMenu = false;

void GUI::setup() {
    settingsHelp.load("settingsHelp.png");
    encoder.load("Encoder.png");
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
    
    
    if (keyboard.clickedOff) {
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
            if (keyboard.enter) {
                ipFieldButton.clicked = false; keyboard.close();
                inputIP = userInputIP;
                consoleLog.push_back("CONNECTING TO: " + inputIP);
                connectRequest = true;
            }
            break;
        case 2:
            userInputID = keyboard.input;
            if (keyboard.enter) {
                idFieldButton.clicked = false; keyboard.close();
                inputID = userInputID;
                consoleLog.push_back("SWITCHING TO USER: " + inputID);
                connectRequest = true;
            }
            break;
        case 3:
            userInputTX = keyboard.input;
            if (keyboard.enter) {
                outgoingButton.clicked = false; keyboard.close();
                inputTX = userInputTX;
                consoleLog.push_back("SENDING ON PORT: " + inputTX);
                connectRequest = true;
            }
            break;
        case 4:
            userInputRX = keyboard.input;
            if (keyboard.enter) {
                incomingButton.clicked = false; keyboard.close();
                inputRX = userInputRX;
                consoleLog.push_back("LISTENING ON PORT: " + inputRX);
                connectRequest = true;
            }
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
        channelButton.show(selectedChannel, centerX,row1Padding, activeChannelWidth, buttonHeight, "LARGE");
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
    
    if (pageOne.clicked && !settingsMenu) {
        pageOneTouchDown(touch);
    } else if (pageTwo.clicked && !settingsMenu) {
        pageTwoTouchDown(touch);
    } else if (pageThree.clicked && !settingsMenu) {
        
    }else if (settingsMenu) {
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
    if (pageTwo.clicked && !settingsMenu) {
        pageTwoTouchMoved(touch);
    }
}

//--------------------------------------------------------------
void GUI::touchUp(ofTouchEventArgs & touch){
    if (pageOne.clicked && !settingsMenu) {
        pageOneTouchUp(touch);
    } else if (pageTwo.clicked && !settingsMenu) {
        pageTwoTouchUp(touch);
    } else if (pageThree.clicked && !settingsMenu) {
        
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
