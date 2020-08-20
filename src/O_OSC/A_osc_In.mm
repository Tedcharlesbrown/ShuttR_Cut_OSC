#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::oscEvent() {
    while(eos.hasWaitingMessages()){
        oscReceivedTime = ofGetElapsedTimeMillis();
        isConnected = true;
        ofxEosOscMsg m = eos.getNextMessage();
        
        // ----------------------- GET SHOW NAME -----------------------
        if (m.getAddress() == "/eos/out/show/name") {
            headerName = m.getArgAsString(0);
            string headerAppend = "";
            int length = headerName.length();
            int maxLength = plusMinusButtonWidth * 4;
            if (fontSmall.stringWidth(headerName) > maxLength) {
                headerAppend = "...";
            }
            while (fontSmall.stringWidth(headerName) > maxLength) {
                headerName = headerName.substr(0,length);
                length--;
            }
            headerName = headerName + headerAppend;
        }
        // ----------------------- GET CONNECTION STATUS -----------------------
        if (m.getAddress() == "/eos/out/ping") {
            lastPing = ofGetElapsedTimeMillis();
            cout << lastPing << endl;
        }
        // ----------------------- GET ALL LIVE / BLIND STATUS -----------------------
        if (m.getAddress() == "/eos/out/event/state") {
            getState(m);
        }
        // ----------------------- GET LIGHT COLOR ----------------------------
        if (m.getAddress() == "/eos/out/color/hs" && m.getNumArgs() > 0) {
            getColor(m);
        }
        // ----------------------- GET COMMAND LINE -----------------------
        if (m.getAddress() == "/eos/out/user/" + inputID + "/cmd") {
            getCommandLine(m);
        }
        // ----------------------- GET ALL CHANNEL DATA -----------------------
        if (m.getAddress() == "/eos/out/active/chan") {
            getChannel(m);
        }
        // ----------------------- GET PAN TILT DATA -----------------------
        if (m.getAddress() == "/eos/out/pantilt") {
            getPanTilt(m);
        }
        // ----------------------- GET ALL WHEEL PARAMS -----------------------
        if (m.getAsString().find("/eos/out/active/wheel/") != string::npos) {
            getWheel(m);
        }
        // ----------------------- GET DIRECT SELECTS -----------------------
        if (m.getAsString().find("/eos/out/ds/") != string::npos) {
            for (int i = 1; i <= 2; i++) {
                for (int j = 1; j <= 20; j++) {
                    if (m.getAddress() == "/eos/out/ds/" + ofToString(i) + "/" + ofToString(j)) {
                        getDirectSelect(i,j,m);
                    }
                }
            }
            
        }
    }
}

//--------------------------------------------------------------

void ofApp::getState(ofxEosOscMsg m){
    switch(m.getArgAsInt(0)) {
        case 0: //BLIND
            isLive = false;
            break;
        case 1: //LIVE
        default:
            isLive = true;
            break;
    }
}

//--------------------------------------------------------------

void ofApp::getCommandLine(ofxEosOscMsg m){
    string incomingOSC = m.getArgAsString(0);
    
    if (incomingOSC.find("Highlight :") != string::npos) {
        highButton.clicked = true;
    } else {
        highButton.clicked = false;
    }
    
    if (incomingOSC.find("Thru") != string::npos && incomingOSC.find("#") != string::npos) {
        int indexValueStart = incomingOSC.find("Chan") + 5;
        incomingOSC = incomingOSC.substr(indexValueStart);
        
        int indexValueEnd = incomingOSC.find(" Thru");
        string firstNumber = incomingOSC.substr(0, indexValueEnd);
        
        indexValueStart = incomingOSC.find("Thru") + 5;
        
        if (incomingOSC.find("#") < incomingOSC.find(":")) {
            indexValueEnd = incomingOSC.find("#");
        } else {
            indexValueEnd = incomingOSC.find(":");
        }
        
        string secondNumber = incomingOSC.substr(indexValueStart, indexValueEnd - indexValueStart - 1);
        multiChannelPrefix = firstNumber + "-" + secondNumber;
    } else if (incomingOSC.find("Group") != string::npos && incomingOSC.find("#") != string::npos) {
        int indexValueStart = incomingOSC.find("Group") + 6;
        incomingOSC = incomingOSC.substr(indexValueStart);
        
        int indexValueEnd = 0;
        if (incomingOSC.find("#") < incomingOSC.find(":")) {
            indexValueEnd = incomingOSC.find("#") - 1;
        } else {
            indexValueEnd = incomingOSC.find(":") - 1;
        }
        
        incomingOSC = incomingOSC.substr(0,indexValueEnd);
        multiChannelPrefix = "Gr " + incomingOSC;
        
    } else if (incomingOSC.find("#") != string::npos){
        multiChannelPrefix = "";
    }
    
}

//--------------------------------------------------------------

void ofApp::getPanTilt(ofxEosOscMsg m) {
    if (m.getNumArgs() > 0) {
        hasPanTilt = true;
        int panPercentInt = m.getArgAsFloat(4);
        int tiltPercentInt = m.getArgAsFloat(5);
        panPercent = ofToString(panPercentInt) + " %";
        tiltPercent = ofToString(tiltPercentInt) + " %";
    }
    if (!hasPanTilt) {
        panPercent = noParameter;
        tiltPercent = noParameter;
    }
}

//--------------------------------------------------------------

void ofApp::getWheel(ofxEosOscMsg m){
    for (int i = 0; i < 200; i++) {
        if (m.getAddress() == "/eos/out/active/wheel/" + ofToString(i) && m.argHasPercent(0) && !ignoreOSC) {
            string incomingOSC = m.getArgAsString(0);
            
            float outputInt = ofToFloat(m.getArgPercent(0));
            float outputBinary = ofMap(outputInt, 0, 100, 1, clickDiameter / assemblyRadius);
            if (incomingOSC.find("Intens") != string::npos) { //INTENSITY
                channelInt = ofToInt(m.getArgPercent(0));
                channelInt255 = ofMap(channelInt,0,100,50,255);
                shutterColor.setHsb(channelHue,channelSat,channelInt255);
            } else if (incomingOSC.find("Thrust A") != string::npos) { //Thrust A
                thrustA.buttonA.position = outputBinary;
                hasShutters = true;
            } else if (incomingOSC.find("Angle A") != string::npos) { //Angle A
                angleA.rotateAngle = -outputInt;
                hasShutters = true;
            } else if (incomingOSC.find("Thrust B") != string::npos) { //Thrust B
                thrustB.buttonB.position = outputBinary;
                hasShutters = true;
            } else if (incomingOSC.find("Angle B") != string::npos) { //Angle B
                angleB.rotateAngle = -outputInt;
                hasShutters = true;
            } else if (incomingOSC.find("Thrust C") != string::npos) { //Thrust C
                thrustC.buttonC.position = outputBinary;
                hasShutters = true;
            } else if (incomingOSC.find("Angle C") != string::npos) { //Angle C
                angleC.rotateAngle = -outputInt;
                hasShutters = true;
            } else if (incomingOSC.find("Thrust D") != string::npos) { //Thrust D
                thrustD.buttonD.position = outputBinary;
                hasShutters = true;
            } else if (incomingOSC.find("Angle D") != string::npos) { //Angle D
                angleD.rotateAngle = -outputInt;
                hasShutters = true;
            } else if (incomingOSC.find("Frame Assembly") != string::npos) { //Frame Assembly
                assembly.incomingOSC(outputInt);
                hasShutters = true;
            } else if (incomingOSC.find("Iris") != string::npos) { //IRIS
                irisPercent = m.getArgPercent(0) + " %";
                hasIris = true;
            } else if (incomingOSC.find("Edge") != string::npos) { //EDGE
                edgePercent = m.getArgPercent(0) + " %";
                hasEdge = true;
            } else if (incomingOSC.find("Zoom") != string::npos) { //ZOOM
                zoomPercent = m.getArgPercent(0) + " %";
                hasZoom = true;
            } else if (incomingOSC.find("Diffusn") != string::npos) { //FROST
                frostPercent = m.getArgPercent(0) + " %";
                hasFrost = true;
            }
        }
    }
    if (!hasShutters) {//Do Something
        shutterColor.setHsb(0,0,100);
    }
    if (!hasIris) {
        irisPercent = noParameter;
    }
    if (!hasEdge) {
        edgePercent = noParameter;
    }
    if (!hasZoom) {
        zoomPercent = noParameter;
    }
    if (!hasFrost) {
        frostPercent = noParameter;
    }
}

//--------------------------------------------------------------

void ofApp::getChannel(ofxEosOscMsg m) {
    string incomingOSC = m.getArgAsString(0);
    
    if (incomingOSC.length() > 0) {
        noneSelected = false;
        int oscLength = incomingOSC.length();
        int indexValueEnd = incomingOSC.find(" ");
        incomingOSC = incomingOSC.substr(0,indexValueEnd);
        if (oscLength == 5 + incomingOSC.length()) { //IF NO CHANNEL IS PATCHED (OFFSET BY LENGTH OF CHANNEL NUMBER)
            selectedChannel = "(" + incomingOSC + ")";
            irisPercent = noParameter; edgePercent = noParameter; zoomPercent = noParameter; frostPercent = noParameter;
            panPercent = noParameter; tiltPercent = noParameter;
        } else {
            if (incomingOSC.find("-") != string::npos || incomingOSC.find(",") != string::npos) {
                selectedChannel = multiChannelPrefix;
            } else if (multiChannelPrefix.length() > 0) {
                selectedChannel = multiChannelPrefix + " : " + incomingOSC;
            } else {
                selectedChannel = incomingOSC;
            }
        }
    } else { // IF NO CHANNEL IS SELECTED
        noneSelected = true;
        selectedChannel = "---";
        
        clearParams();
    }
}

//--------------------------------------------------------------

void ofApp::getColor(ofxEosOscMsg m){
    if (m.getNumArgs() > 0) {
        channelHue = m.getArgAsFloat(0);
        channelSat = m.getArgAsFloat(1);
        channelHue = ofMap(channelHue,0,360,0,255);
        channelSat = ofMap(channelSat,0,100,0,255);
        shutterColor.setHsb(channelHue,channelSat,channelInt255);
    }
}

//--------------------------------------------------------------

void ofApp::getDirectSelect(int bank, int buttonID, ofxEosOscMsg m){
    string dNumber = "";
    if (m.argHasPercent(0)) {
        dNumber = "(" + m.getArgPercent(0) + ")";
    }
    
    string dName = m.getArgAsString(0);
    int indexValueEnd = dName.find(" [");
    
    dName = dName.substr(0, indexValueEnd);
    
    if (bank == 1) {
        bankOne.bankText.at(buttonID - 1) = dName;
        bankOne.bankNumber.at(buttonID - 1) = dNumber;
    } else if (bank == 2) {
        bankTwo.bankText.at(buttonID - 1) = dName;
        bankTwo.bankNumber.at(buttonID - 1) = dNumber;
    }
}

//--------------------------------------------------------------

void ofApp::clearParams(){
    hasShutters = false;
    hasIris = false;
    hasEdge = false;
    hasZoom = false;
    hasFrost = false;
    hasPanTilt = false;
}
