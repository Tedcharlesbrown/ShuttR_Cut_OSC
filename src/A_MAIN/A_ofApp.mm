#include "A_ofApp.h"

bool settingsMenu = false;

//--------------------------------------------------------------
// MARK: ---------- GUI / SETUP AND DRAW ----------
//--------------------------------------------------------------

void ofApp::setup() {
    getNotchHeight();
    
    ofEnableSmoothing();
    ofSetCircleResolution(128);
    IPAddress = getIPAddress();
    styleInit();
    getXML();
        
    if (inputIP.length() > 0) {
        connect();
    }

    shutterPage.clicked = true;
    
    shutterPageSetup();
    panTiltPageSetup();
    encoderPageSetup();
    DSPageSetup();
    settingsSetup();

}

//--------------------------------------------------------------

void ofApp::update() {
    oscEvent();
    stateUpdate();
    
    keyboard.update();
    
    topBarUpdate();
    pageButtonAction();
    oscLightUpdate();
    buttonAction();
    settingsUpdate();
    channelButtonAction();
    
    heartBeat();
}

//--------------------------------------------------------------
// MARK: ---------- PAGE BUTTONS ----------
//--------------------------------------------------------------

void ofApp::pageButtonAction() {
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

void ofApp::buttonAction() {
    if (minusButton.action) {
        sendChannel("last");
        minusButton.action = false;
    }
    if (plusButton.action) {
        sendChannel("next");
        plusButton.action = false;
    }
    if (highButton.action) {
        sendHigh();
        highButton.action = false;
    }
    if (flashButton.action) {
        if (channelInt >= 90) {
            sendFlash("FLASH_OFF");
        } else {
            sendFlash("FLASH_ON");
        }
        flashButton.action = false;
        
    }
    if (flashButton.released) {
        sendFlash("OFF");
        flashButton.released = false;
    }
}

//--------------------------------------------------------------
// MARK: ---------- CHANNEL BUTTON ----------
//--------------------------------------------------------------

void ofApp::channelButtonAction() {
    if ((shutterPage.clicked || panTiltPage.clicked || encoderPage.clicked || directSelectPage.clicked) && !settingsMenu) {
        if (keyboard.clickedOff) {
            selectedChannel = oldChannel;
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
                sendChannelNumber(selectedChannel);
            }
        }
    }
}

//--------------------------------------------------------------
// MARK: ---------- OSC LIGHT ----------
//--------------------------------------------------------------

void ofApp::oscLightUpdate() {
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

void ofApp::draw() {
    ofBackground(EOSBackground);
    
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

void ofApp::touchDown(ofTouchEventArgs & touch){
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

void ofApp::touchMoved(ofTouchEventArgs & touch){
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

void ofApp::touchUp(ofTouchEventArgs & touch){
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

void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
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

void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------

void ofApp::lostFocus(){
    saveXML();
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    getXML();
    IPAddress = getIPAddress();
}

//--------------------------------------------------------------
