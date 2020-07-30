#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::settingsSetup() {
    settingsHelp.load("settingsHelp.png");
    userInputIP = inputIP;
    userInputID = inputID;
    userInputRX = inputRX;
    userInputTX = inputTX;
    ipFieldButton.clicked = false; idFieldButton.clicked = false; outgoingButton.clicked = false; incomingButton.clicked = false; helpButton.clicked = false; //BUTTON INIT
}

//--------------------------------------------------------------

void GUI::settingsDraw() {
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
        ofPushStyle(); ofPushMatrix();
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
        ofPopStyle(); ofPopMatrix();
    } else {
        console();
    }
    
    about();
}

//--------------------------------------------------------------

void GUI::console() {
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    ofSetColor(255);
    ofDrawRectRounded(guiCenterAlign, consolePadding, consoleWidth, consoleHeight, buttonCorner);
    
    ofSetColor(0);
    ofDrawRectRounded(guiCenterAlign, consolePadding, consoleWidth - settingsBarStrokeWeight, consoleHeight - settingsBarStrokeWeight, buttonCorner);
    
    
    ofPushMatrix();
    ofTranslate(- consoleWidth / 2.1, consoleHeight / 20);
    ofSetColor(255);
    fontSmall.drawString(consoleLog[consoleLog.size() - 2], guiCenterAlign, consolePadding - fontMedium.stringHeight("+") / 2);
    fontSmall.drawString(consoleLog[consoleLog.size() - 1], guiCenterAlign, consolePadding + fontMedium.stringHeight("+"));
    if (consoleLog.size() > 2) {
        consoleLog.erase(consoleLog.begin());
    }
    ofPopMatrix(); ofPopStyle();
}

//--------------------------------------------------------------

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
