#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::oscInit() {
    //listenTargets.push_back("Intens"); listenTargets.push_back("Thrust A"); listenTargets.push_back("Thrust B"); listenTargets.push_back("Thrust C");
    listenTargets[0] = "Intens"; listenTargets[1] = "Thrust A"; listenTargets[2] = "Angle A"; listenTargets[3] = "Thrust B"; listenTargets[4] = "Angle B";
    listenTargets[5] = "Thrust C"; listenTargets[6] = "Angle C"; listenTargets[7] = "Thrust D"; listenTargets[8] = "Angle D"; listenTargets[9] = "Frame Assembly";
    listenTargets[10] = "Iris"; listenTargets[11] = "Edge"; listenTargets[12] = "Zoom"; listenTargets[13] = "Diffusn";
    
    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) {
        hasTargets[i] = false;
    }
}

//--------------------------------------------------------------


void ofApp::checkConnection() {
}

//--------------------------------------------------------------

void ofApp::oscEvent() {
    while(receiver.hasWaitingMessages()){
        // get the next message
        gui.oscEvent(ofGetElapsedTimeMillis());
        ofxOscMessage m;
        receiver.getNextMessage(m);
        
        if (m.getAddress() == "/eos/out/ping") {
            //SOMEHOW CHECK THE FUCKING CONNECTION
        }
        // ----------------------- GET ALL LIVE / BLIND STATUS -----------------------
        if (m.getAddress() == "/eos/out/event/state") {
            switch(m.getArgAsInt(0)) {
                case 0: //BLIND
                    isLive = false;
                    break;
                case 1: //LIVE
                default:
                    isLive = true;
                    break;
            }
            return;
        }
        // ----------------------- GET ALL CHANNEL DATA -----------------------
        if (m.getAddress() == "/eos/out/active/chan") {
            parseChannel(m.getArgAsString(0));
            return;
        }
        // ----------------------- GET ALL WHEEL PARAMS -----------------------
        for (int i = 0; i < 200; i++) {
            if (m.getAddress() == "/eos/out/active/wheel/" + ofToString(i)) {
                //cout << ofToString(m).size() << endl;
                if (ofToString(m).size() > 32) { //IF NO CHANNEL SELECTED, DONT PARSE WHEEL
                    parseWheel(m.getArgAsString(0));
                }
                return;
            }
        }
    }
}

void ofApp::parseWheel(string incomingOSC) {
    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) {
        if (incomingOSC.find(listenTargets[i]) != std::string::npos) {
            int indexValueStart = incomingOSC.find("[");
            int indexValueEnd = incomingOSC.find("]");
            string outputString = incomingOSC.substr(indexValueStart + 1, indexValueEnd - indexValueStart - 1);
            int outputInt = ofToInt(outputString);
            switch(i) {
                case 0: //Intensity
                    hasTargets[i] = true;
                    break;
                case 1: //Thrust A
                    hasTargets[i] = true;
                    break;
                case 2: //Angle A
                    hasTargets[i] = true;
                    if (!ignoreOSC) {
                        gui.angleA.rotateAngle = -outputInt;
                    }
                    break;
                case 3: //Thrust B
                    hasTargets[i] = true;
                    break;
                case 4: //Angle B
                    hasTargets[i] = true;
                    if (!ignoreOSC) {
                        gui.angleB.rotateAngle = -outputInt;
                    }
                    break;
                case 5: //Thrust C
                    hasTargets[i] = true;
                    break;
                case 6: //Angle C
                    hasTargets[i] = true;
                    if (!ignoreOSC) {
                        gui.angleC.rotateAngle = -outputInt;
                    }
                    break;
                case 7: //Thrust D
                    hasTargets[i] = true;
                    break;
                case 8: //Angle D
                    hasTargets[i] = true;
                    if (!ignoreOSC) {
                        gui.angleD.rotateAngle = -outputInt;
                    }
                    break;
                case 9: //Frame Assembly
                    hasTargets[i] = true;
                    break;
                case 10: //Iris
                    hasTargets[i] = true;
                    gui.irisPercent = outputString + " %";
                    break;
                case 11: //Edge
                    hasTargets[i] = true;
                    gui.edgePercent = outputString + " %";
                    break;
                case 12: //Zoom
                    hasTargets[i] = true;
                    gui.zoomPercent = outputString + " %";
                    break;
                case 13: //Frost
                    hasTargets[i] = true;
                    gui.frostPercent = outputString + " %";
                    break;
            }
        }
    }
    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) {
        if (!hasTargets[i]) { //IF PARAMETER IS NOT TRUE;
            switch(i) {
                case 0: //Intensity
                    break;
                case 1: //Thrust A
                case 2: //Angle A
                case 3: //Thrust B
                case 4: //Angle B
                case 5: //Thrust C
                case 6: //Angle C
                case 7: //Thrust D
                case 8: //Angle D
                case 9: //Frame Assembly
                    break;
                case 10: //Iris
                    gui.irisPercent = "";
                    break;
                case 11: //Edge
                    gui.edgePercent = "";
                    break;
                case 12: //Zoom
                    gui.zoomPercent = "";
                    break;
                case 13: //Frost
                    gui.frostPercent = "";
                    break;
            }
        }
    }
}

void ofApp::parseChannel(string incomingOSC) {
    if (incomingOSC.find("@") != string::npos) { //IF NO MATCH, RETURNS REDICULOUSLY HIGH NUMBER
        int indexValueEnd = incomingOSC.find(" ");
        incomingOSC = incomingOSC.substr(0,indexValueEnd);
        selectedChannel = incomingOSC;
        selectedChannelInt = ofToInt(incomingOSC);
        noneSelected = false;
    } else if (incomingOSC.find("[") != string::npos){ // IF NO CHANNEL IS PATCHED
        int indexValueEnd = incomingOSC.find("[");
        incomingOSC = incomingOSC.substr(0,indexValueEnd - 1);
        selectedChannel = incomingOSC;
        selectedChannelInt = ofToInt(incomingOSC);
        noneSelected = false;
    } else { // IF NO CHANNEL IS SELECTED
        noneSelected = true;
        selectedChannel = "---";
    }
    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) { //RESET WHEELS, ONLY WORKS IF NO CHANNEL IS SELECTED
        hasTargets[i] = false;
    }
}

void ofApp::connect() {
    IPAddress = getIPAddress();
    gui.osc.sender.setup(inputIP, ofToInt(inputTX));
    receiver.setup(ofToInt(inputRX));
    connectRequest = false;
    
    gui.osc.sendPing();
    gui.osc.fineEncoder(0); //SET DEFAULT ENCODER TO COURSE
}
