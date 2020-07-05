#include "A_ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    styleInit();
    IPAddress = getIPAddress();
    sender.setup("192.168.0.35",8000);
    receiver.setup(9000);
    
    gui.setup();
    
    gui.pageOne.clicked = true;
}
//--------------------------------------------------------------
void ofApp::update(){
    gui.update();
    oscSent();
    oscEvent();
    keyboard.update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(EOSBackground);
    
    gui.draw();
    
    keyboard.draw();
}
//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    gui.touchDown(touch);
    if (keyboard.show) {
        keyboard.touchDown(touch);
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    gui.touchMoved(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    gui.touchUp(touch);
    keyboard.touchUp(touch);
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


void ofApp::oscSent(){
    //    gui.oscSent(ofGetElapsedTimeMillis());
    //    ofxOscMessage m;
    //    m.setAddress("/mouse/button");
    //    m.addIntArg(1);
    //    m.addStringArg("down");
    //    sender.sendMessage(m, false);
}


void ofApp::oscEvent() {
    while(receiver.hasWaitingMessages()){
        // get the next message
        gui.oscEvent(ofGetElapsedTimeMillis());
        ofxOscMessage m;
        receiver.getNextMessage(m);
    }
}


//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
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
