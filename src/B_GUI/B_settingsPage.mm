#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- SETTINGS - SETUP / UPDATE / DRAW -------
//--------------------------------------------------------------

void ofApp::settingsSetup() {
    settingsHelp.load("settingsHelp.png");
    userInputIP = inputIP;
    userInputID = inputID;
    ipFieldButton.clicked = false; idFieldButton.clicked = false; outgoingButton.clicked = false; incomingButton.clicked = false; helpButton.clicked = false; //BUTTON INIT
}

//--------------------------------------------------------------

void ofApp::settingsUpdate() {
    if (settingsMenu) {
        if (keyboard.clickedOff) {
            ipFieldButton.clicked = false; idFieldButton.clicked = false;
            keyboard.close(); keySwitch = 0;
        } else if (ipFieldButton.action && ipFieldButton.clicked) {
            ipFieldButton.clicked = true; idFieldButton.clicked = false;
            ipFieldButton.action = false;
            keyboard.open(); keySwitch = 1;
            keyboard.input = userInputIP;
        } else if (idFieldButton.action && idFieldButton.clicked){
            ipFieldButton.clicked = false; idFieldButton.clicked = true;
            idFieldButton.action = false;
            keyboard.open(); keySwitch = 2;
            keyboard.input = userInputID;
        } else if (ipFieldButton.clicked || idFieldButton.clicked){
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
                    connect();
                    keySwitch = 0;
                }
                break;
            case 2:
                userInputID = keyboard.input;
                if (keyboard.enter) {
                    idFieldButton.clicked = false; keyboard.close();
                    inputID = userInputID;
                    console_log.push_back(log_UserSwitch + inputID);
//                    connect();
//                    connectRequest = true;
                    keySwitch = 0;
                }
                break;
        }
    }
}

//--------------------------------------------------------------

void ofApp::settingsDraw() {
    string IP = "IP ADDRESS";
    string ID = "USER";
    
    ipFieldButton.show(userInputIP, centerX, row1Padding * 1.25, activeChannelWidth * 2, buttonHeight, "LARGE");
    fontMedium.drawString(IP, centerX - fontMedium.stringWidth(IP) / 2, row1Padding * 1.25 - fontSmall.stringHeight(IP) / 2 - buttonHeight / 2);
    
    idFieldButton.show(userInputID, guiCenterAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE");
    fontMedium.drawString(ID, guiCenterAlign - fontMedium.stringWidth(ID) / 2, row2Padding * 1.25 - fontSmall.stringHeight(ID) / 2 - buttonHeight / 2);
    
    console();
    
    about();
}

//--------------------------------------------------------------
// MARK: ---------- CONSOLE LOG ----------
//--------------------------------------------------------------

void ofApp::console() {
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    ofSetColor(255);
    ofDrawRectRounded(guiCenterAlign, consolePadding, consoleWidth, consoleHeight, buttonCorner);
    
    ofSetColor(0);
    ofDrawRectRounded(guiCenterAlign, consolePadding, consoleWidth - settingsBarStrokeWeight, consoleHeight - settingsBarStrokeWeight, buttonCorner);
    
    
    ofPushMatrix();
    ofTranslate(- consoleWidth / 2.1, consolePadding + fontMedium.stringHeight("+") / 2);
    ofSetColor(255);
    fontSmall.drawString(console_log[console_log.size() - 4], guiCenterAlign, - consoleHeight / 3);
    fontSmall.drawString(console_log[console_log.size() - 3], guiCenterAlign, - consoleHeight / 9);
    fontSmall.drawString(console_log[console_log.size() - 2], guiCenterAlign, consoleHeight / 9);
    fontSmall.drawString(console_log[console_log.size() - 1], guiCenterAlign, consoleHeight / 3);
    if (console_log.size() > 4) {
        console_log.erase(console_log.begin());
    }
    ofPopMatrix(); ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ---------- ABOUT ----------
//--------------------------------------------------------------

void ofApp::about() {
    string aboutOne = appName + " " + version;
    string thisIP = "Local IP Address: " + IPAddress;
    string aboutTwo =  "Made by Ted Charles Brown | TedCharlesBrown.com";
    string aboutThree = "Please email all questions / bugs / requests";
    string aboutFour = "to Tedcharlesbrown@gmail.com";
    
    ofPushMatrix();
    ofTranslate(0,fontMedium.stringHeight(aboutOne));
    
    fontMedium.drawString(aboutOne, centerX - fontMedium.stringWidth(aboutOne) / 2, height - fontSmall.stringHeight(aboutOne) * 6.25); //5.75
    fontMedium.drawString(thisIP, centerX - fontMedium.stringWidth(thisIP) / 2, height - fontSmall.stringHeight(aboutOne) * 4.5); //4.25
    fontSmall.drawString(aboutTwo, centerX - fontSmall.stringWidth(aboutTwo) / 2, height - fontSmall.stringHeight(aboutOne) * 2.75);
    fontSmall.drawString(aboutThree, centerX - fontSmall.stringWidth(aboutThree) / 2, height - fontSmall.stringHeight(aboutOne) * 1.5);
    fontSmall.drawString(aboutFour, centerX - fontSmall.stringWidth(aboutFour) / 2, height - fontSmall.stringHeight(aboutOne) * 0.25);
    
    ofPopMatrix();
}
