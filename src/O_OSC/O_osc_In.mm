//#include "O_osc.h"
//
////--------------------------------------------------------------
//
//void OSC::oscInit() {
//    listenTargets[0] = "Intens"; listenTargets[1] = "Thrust A"; listenTargets[2] = "Angle A"; listenTargets[3] = "Thrust B"; listenTargets[4] = "Angle B";
//    listenTargets[5] = "Thrust C"; listenTargets[6] = "Angle C"; listenTargets[7] = "Thrust D"; listenTargets[8] = "Angle D"; listenTargets[9] = "Frame Assembly";
//    listenTargets[10] = "Iris"; listenTargets[11] = "Edge"; listenTargets[12] = "Zoom"; listenTargets[13] = "Diffusn";
//    
//    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) {
//        hasTargets[i] = false;
//    }
//}
//
////--------------------------------------------------------------
//
//
//void OSC::checkConnection() {
//}
//
////--------------------------------------------------------------
//
//void OSC::oscEvent() {
//    while(receiver.hasWaitingMessages()){
//        oscReceivedTime = ofGetElapsedTimeMillis();
//        
//        ofxOscMessage m;
//        receiver.getNextMessage(m);
//        
//        if (m.getAddress() == "/eos/out/ping") {
//            //SOMEHOW CHECK THE FUCKING CONNECTION
//        }
//        // ----------------------- GET ALL LIVE / BLIND STATUS -----------------------
//        if (m.getAddress() == "/eos/out/event/state") {
//            switch(m.getArgAsInt(0)) {
//                case 0: //BLIND
//                    isLive = false;
//                    break;
//                case 1: //LIVE
//                default:
//                    isLive = true;
//                    break;
//            }
//            return;
//        }
//        // ----------------------- GET LIGHT COLOR ----------------------------
//        if (m.getAddress() == "/eos/out/color/hs") {
//            if (m.getNumArgs() > 0) {
//                float hue = m.getArgAsFloat(0);
//                float sat = m.getArgAsFloat(1);
//                hue = ofMap(hue,0,360,0,255);
//                sat = ofMap(sat,0,100,0,255);
//                shutterColor.setHsb(hue,sat,255);
//            }
//        }
//        // ----------------------- GET ALL CHANNEL DATA -----------------------
//        if (m.getAddress() == "/eos/out/active/chan") {
//            parseChannel(m.getArgAsString(0));
//            return;
//        }
//        // ----------------------- GET PAN TILT DATA -----------------------
//        if (m.getAddress() == "/eos/out/pantilt") {
//            if (m.getNumArgs() > 0) {
//                hasPanTilt = true;
//                int panPercent = m.getArgAsFloat(4);
//                int tiltPercent = m.getArgAsFloat(5);
//                gui.panPercent = ofToString(panPercent) + " %";
//                gui.tiltPercent = ofToString(tiltPercent) + " %";
//            }
//            return;
//        }
//        if (!hasPanTilt) {
//            gui.panPercent = noParameter;
//            gui.tiltPercent = noParameter;
//        }
//        // ----------------------- GET ALL WHEEL PARAMS -----------------------
//        for (int i = 0; i < 200; i++) {
//            if (m.getAddress() == "/eos/out/active/wheel/" + ofToString(i)) {
//                if (ofToString(m).size() > 32) { //IF NO CHANNEL SELECTED, DONT PARSE WHEEL
//                    parseWheel(m.getArgAsString(0));
//                }
//                return;
//            }
//        }
//        // ----------------------- GET COMMAND LINE -----------------------
//        if (m.getAddress() == "/eos/out/user/" + inputID + "/cmd") {            
//            string incomingOSC = m.getArgAsString(0);
//            
//            if (incomingOSC.find("LIVE") != string::npos) {
//                int indexValueStart = incomingOSC.find(" ");
//                incomingOSC = incomingOSC.substr(indexValueStart + 1);
//            }  else if (incomingOSC.find("BLIND") != string::npos) { //TODO: MAKE WORK IN BLIND
//                
//            }
//            
//            if (incomingOSC.find(":") != string::npos) {
//                int indexValueStart = incomingOSC.find(" ");
//                int indexValueEnd = incomingOSC.find(" Thru");
//                string firstNumber = incomingOSC.substr(indexValueStart + 1, indexValueEnd - indexValueStart - 1);
//                
//                indexValueStart = incomingOSC.find("Thru") + 5;
//                indexValueEnd = incomingOSC.find(":");
//                string secondNumber = incomingOSC.substr(indexValueStart, indexValueEnd - indexValueStart - 1);
//                
//                multiChannelPrefix = firstNumber + "-" + secondNumber + " : ";
//            } else {
//                multiChannelPrefix = "";
//            }
//        }
//    }
//}
//
//void OSC::parseWheel(string incomingOSC) {
//    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) {
//        if (incomingOSC.find(listenTargets[i]) != std::string::npos) {
//            int indexValueStart = incomingOSC.find("[");
//            int indexValueEnd = incomingOSC.find("]");
//            string outputString = incomingOSC.substr(indexValueStart + 1, indexValueEnd - indexValueStart - 1);
//            float outputInt = ofToFloat(outputString);
//            float outputBinary = ofMap(outputInt, 0, 100, 1, clickDiameter / assemblyRadius);
//            switch(i) {
//                case 0: //Intensity
//                    hasTargets[i] = true;
//                    channelIntensity = outputInt;
//                    break;
//                case 1: //Thrust A
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.thrustA.buttonA.position = outputBinary;
//                    }
//                    break;
//                case 2: //Angle A
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.angleA.rotateAngle = -outputInt;
//                    }
//                    break;
//                case 3: //Thrust B
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.thrustB.buttonB.position = outputBinary;
//                    }
//                    break;
//                case 4: //Angle B
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.angleB.rotateAngle = -outputInt;
//                    }
//                    break;
//                case 5: //Thrust C
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.thrustC.buttonC.position = outputBinary;
//                    }
//                    break;
//                case 6: //Angle C
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.angleC.rotateAngle = -outputInt;
//                    }
//                    break;
//                case 7: //Thrust D
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.thrustD.buttonD.position = outputBinary;
//                    }
//                    break;
//                case 8: //Angle D
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.angleD.rotateAngle = -outputInt;
//                    }
//                    break;
//                case 9: //Frame Assembly
//                    hasTargets[i] = true;
//                    if (!ignoreOSC) {
//                        gui.assembly.incomingOSC(outputInt);
//                    }
//                    break;
//                case 10: //Iris
//                    hasTargets[i] = true;
//                    gui.irisPercent = outputString + " %";
//                    break;
//                case 11: //Edge
//                    hasTargets[i] = true;
//                    gui.edgePercent = outputString + " %";
//                    break;
//                case 12: //Zoom
//                    hasTargets[i] = true;
//                    gui.zoomPercent = outputString + " %";
//                    break;
//                case 13: //Frost
//                    hasTargets[i] = true;
//                    gui.frostPercent = outputString + " %";
//                    break;
//            }
//        }
//    }
//    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) {
//        if (!hasTargets[i]) { //IF PARAMETER IS NOT TRUE;
//            switch(i) {
//                case 0: //Intensity
//                    break;
//                case 1: //Thrust A
//                case 2: //Angle A
//                case 3: //Thrust B
//                case 4: //Angle B
//                case 5: //Thrust C
//                case 6: //Angle C
//                case 7: //Thrust D
//                case 8: //Angle D
//                case 9: //Frame Assembly
//                    break;
//                case 10: //Iris
//                    gui.irisPercent = noParameter;
//                    break;
//                case 11: //Edge
//                    gui.edgePercent = noParameter;
//                    break;
//                case 12: //Zoom
//                    gui.zoomPercent = noParameter;
//                    break;
//                case 13: //Frost
//                    gui.frostPercent = noParameter;
//                    break;
//            }
//        }
//    }
//}
//
//void OSC::parseChannel(string incomingOSC) {
//    if (incomingOSC.find("[") != string::npos){ //IF CHANNEL IS PATCHED AND SELECTED
//        int oscLength = incomingOSC.length();
//        int indexValueEnd = incomingOSC.find(" [");
//        incomingOSC = incomingOSC.substr(0,indexValueEnd - 1);
//        if (oscLength == 5 + incomingOSC.length()) { //IF NO CHANNEL IS PATCHED (OFFSET BY LENGTH OF CHANNEL NUMBER)
//            noneSelected = true;
//            selectedChannel = "(" + incomingOSC + ")";
//            gui.irisPercent = noParameter; gui.edgePercent = noParameter; gui.zoomPercent = noParameter; gui.frostPercent = noParameter;
//            gui.panPercent = noParameter; gui.tiltPercent = noParameter;
//        } else {
//            selectedChannel = multiChannelPrefix + incomingOSC;
//            selectedChannelInt = ofToInt(incomingOSC);
//            noneSelected = false;
//        }
//    } else { // IF NO CHANNEL IS SELECTED
//        noneSelected = true;
//        selectedChannel = "---";
//    }
//    
//    //RESET WHEELS, ONLY WORKS IF NO CHANNEL IS SELECTED
//    for (int i = 0; i < (sizeof(listenTargets)/sizeof(*listenTargets)); i++) {
//        hasTargets[i] = false;
//    }
//    hasPanTilt = false;
//}
//
//void OSC::connect() {
//    IPAddress = getIPAddress();
//    
//    gui.osc.connect();
//    
//    receiver.setup(ofToInt(inputRX));
//    connectRequest = false;
//    
//    gui.osc.sendPing();
//    gui.osc.fineEncoder(0);
//}
