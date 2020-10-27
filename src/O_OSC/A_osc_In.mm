#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::oscEvent() {
    while (eos.hasWaitingMessages()) {

        isConnected = true;
        hasOSC = true;
        if (console_log.back().find(log_Connecting) != string::npos || console_log.back() == log_CheckOSC) { //ON GAINED CONNECTION
            console_log.push_back(log_YesConnect);
        } else if (console_log.back() == log_lostConnect) {  //IF LOST CONNECTION
            console_log.push_back(log_reConnect + inputIP);
        }

        // ----------------------- OSC MESSAGE START -----------------------
        ofxEosOscMsg m = eos.getNextMessage();

        // ----------------------- GET CONNECTION STATUS -----------------------
        if (m.getAddress() == "/eos/out/ping" && m.getArgAsString(0) == appName) {
            receivedPingTime = ofGetElapsedTimeMillis();
        } else {
            oscReceivedTime = ofGetElapsedTimeMillis(); //ONLY ALERT TO NON-PING MESSAGES
        }
        // ----------------------- GET SHOW NAME -----------------------
        if (m.getAddress() == "/eos/out/show/name") {
            headerName = m.getArgAsString(0);
            string headerAppend = "";
            int length = headerName.length();
            int maxLength = smallButtonWidth * 4;
            while (fontSmall.stringWidth(headerName) > maxLength) {
                headerAppend = "...";
                headerName = headerName.substr(0, length);
                length--;
            }
            headerName = headerName + headerAppend;
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
            if (m.getAsString().find("Ind/Spd") != string::npos || m.getAsString().find("Select") != string::npos) {
                getImage(m);
            } else {
                getWheel(m);
            }
        }
        // ----------------------- GET DIRECT SELECTS -----------------------
        if (m.getAsString().find("/eos/out/ds/") != string::npos) {
            for (int i = 1; i <= 2; i++) {
                for (int j = 1; j <= 20; j++) {
                    if (m.getAddress() == "/eos/out/ds/" + ofToString(i) + "/" + ofToString(j)) {
                        getDirectSelect(i, j, m);
                    }
                }
            }
        }
    }
}

//--------------------------------------------------------------

void ofApp::getState(ofxEosOscMsg m) {
    switch (m.getArgAsInt(0)) {
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

void ofApp::getColor(ofxEosOscMsg m) {
    channelHue = m.getArgAsFloat(0);
    channelSat = m.getArgAsFloat(1);
    channelHue = ofMap(channelHue, 0, 360, 0, 255);
    channelSat = ofMap(channelSat, 0, 100, 0, 255);
    shutterColor.setHsb(channelHue, channelSat, channelInt255);
}

//--------------------------------------------------------------

void ofApp::getCommandLine(ofxEosOscMsg m) {
    string incomingOSC = m.getArgAsString(0);

    if (incomingOSC.find("Error:") != string::npos) {
        syntaxError = true;
    } else {
        syntaxError = false;
        if (incomingOSC.find("Highlight :") != string::npos) {
            highButton.clicked = true;
        } else {
            highButton.clicked = false;
        }

        if (incomingOSC.find("Group") != string::npos && incomingOSC.find("#") != string::npos) {
            int indexValueStart = incomingOSC.find("Group") + 6;
            incomingOSC = incomingOSC.substr(indexValueStart);

            int indexValueEnd = incomingOSC.find(" ");

            incomingOSC = incomingOSC.substr(0, indexValueEnd);
            multiChannelPrefix = "Gr " + incomingOSC;

        } else if (incomingOSC.find("Thru") != string::npos && incomingOSC.find("#") != string::npos) {
            int indexValueStart = incomingOSC.find("Chan") + 5;
            incomingOSC = incomingOSC.substr(indexValueStart);

            int indexValueEnd = incomingOSC.find(" Thru");
            string firstNumber = incomingOSC.substr(0, indexValueEnd);

            indexValueStart = incomingOSC.find("Thru") + 5;

            incomingOSC = incomingOSC.substr(indexValueStart);
            indexValueEnd = incomingOSC.find(" ");

            string secondNumber = incomingOSC.substr(0, indexValueEnd);
            multiChannelPrefix = firstNumber + "-" + secondNumber;
        } else if (incomingOSC.find("#") != string::npos) {
            multiChannelPrefix = "";
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
        incomingOSC = incomingOSC.substr(0, indexValueEnd);
        if (oscLength == 5 + incomingOSC.length()) { //IF NO CHANNEL IS PATCHED (OFFSET BY LENGTH OF CHANNEL NUMBER)
            selectedChannel = "(" + incomingOSC + ")";
            clearParams();
        } else {
            getFixture(m);
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

void ofApp::getFixture(ofxEosOscMsg m) {
    string incomingOSC = m.getArgAsString(0);
    int indexValueStart = incomingOSC.find("_");
    int indexValueEnd = incomingOSC.find(" @");
    if (indexValueStart != -1) {
        int countBackwards = indexValueStart;
        while (incomingOSC.at(countBackwards) != ' ') {
            countBackwards--;
        }
        indexValueStart = countBackwards + 1;
        incomingOSC = incomingOSC.substr(indexValueStart, indexValueEnd - indexValueStart);
        ofStringReplace(incomingOSC,"_"," ");
    } else { //IF GENERIC DIMMER
        indexValueStart = incomingOSC.find("]") + 2;
        incomingOSC = incomingOSC.substr(indexValueStart, indexValueEnd - indexValueStart);
    }
        oldFixture = currentFixture;
        currentFixture = incomingOSC;
    
        if (currentFixture != oldFixture) {
            newFixture = true;
        } else {
            newFixture = false;
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
    intensityOverlay.incomingOSC(channelInt);

    channelInt255 = ofMap(channelInt, 0, 100, 50, 255);
    shutterColor.setHsb(channelHue, channelSat, channelInt255);

    channelIntString = m.getArgPercent(0) + " %";
}

//--------------------------------------------------------------

void ofApp::getWheel(ofxEosOscMsg m) {
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
            } else if (incomingOSC.find("Diffusn") != string::npos || incomingOSC.find("Diffusion") != string::npos) { //FROST
                frostPercent = m.getArgPercent(0) + " %";
            }
//            else if (incomingOSC.find("Gobo Select") != string::npos) { //GOBO WHEEL 1
//                wheelSelect.at(0) = "Gobo Select 1";
//                wheelGobo.at(0) = m.getArgPercent(0);
//            } else if (incomingOSC.find("Gobo Ind/Spd") != string::npos) { //GOBO WHEEL 1
//                wheelPercent.at(0) = m.getArgPercent(0) + " %";
//            }
        }
    }
}

//--------------------------------------------------------------

void ofApp::getDirectSelect(int bank, int buttonID, ofxEosOscMsg m) {
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

void ofApp::getImage(ofxEosOscMsg m) {
    string incomingOSC = m.getAsString();
    string incomingWheel = m.getAsString();
    int indexValueStart = incomingOSC.find("/eos") + 25;
    int indexValueEnd = incomingOSC.find(" [");
    incomingOSC = incomingOSC.substr(indexValueStart,indexValueEnd - indexValueStart);
    
    //SELECT
    if (incomingOSC.find("Select") != string::npos) {
        string incomingValue = m.getArgPercent(0);
        if (ofToInt(incomingValue) == 1) {
            incomingValue = "HOME";
        }
        //------------- GOBO ---------------
        if (incomingOSC.find("Gobo") != string::npos) {
            if (incomingOSC.find("2") == string::npos && incomingOSC.find("3") == string::npos && incomingOSC.find("MSpeed") == string::npos) {
                hasGobo1 = true; gobo1Select = incomingValue;
            } else if (incomingOSC.find("2") != string::npos) {
                hasGobo2 = true; gobo2Select = incomingValue;
            } else if (incomingOSC.find("3") != string::npos) {
                hasGobo3 = true; gobo3Select = incomingValue;
            }
        }
        //------------- BEAM ---------------
        if (incomingOSC.find("Beam Fx") != string::npos) {
            if (incomingOSC.find("2") == string::npos && incomingOSC.find("3") == string::npos && incomingOSC.find("MSpeed") == string::npos) {
                hasBeam1 = true; beam1Select = incomingValue;
            } else if (incomingOSC.find("2") != string::npos) {
                hasBeam2 = true; beam2Select = incomingValue;
            } else if (incomingOSC.find("3") != string::npos) {
                hasBeam3 = true; beam3Select = incomingValue;
            }
        }
        //------------- ANIMATION ---------------
        if (incomingOSC.find("Animation") != string::npos) {
            if (incomingOSC.find("2") == string::npos && incomingOSC.find("3") == string::npos && incomingOSC.find("MSpeed") == string::npos) {
                hasAni1 = true; ani1Select = incomingValue;
            } else if (incomingOSC.find("2") != string::npos) {
                hasAni2 = true; ani2Select = incomingValue;
            } else if (incomingOSC.find("3") != string::npos) {
                hasAni3 = true; ani3Select = incomingValue;
            }
        }
        //------------- COLOR ---------------
        if (incomingOSC.find("Color") != string::npos) {
            if (incomingOSC.find("2") == string::npos && incomingOSC.find("3") == string::npos && incomingOSC.find("MSpeed") == string::npos) {
                hasColor1 = true; color1Select = incomingValue;
            } else if (incomingOSC.find("2") != string::npos) {
                hasColor2 = true; color2Select = incomingValue;
            } else if (incomingOSC.find("3") != string::npos) {
                hasColor3 = true; color3Select = incomingValue;
            }
        }
    } else if (incomingOSC.find("Ind/Spd") != string::npos) { //INDEX / SPEED
        string incomingValue = m.getArgPercent(0);
        if (ofToInt(incomingValue) == 0) {
            incomingValue = "HOME";
        }
        //------------- GOBO ---------------
        if (incomingOSC.find("Gobo") != string::npos) {
            if (incomingOSC.find("2") == string::npos && incomingOSC.find("3") == string::npos && incomingOSC.find("MSpeed") == string::npos) {
                hasGobo1 = true; gobo1Speed = incomingValue;
            } else if (incomingOSC.find("2") != string::npos) {
                hasGobo2 = true; gobo2Speed = incomingValue;
            } else if (incomingOSC.find("3") != string::npos) {
                hasGobo3 = true; gobo3Speed = incomingValue;
            }
        }
        //------------- BEAM ---------------
        if (incomingOSC.find("Beam Fx") != string::npos) {
            if (incomingOSC.find("2") == string::npos && incomingOSC.find("3") == string::npos && incomingOSC.find("MSpeed") == string::npos) {
                hasBeam1 = true; beam1Speed = incomingValue;
            } else if (incomingOSC.find("2") != string::npos) {
                hasBeam2 = true; beam2Speed = incomingValue;
            } else if (incomingOSC.find("3") != string::npos) {
                hasBeam3 = true; beam3Speed = incomingValue;
            }
        }
        //------------- ANIMATION ---------------
        if (incomingOSC.find("Animation") != string::npos) {
            if (incomingOSC.find("2") == string::npos && incomingOSC.find("3") == string::npos && incomingOSC.find("MSpeed") == string::npos) {
                hasAni1 = true; ani1Speed = incomingValue;
            } else if (incomingOSC.find("2") != string::npos) {
                hasAni2 = true; ani2Speed = incomingValue;
            } else if (incomingOSC.find("3") != string::npos) {
                hasAni3 = true; ani3Speed = incomingValue;
            }
        }
    }
}

//--------------------------------------------------------------

void ofApp::clearParams() {
    channelIntString = noParameter;
    shutterColor.setHsb(0, 0, 100);

    irisPercent = noParameter;
    edgePercent = noParameter;
    zoomPercent = noParameter;
    frostPercent = noParameter;

    panPercent = noParameter;
    tiltPercent = noParameter;
    
    clearImage();
}

//--------------------------------------------------------------

void ofApp::clearImage() {
    hasGobo1 = false; hasGobo2 = false; hasGobo3 = false;
    hasBeam1 = false; hasBeam2 = false; hasBeam3 = false;
    hasAni1 = false; hasAni2 = false; hasAni3 = false;
    hasColor1 = false; hasColor2 = false; hasColor3 = false;
}
