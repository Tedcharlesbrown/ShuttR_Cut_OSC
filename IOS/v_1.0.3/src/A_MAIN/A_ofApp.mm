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
        connect(true, true, true);
    }

    shutterPage.clicked = true;
    
    shutterPageSetup();
    focusPageSetup();
    formPageSetup();
    imagePageSetup();
    DSPageSetup();
    settingsSetup();
    intensityOverlay.setup();
    
    ofAddListener(intensityOverlay.oscOutputEvent, this, &ofApp::sendIntensity);
}

//--------------------------------------------------------------

void ofApp::update() {
    oscEvent(); //C++ version = Receive events
    stateUpdate();
        
    keyboard.update();
    intensityOverlay.update();
    
    intensityButtonAction();
    channelButtonAction();
    
    topBarUpdate();
    pageButtonAction();
    oscLightUpdate();
    buttonAction();
    settingsUpdate();
    
    heartBeat();
}

//--------------------------------------------------------------
// MARK: ---------- PAGE BUTTONS ----------
//--------------------------------------------------------------

void ofApp::pageButtonAction() {
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageUpdate();
    } else if (focusPage.clicked && !settingsMenu) {
        focusPageUpdate();
    } else if (formPage.clicked && !settingsMenu) {
        formPageUpdate();
    } else if (imagePage.clicked && !settingsMenu) {
        imagePageUpdate();
    } else if (dSelectPage.clicked && !settingsMenu) {
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
        if (channelInt >= 50) {
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
    if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked || dSelectPage.clicked) && !settingsMenu) {
        if (keyboard.clickedOff) {
            selectedChannel = oldChannel;
            channelButton.clicked = false;
            keyboard.close();
        } else if (channelButton.action && channelButton.clicked) {
            if (syntaxError) {
                sendKey("clear_cmdline");
            }
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
// MARK: ---------- INTENSITY BUTTON ----------
//--------------------------------------------------------------

void ofApp::intensityButtonAction() {
    if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked || dSelectPage.clicked) && !settingsMenu) {
        if (intensityOverlay.clickedOff || plusButton.action || minusButton.action || channelButton.action) {
            intensityButton.clicked = false;
            intensityOverlay.close();
        } else if (intensityButton.action && intensityButton.clicked) {
            intensityButton.action = false;
            intensityOverlay.open();
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
    
    if (shutterPage.clicked && !settingsMenu && !intensityOverlay.show) {
        shutterPageDraw();
    }
    if (focusPage.clicked && !settingsMenu && !intensityOverlay.show) {
        focusPageDraw();
    }
    if (formPage.clicked && !settingsMenu && !intensityOverlay.show) {
        formPageDraw();
    }
    if (imagePage.clicked && !settingsMenu && !intensityOverlay.show) {
        imagePageDraw();
    }
    if (dSelectPage.clicked && !settingsMenu && !intensityOverlay.show) {
        DSPageDraw();
    }
    if (settingsMenu) {
        settingsDraw();
    }
        
    if ((shutterPage.clicked || formPage.clicked|| focusPage.clicked || imagePage.clicked) && !settingsMenu) {
        string channel = "SELECTED CHANNEL";
        minusButton.show("-",guiLeftAlign,row1Padding + buttonHeight / 2, smallButtonWidth,buttonHeight,"LARGE");
        plusButton.show("+",guiRightAlign,row1Padding + buttonHeight / 2, smallButtonWidth,buttonHeight,"LARGE");
        fineButton.show("FINE",guiLeftAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        highButton.show("HIGH",guiCenterAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        flashButton.show("FLASH",guiRightAlign,row2Padding,genericButtonWidth,buttonHeight,"LARGE");
        
        intensityButton.showInt(channelIntString,centerX,row1Padding + buttonHeight / 2, channelButtonWidth, buttonHeight * 1.5);
        
        if (syntaxError) {
            channelButton.show("SYNTAX ERROR", centerX,row1Padding, channelButtonWidth, buttonHeight, "SMALL", EOSLightRed);
        } else if (selectedChannel.length() <= 10) {
            channelButton.show(selectedChannel, centerX,row1Padding, channelButtonWidth, buttonHeight, "LARGE");
        } else if (selectedChannel.length() > 10 && selectedChannel.length() < 15) {
            channelButton.show(selectedChannel, centerX,row1Padding, channelButtonWidth, buttonHeight, "MEDIUM");
        } else if (selectedChannel.length() >= 15) {
            channelButton.show(selectedChannel, centerX,row1Padding, channelButtonWidth, buttonHeight, "SMALL");
        }
        
        fontTiny.drawString(channel, centerX - fontTiny.stringWidth(channel) / 2, row1Padding - buttonHeight / 2 - fontTiny.stringHeight(channel) / 2);
    }
    topBarDraw();
    keyboard.draw();
    intensityOverlay.draw();
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::touchDown(ofTouchEventArgs & touch){
    // ---------- SETTINGS + INTOVERLAY RESET ----------
    if (touch.x > settingsX && touch.y < settingsHeight && touch.y > notchHeight) {
        settingsMenu = !settingsMenu;
        channelButton.clicked = false;
        intensityOverlay.close();
        intensityButton.clicked = false;
    }
    
    // ---------- TOP BAR BUTTONS ----------
    shutterPage.touchDown(touch);   
    focusPage.touchDown(touch);     
    formPage.touchDown(touch);      
    imagePage.touchDown(touch);     
    dSelectPage.touchDown(touch);   
    
    // ---------- TOP GUI BUTTONS ----------
    if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked) && !keyboard.show) {
        minusButton.touchDown(touch);
        plusButton.touchDown(touch);
        fineButton.touchDown(touch, true);
        highButton.touchDown(touch, true);
        flashButton.touchDown(touch);
        channelButton.touchDown(touch, true);
        intensityButton.touchDown(touch,true);
    }
    
    // ---------- PAGE ROUTING ----------
    if (shutterPage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
        shutterPageTouchDown(touch);
    } else if (focusPage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
        focusPageTouchDown(touch);
    } else if (formPage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
        formPageTouchDown(touch);
    } else if (imagePage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
        imagePageTouchDown(touch);
    } else if (dSelectPage.clicked && !settingsMenu) {
        DSPageTouchDown(touch);
    } else if (settingsMenu) {
        ipFieldButton.touchDown(touch, true);
        idFieldButton.touchDown(touch, true);
    }
    // ---------- OVERLAYS ----------
    if (keyboard.show) {
        keyboard.touchDown(touch);
    }
    if (intensityOverlay.show) {
        intensityOverlay.touchDown(touch);
    }
}

//--------------------------------------------------------------

void ofApp::touchMoved(ofTouchEventArgs & touch){
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageTouchMoved(touch);
    } else if (focusPage.clicked && !settingsMenu) {
        focusPageTouchMoved(touch);
    } else if (formPage.clicked && !settingsMenu) {
        formPageTouchMoved(touch);
    } else if (imagePage.clicked && !settingsMenu) {
        imagePageTouchMoved(touch);
    }
    
    if (intensityButton.clicked && !settingsMenu) {
        intensityOverlay.touchMoved(touch, fineButton.clicked);
    }
}

//--------------------------------------------------------------

void ofApp::touchUp(ofTouchEventArgs & touch){
    if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked) && !keyboard.show) {
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    }
    
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageTouchUp(touch);
    } else if (focusPage.clicked && !settingsMenu && !keyboard.show) {
        focusPageTouchUp(touch);
    } else if (formPage.clicked && !settingsMenu) {
        formPageTouchUp(touch);
    } else if (imagePage.clicked && !settingsMenu) {
        imagePageTouchUp(touch);
    } else if (dSelectPage.clicked && !settingsMenu) {
        DSPageTouchUp(touch);
    }
    
    keyboard.touchUp(touch);
    intensityOverlay.touchUp(touch);
}

//--------------------------------------------------------------

void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    if (shutterPage.clicked && !settingsMenu) {
        shutterPageDoubleTap(touch);
    } else if (focusPage.clicked && !settingsMenu && !keyboard.show) {
        focusPageDoubleTap(touch);
    } else if (formPage.clicked && !settingsMenu) {
        formPageDoubleTap(touch);
    } else if (dSelectPage.clicked && !settingsMenu) {
        DSPageDoubleTap(touch);
    }
    
    if (intensityButton.clicked && !settingsMenu) {
        intensityOverlay.touchDoubleTap(touch);
    }
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
