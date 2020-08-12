#include "A_ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    gui.getNotchHeight();
    
    
    gui.setup();
}

//--------------------------------------------------------------
void ofApp::update(){
//    stateUpdate();
    gui.update();
//    if (connectRequest) {
//        connect();
//    }
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

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

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

void ofApp::connect() {
    IPAddress = getIPAddress();
    
    gui.connect();
    
//    gui.osc.sendPing();
//    gui.osc.fineEncoder(0);
}

//--------------------------------------------------------------

