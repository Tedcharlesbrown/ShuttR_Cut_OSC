#include "A_ofApp.h"

bool settingsMenu = false;

//--------------------------------------------------------------
// MARK: ---------- GUI / SETUP AND DRAW ----------
//--------------------------------------------------------------

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
    
    topBarUpdate();
    pageButtonAction();
    oscLightUpdate();
    buttonAction();
    settingsUpdate();
    channelButtonAction();
    
}

//--------------------------------------------------------------
// MARK: ---------- PAGE BUTTONS ----------
//--------------------------------------------------------------

void GUI::pageButtonAction() {
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageUpdate();
    } else if (panTiltPage.clicked && !settingsMenu) {
        panTiltPageUpdate();
    } else if (encoderPage.clicked && !settingsMenu) {
        encoderPageUpdate();
    } else if (directSelectPage.clicked && !settingsMenu) {
        DSPageUpdate();
    }
}

//--------------------------------------------------------------
// MARK: ---------- GUI BUTTON ACTIONS ----------
//--------------------------------------------------------------

void GUI::buttonAction() {
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
}

//--------------------------------------------------------------
// MARK: ---------- CHANNEL BUTTON ----------
//--------------------------------------------------------------

void GUI::channelButtonAction() {
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
}

//--------------------------------------------------------------
// MARK: ---------- OSC LIGHT ----------
//--------------------------------------------------------------

void GUI::oscLightUpdate() {
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
}

//--------------------------------------------------------------
// MARK: ---------- DRAW ----------
//--------------------------------------------------------------

void GUI::draw() {
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
    topBarDraw();
    keyboard.draw();
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void GUI::touchDown(ofTouchEventArgs & touch){
    if (touch.x > settingsX && touch.y < settingsHeight && touch.y > notchHeight) {
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
