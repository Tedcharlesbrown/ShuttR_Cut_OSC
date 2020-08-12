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
        if (channelIntensity >= 90) {
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
}

//--------------------------------------------------------------

void ofApp::saveXML() {
    XML.setValue("settings::ip", inputIP);
    XML.setValue("settings::id", inputID);
    XML.setValue("settings::rx", inputRX);
    XML.setValue("settings::tx", inputTX);
    XML.saveFile( ofxiOSGetDocumentsDirectory() + "settings.xml" );
    XML.saveFile( "settings.xml" );
    //cout << "SAVED XML" << endl;
}

//--------------------------------------------------------------

void ofApp::getXML() {
    if( XML.loadFile(ofxiOSGetDocumentsDirectory() + "settings.xml") ){
        message = "settings.xml loaded from documents folder!";
    }else if( XML.loadFile("settings.xml") ){
        message = "settings.xml loaded from data folder!";
    }else{
        message = "unable to load settings.xml check data/ folder";
    }
    
    //cout << message << endl;
    
    inputIP = XML.getValue("settings::ip", "");
    inputID = XML.getValue("settings::id", "1");
    inputRX = XML.getValue("settings::rx", "9000");
    inputTX = XML.getValue("settings::tx", "8000");
}

//--------------------------------------------------------------

string ofApp::getIPAddress() {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    string ip = ofxNSStringToString(address);
    if (ip == "error") {
        ip = "CHECK WIFI";
    }
    return ip;
}

//--------------------------------------------------------------

void ofApp::getNotchHeight() {
    
    string deviceName = ofxiOSGetDeviceRevision();
    if (deviceName.find("iPhone") != std::string::npos) { //DEVICE IS IPHONE
        int indexValueEnd = deviceName.find(",");
        int iPhoneGeneration = ofToInt(deviceName.substr(6, indexValueEnd - 6)); //GET DEVICE GENERATION
        int iPhoneVersion = ofToInt(deviceName.substr(indexValueEnd + 1)); //GET DEVICE VERSION
        int iPhoneID = iPhoneGeneration * 10 + iPhoneVersion; //SET ID TO GENERATION.VERSION NUMBER
        
//        iPhoneID = 101; //IPHONE 8
//        iPhoneID = 102; //IPHONE 8+
//        iPhoneID = 123; //IPHONE PRO + PRO MAX
        
        switch(iPhoneID) {
            case 11: //iPhone           - 1x
            case 12: //iPhone3G         - 1x
            case 21: //iPhone3Gs        - 1x
                notchHeight = 22;
                break;
            case 31: //iPhone4          - 2x
            case 32: //iPhone4 GSM      - 2x
            case 33: //iPhone4 CDMA     - 2x
            case 41: //iPhone4s         - 2x
            case 51: //iPhone5_GSM      - 2x
            case 52: //iPhone5_CMDA     - 2x
            case 53: //iPhone5c_GSM     - 2x
            case 54: //iPhone5c         - 2x
            case 61: //iPhone5s_GSM     - 2x
            case 62: //iPhone5s         - 2x
                notchHeight = 44;
                break;
            case 71: //iPhone6_Plus     - 3x
                notchHeight = 66;
                break;
            case 72: //iPhone6          - 2x
            case 81: //iPhone6s         - 2x
                notchHeight = 44;
                break;
            case 82: //iPhone6s_Plus    - 3x
                notchHeight = 66;
                break;
            case 84: //iPhoneSE         - 2x
            case 91: //iPhone7          - 2x
                notchHeight = 44;
                break;
            case 92: //iPhone7_Plus     - 3x
                notchHeight = 66;
                break;
            case 93: //iPhone7_Alt      - 2x
                notchHeight = 44;
                break;
            case 94: //iPhone7_Plus_Alt - 3x
                notchHeight = 66;
                break;
            case 101: //iPhone8         - 2x
                notchHeight = 44;
                break;
            case 102: //iPhone8_Plus    - 3x
                notchHeight = 66;
                break;
            case 103: //iPhoneX         - 3x - NOTCH
                notchHeight = 132;
                break;
            case 104: //iPhone8_Alt     - 2x
                notchHeight = 44;
                break;
            case 105: //iPhone8_Plus    - 3x
                notchHeight = 66;
                break;
            case 106: //iPhoneX_GSM     - 3x - NOTCH
            case 112: //iPhoneXS        - 3x - NOTCH
            case 114: //iPhoneXS_Max    - 3x - NOTCH
            case 116: //iPhoneXS_Max_A  - 3x - NOTCH
                notchHeight = 132;
                break;
            case 118: //iPhoneXR        - 2x - NOTCH
            case 121: //iPhone11        - 2x - NOTCH
                notchHeight = 88;
                break;
            case 123: //iPhone11_Pro    - 3x - NOTCH
            case 125: //iPhone11_ProMax - 3x - NOTCH
                notchHeight = 132;
                break;
            case 128: //iPhoneSE_2ndGen - 2x
                notchHeight = 44;
                break;
            default:
                notchHeight = 44;
        }
    }
}
