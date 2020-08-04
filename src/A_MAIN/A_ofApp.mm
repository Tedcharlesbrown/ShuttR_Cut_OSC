#include "A_ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofEnableSmoothing();
    ofSetCircleResolution(128);
    IPAddress = getIPAddress();
    styleInit();
    oscInit();
    getXML();
    
    //ofSleepMillis(5000);
    
    gui.setup();
    gui.shutterPage.clicked = true;
    
//    cout << ofxiOSGetDeviceRevision() << endl;
    
    if (ofxiOSGetDeviceRevision().find("iPad") != std::string::npos) {
        //cout << "IPAD" << endl; //iPad7,3
    }
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
    
    //rotation += 0.01;
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
