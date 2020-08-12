#include "A_ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    getNotchHeight();
    
    ofEnableSmoothing();
    ofSetCircleResolution(128);
    IPAddress = getIPAddress();
    styleInit();
    oscInit();
    getXML();
    
    gui.setup();
    gui.shutterPage.clicked = true;
}

//--------------------------------------------------------------
void ofApp::update(){
    stateUpdate();
    gui.update();
    oscEvent();
    if (connectRequest) {
        connect();
        saveXML();
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(EOSBackground);
    
    gui.draw();
}
//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    gui.touchDown(touch);
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    gui.touchMoved(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    gui.touchUp(touch);
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    gui.touchDoubleTap(touch);
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    gui.touchCancelled(touch);
    
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
