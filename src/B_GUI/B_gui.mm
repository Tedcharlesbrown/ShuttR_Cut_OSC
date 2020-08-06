#include "A_ofApp.h"

bool settingsMenu = false;

void GUI::setup() {
    shutterPageSetup();
    panTiltPageSetup();
    encoderPageSetup();
    DSPageSetup();
    settingsSetup();
}

//--------------------------------------------------------------

void GUI::update() {
    keyboard.update();
    
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageUpdate();
    } else if (panTiltPage.clicked && !settingsMenu) {
        panTiltPageUpdate();
    } else if (encoderPage.clicked && !settingsMenu) {
        encoderPageUpdate();
    } else if (directSelectPage.clicked && !settingsMenu) {
        DSPageUpdate();
    }
    
    if (ofGetElapsedTimeMillis() > oscSentTime + 200) {
        oscSendLight = false;
        ignoreOSC = false;
    } else {
        oscSendLight = true;
    }
    if (ofGetElapsedTimeMillis() > oscReceivedTime + 200) {
        oscReceiveLight = false;
    } else {
        oscReceiveLight = true;
    }
    //--------------------------------------------------------------
    
    topBarUpdate();
    
    //--------------------------------------------------------------
    
    if (minusButton.action) {
        osc.sendChannel("last");
        minusButton.action = false;
    }
    if (plusButton.action) {
        osc.sendChannel("next");
        plusButton.action = false;
    }
    if (highButton.action) {
        osc.sendHigh();
        highButton.action = false;
    }
    if (flashButton.action) {
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
    
    if ((shutterPage.clicked || panTiltPage.clicked || encoderPage.clicked || directSelectPage.clicked) && !settingsMenu) {
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
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageDraw();
    }
    if (panTiltPage.clicked && !settingsMenu) {
        panTiltPageDraw();
    }
    if (encoderPage.clicked && !settingsMenu) {
        encoderPageDraw();
    }
    if (directSelectPage.clicked && !settingsMenu) {
        DSPageDraw();
    }
    if (settingsMenu) {
        settingsDraw();
    }
    if ((shutterPage.clicked || encoderPage.clicked|| panTiltPage.clicked) && !settingsMenu) {
        string channel = "SELECTED CHANNEL";
        minusButton.show("-",guiLeftAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE");
        plusButton.show("+",guiRightAlign,row1Padding,plusMinusButtonWidth,buttonHeight,"LARGE");
        fineButton.show("FINE",guiLeftAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        highButton.show("HIGH",guiCenterAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        flashButton.show("FLASH",guiRightAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        
        if (selectedChannel.length() <= 10) {
            channelButton.show(selectedChannel, centerX,row1Padding, activeChannelWidth, buttonHeight, "LARGE");
        } else if (selectedChannel.length() > 10 && selectedChannel.length() < 15) {
            channelButton.show(selectedChannel, centerX,row1Padding, activeChannelWidth, buttonHeight, "MEDIUM");
        } else if (selectedChannel.length() >= 15) {
            channelButton.show(selectedChannel, centerX,row1Padding, activeChannelWidth, buttonHeight, "SMALL");
        }
        
        fontTiny.drawString(channel, centerX - fontTiny.stringWidth(channel) / 2, row1Padding - buttonHeight / 2 - fontTiny.stringHeight(channel) / 2);
    }
    keyboard.draw();
}

//--------------------------------------------------------------
void GUI::touchDown(ofTouchEventArgs & touch){
    if (touch.x > settingsX && touch.y < settingsHeight) {
        settingsMenu = !settingsMenu;
        channelButton.clicked = false;
    }
    shutterPage.touchDown(touch);
    panTiltPage.touchDown(touch);
    encoderPage.touchDown(touch);
    directSelectPage.touchDown(touch);
    
    if (shutterPage.clicked && !settingsMenu && !keyboard.show) {
        shutterPageTouchDown(touch);
    } else if (panTiltPage.clicked && !settingsMenu && !keyboard.show) {
        panTiltPageTouchDown(touch);
    } else if (encoderPage.clicked && !settingsMenu && !keyboard.show) {
        encoderPageTouchDown(touch);
    } else if (directSelectPage.clicked && !settingsMenu) {
        DSPageTouchDown(touch);
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
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageTouchMoved(touch);
    }
    if (panTiltPage.clicked && !settingsMenu) {
        panTiltPageTouchMoved(touch);
    }
    if (encoderPage.clicked && !settingsMenu) {
        encoderPageTouchMoved(touch);
    }
}

//--------------------------------------------------------------
void GUI::touchUp(ofTouchEventArgs & touch){
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageTouchUp(touch);
    } else if (panTiltPage.clicked && !settingsMenu && !keyboard.show) {
        panTiltPageTouchUp(touch);
    } else if (encoderPage.clicked && !settingsMenu) {
        encoderPageTouchUp(touch);
    } else if (directSelectPage.clicked && !settingsMenu) {
        DSPageTouchUp(touch);
    }
    
    keyboard.touchUp(touch);
}

//--------------------------------------------------------------
void GUI::touchDoubleTap(ofTouchEventArgs & touch){
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageDoubleTap(touch);
    } else if (panTiltPage.clicked && !settingsMenu && !keyboard.show) {
        panTiltPageDoubleTap(touch);
    } else if (encoderPage.clicked && !settingsMenu) {
        //pageTwoDoubleTap(touch);
    } else if (directSelectPage.clicked && !settingsMenu) {
        DSPageDoubleTap(touch);
    }
}

//--------------------------------------------------------------
void GUI::touchCancelled(ofTouchEventArgs & touch){
    
}
