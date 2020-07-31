#include "A_ofApp.h"

bool settingsMenu = false;

void GUI::setup() {
    pageOneSetup();
    pageTwoSetup();
    settingsSetup();
}

//--------------------------------------------------------------

void GUI::update() {
    keyboard.update();
    
    if (pageOne.clicked && !settingsMenu) {
        pageOneUpdate();
    } else if (pageTwo.clicked && !settingsMenu) {
        pageTwoUpdate();
    } else if (pageThree.clicked && !settingsMenu) {
        
    }
    
    if (ofGetElapsedTimeMillis() > sentTime + 200) {
        oscSendLight = false;
        ignoreOSC = false;
    }
    if (ofGetElapsedTimeMillis() > receivedTime + 200) {
        oscReceiveLight = false;
    }
    //--------------------------------------------------------------

    topBarUpdate();
    
    //--------------------------------------------------------------
    
    if (minusButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendChannel("last");
        minusButton.action = false;
    }
    if (plusButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendChannel("next");
        plusButton.action = false;
    }
    if (highButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        osc.sendHigh();
        highButton.action = false;
    }
    if (flashButton.action) {
        oscSent(ofGetElapsedTimeMillis());
        if (channelIntensity >= 90) {
            osc.sendFlash("FLASH_OFF");
        } else {
            osc.sendFlash("FLASH_ON");
        }
        flashButton.action = false;
    }
    if (flashButton.released) {
        osc.sendFlash("OFF");
        flashButton.released = false;
    }
    
    //---------------------------KEYBOARD----------------------------------
    //---------------------------CHANNEL-----------------------------------
    
    if ((pageOne.clicked || pageTwo.clicked) && !settingsMenu) {
        if (keyboard.clickedOff) {
            channelButton.clicked = false;
            keyboard.close();
        } else if (channelButton.action && channelButton.clicked) {
            oldChannel = selectedChannel;
            keyboard.input = "";
            channelButton.action = false;
            keyboard.open();
        }
        if (channelButton.clicked) {
            selectedChannel = keyboard.input;
        }
        if (keyboard.enter) {
            channelButton.clicked = false;
            keyboard.close();
            if (selectedChannel == "") {
                selectedChannel = oldChannel;
            } else {
//                oscSent(ofGetElapsedTimeMillis());
                noneSelected = false;
                osc.sendChannelNumber(selectedChannel);
            }
        }
    }
    
    //---------------------------SETTINGS PAGE -----------------------------------
    
    if (settingsMenu) {
        if (keyboard.clickedOff) {
            ipFieldButton.clicked = false; idFieldButton.clicked = false; outgoingButton.clicked = false; incomingButton.clicked = false;
            keyboard.close(); keySwitch = 0;
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
                    keySwitch = 0;
                }
                break;
            case 2:
                userInputID = keyboard.input;
                if (keyboard.enter) {
                    idFieldButton.clicked = false; keyboard.close();
                    inputID = userInputID;
                    consoleLog.push_back("SWITCHING TO USER: " + inputID);
                    connectRequest = true;
                    keySwitch = 0;
                }
                break;
            case 3:
                userInputTX = keyboard.input;
                if (keyboard.enter) {
                    outgoingButton.clicked = false; keyboard.close();
                    inputTX = userInputTX;
                    consoleLog.push_back("SENDING ON PORT: " + inputTX);
                    connectRequest = true;
                    keySwitch = 0;
                }
                break;
            case 4:
                userInputRX = keyboard.input;
                if (keyboard.enter) {
                    incomingButton.clicked = false; keyboard.close();
                    inputRX = userInputRX;
                    consoleLog.push_back("LISTENING ON PORT: " + inputRX);
                    connectRequest = true;
                    keySwitch = 0;
                }
                break;
        }
    }

}

//--------------------------------------------------------------


void GUI::draw() {
    topBarDraw();
    if (pageOne.clicked && !settingsMenu) {
        pageOneDraw();
    }
    if (pageTwo.clicked && !settingsMenu) {
        pageTwoDraw();
    }
    if (settingsMenu) {
        settingsDraw();
    }
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
    
    if (pageOne.clicked && !settingsMenu && !keyboard.show) {
        pageOneTouchDown(touch);
    } else if (pageTwo.clicked && !settingsMenu && !keyboard.show) {
        pageTwoTouchDown(touch);
    } else if (pageThree.clicked && !settingsMenu) {
        
    } else if (settingsMenu) {
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
    if (pageOne.clicked && !settingsMenu) {
        pageOneTouchMoved(touch);
    }
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
