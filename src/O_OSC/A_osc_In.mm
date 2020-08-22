#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::oscEvent() {
    while(eos.hasWaitingMessages()){
        oscReceivedTime = ofGetElapsedTimeMillis();
        isConnected = true;
        hasOSC = true;
        if (console_log.back().find(log_Connecting) != string::npos || console_log.back() == log_CheckOSC) { //ON GAINED CONNECTION
            console_log.push_back(log_YesConnect);
        } else if (console_log.back() == log_lostConnect) {  //IF LOST CONNECTION
            console_log.push_back(log_reConnect + inputIP);
        }
        
        // ----------------------- OSC MESSAGE START -----------------------
        ofxEosOscMsg m = eos.getNextMessage();
        
        // ----------------------- GET SHOW NAME -----------------------
        if (m.getAddress() == "/eos/out/show/name") {
            headerName = m.getArgAsString(0);
            string headerAppend = "";
            int length = headerName.length();
            int maxLength = smallButtonWidth * 4;
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
            receivedPingTime = ofGetElapsedTimeMillis();
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
    
    if (incomingOSC.find("Error:") != string::npos) {
//        selectedChannel = "SYNTAX ERROR";
        syntaxError = true;
    } else {
        syntaxError = false;
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
}

//--------------------------------------------------------------

void ofApp::getPanTilt(ofxEosOscMsg m) {
    if (m.getNumArgs() > 0) {
        int panPercentInt = m.getArgAsFloat(4);
        int tiltPercentInt = m.getArgAsFloat(5);
        panPercent = ofToString(panPercentInt) + " %";
        tiltPercent = ofToString(tiltPercentInt) + " %";
    }
}


//--------------------------------------------------------------

void ofApp::getIntensity(ofxEosOscMsg m) {
    channelInt = ofToInt(m.getArgPercent(0));
    intOverlay.incomingOSC(channelInt);
    
    channelInt255 = ofMap(channelInt,0,100,50,255);
    shutterColor.setHsb(channelHue,channelSat,channelInt255);
    
    channelIntString = m.getArgPercent(0) + " %";
}

//--------------------------------------------------------------

void ofApp::getWheel(ofxEosOscMsg m){
    for (int i = 0; i < 200; i++) {
        if (m.getAddress() == "/eos/out/active/wheel/" + ofToString(i) && m.argHasPercent(0) && !ignoreOSC) {
            string incomingOSC = m.getArgAsString(0);
            
            float outputInt = ofToFloat(m.getArgPercent(0));
            float outputBinary = ofMap(outputInt, 0, 100, 1, clickDiameter / assemblyRadius);
            if (incomingOSC.find("Intens") != string::npos) { //INTENSITY
                getIntensity(m);
            } else if (incomingOSC.find("Thrust A") != string::npos) { //Thrust A
                thrustA.buttonA.position = outputBinary;
            } else if (incomingOSC.find("Angle A") != string::npos) { //Angle A
                angleA.rotateAngle = -outputInt;
            } else if (incomingOSC.find("Thrust B") != string::npos) { //Thrust B
                thrustB.buttonB.position = outputBinary;
            } else if (incomingOSC.find("Angle B") != string::npos) { //Angle B
                angleB.rotateAngle = -outputInt;
            } else if (incomingOSC.find("Thrust C") != string::npos) { //Thrust C
                thrustC.buttonC.position = outputBinary;
            } else if (incomingOSC.find("Angle C") != string::npos) { //Angle C
                angleC.rotateAngle = -outputInt;
            } else if (incomingOSC.find("Thrust D") != string::npos) { //Thrust D
                thrustD.buttonD.position = outputBinary;
            } else if (incomingOSC.find("Angle D") != string::npos) { //Angle D
                angleD.rotateAngle = -outputInt;
            } else if (incomingOSC.find("Frame Assembly") != string::npos) { //Frame Assembly
                assembly.incomingOSC(outputInt);
            } else if (incomingOSC.find("Iris") != string::npos) { //IRIS
                irisPercent = m.getArgPercent(0) + " %";
            } else if (incomingOSC.find("Edge") != string::npos) { //EDGE
                edgePercent = m.getArgPercent(0) + " %";
            } else if (incomingOSC.find("Zoom") != string::npos) { //ZOOM
                zoomPercent = m.getArgPercent(0) + " %";
            } else if (incomingOSC.find("Diffusn") != string::npos) { //FROST
                frostPercent = m.getArgPercent(0) + " %";

            } else if (incomingOSC.find("Gobo Select 2") != string::npos) { //GOBO WHEEL 2
                wheelSelect.push_back("");
                wheelPercent.push_back("");
                
                wheelSelect.insert(wheelSelect.begin() + 1, "Gobo Select 2");
                wheelPercent.insert(wheelPercent.begin() + 1, m.getArgPercent(0));
                //                wheelSelect.push_back("Gobo Select 2");
                //                wheelPercent.push_back(m.getArgPercent(0));
                //                wheelSelect.at(1) = "Gobo Select 2";
                //                wheelPercent.at(1) = m.getArgPercent(0);
            } else if (incomingOSC.find("Gobo Select") != string::npos) { //GOBO WHEEL 1
//                wheelSelect.insert(wheelSelect.begin(), "Gobo Select 1");
//                wheelPercent.insert(wheelPercent.begin(), m.getArgPercent(0));
                wheelSelect.at(0) = "Gobo Select 1";
                wheelPercent.at(0) = m.getArgPercent(0);
            }
        }
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
            clearParams();
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
    channelIntString = noParameter;
    shutterColor.setHsb(0,0,100);
    
    irisPercent = noParameter;
    edgePercent = noParameter;
    zoomPercent = noParameter;
    frostPercent = noParameter;
    
    panPercent = noParameter;
    tiltPercent = noParameter;
}
