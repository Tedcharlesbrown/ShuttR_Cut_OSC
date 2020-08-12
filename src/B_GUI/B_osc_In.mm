#include "A_ofApp.h"

//--------------------------------------------------------------


void GUI::checkConnection() {
}

//--------------------------------------------------------------

void GUI::oscEvent() {
    while(eos.hasWaitingMessages()){
        oscReceivedTime = ofGetElapsedTimeMillis();
        
        ofxEosOscMsg m = eos.getNextMessage();
        
        if (m.getAddress() == "/eos/out/ping") {
            //SOMEHOW CHECK THE FUCKING CONNECTION
        }
        // ----------------------- GET ALL LIVE / BLIND STATUS -----------------------
        if (m.getAddress() == "/eos/out/event/state") {
            getState(m);
        }
        // ----------------------- GET LIGHT COLOR ----------------------------
        if (m.getAddress() == "/eos/out/color/hs" && m.getNumArgs() > 0) {
            getColor(m);
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
        // ----------------------- GET COMMAND LINE -----------------------
        if (m.getAddress() == "/eos/out/user/" + inputID + "/cmd") {
            getCommandLine(m);
        }
    }
}

//--------------------------------------------------------------

void GUI::getState(ofxEosOscMsg m){
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

void GUI::getCommandLine(ofxEosOscMsg m){
    string incomingOSC = m.getArgAsString(0);
    
    if (incomingOSC.find("LIVE") != string::npos) {
        int indexValueStart = incomingOSC.find(" ");
        incomingOSC = incomingOSC.substr(indexValueStart + 1);
    }  else if (incomingOSC.find("BLIND") != string::npos) { //TODO: MAKE WORK IN BLIND
        
    }
    
    if (incomingOSC.find(":") != string::npos) {
        int indexValueStart = incomingOSC.find(" ");
        int indexValueEnd = incomingOSC.find(" Thru");
        string firstNumber = incomingOSC.substr(indexValueStart + 1, indexValueEnd - indexValueStart - 1);
        
        indexValueStart = incomingOSC.find("Thru") + 5;
        indexValueEnd = incomingOSC.find(":");
        string secondNumber = incomingOSC.substr(indexValueStart, indexValueEnd - indexValueStart - 1);
        
        multiChannelPrefix = firstNumber + "-" + secondNumber + " : ";
    } else {
        multiChannelPrefix = "";
    }
}

//--------------------------------------------------------------

void GUI::getPanTilt(ofxEosOscMsg m) {
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

void GUI::getWheel(ofxEosOscMsg m){
    for (int i = 0; i < 200; i++) {
        if (m.getAddress() == "/eos/out/active/wheel/" + ofToString(i) && m.argHasPercent(0) && !ignoreOSC) {
            string incomingOSC = m.getArgAsString(0);
            
            float outputInt = ofToFloat(m.getArgPercent(0));
            float outputBinary = ofMap(outputInt, 0, 100, 1, clickDiameter / assemblyRadius);
            if (incomingOSC.find("Intens") != string::npos) { //INTENSITY
                channelIntensity = ofToInt(m.getArgPercent(0));
            } else if (incomingOSC.find("Thrust A") != string::npos) { //Thrust A
                thrustA.buttonA.position = outputBinary;
                hasShutters = true;
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

void GUI::getChannel(ofxEosOscMsg m) {
    string incomingOSC = m.getArgAsString(0);
    if (incomingOSC.find("[") != string::npos){ //IF CHANNEL IS PATCHED AND SELECTED
        int oscLength = incomingOSC.length();
        int indexValueEnd = incomingOSC.find(" [");
        incomingOSC = incomingOSC.substr(0,indexValueEnd - 1);
        if (oscLength == 5 + incomingOSC.length()) { //IF NO CHANNEL IS PATCHED (OFFSET BY LENGTH OF CHANNEL NUMBER)
            noneSelected = true;
            selectedChannel = "(" + incomingOSC + ")";
            irisPercent = noParameter; edgePercent = noParameter; zoomPercent = noParameter; frostPercent = noParameter;
            panPercent = noParameter; tiltPercent = noParameter;
        } else {
            selectedChannel = multiChannelPrefix + incomingOSC;
            selectedChannelInt = ofToInt(incomingOSC);
            noneSelected = false;
        }
    } else { // IF NO CHANNEL IS SELECTED
        noneSelected = true;
        selectedChannel = "---";
    }
    
    //RESET WHEELS, ONLY WORKS IF NO CHANNEL IS SELECTED
    hasShutters = false;
    hasIris = false;
    hasEdge = false;
    hasZoom = false;
    hasFrost = false;
    hasPanTilt = false;
}

//--------------------------------------------------------------

void GUI::getColor(ofxEosOscMsg m){
    if (m.getNumArgs() > 0) {
        float hue = m.getArgAsFloat(0);
        float sat = m.getArgAsFloat(1);
        hue = ofMap(hue,0,360,0,255);
        sat = ofMap(sat,0,100,0,255);
        shutterColor.setHsb(hue,sat,255);
    }
}
