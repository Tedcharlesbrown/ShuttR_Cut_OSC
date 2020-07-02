#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    width = ofGetWidth();
    height = ofGetHeight();
    clickDiameter = width / 9.6;
    clickRadius = clickDiameter / 2;
    encoderDiameter = width / 6;
    float screenAdjust = (height / width) - 1;
    assemblyDiameter = width - (clickDiameter + (clickRadius / 2)) / screenAdjust;
    assemblyRadius = assemblyDiameter / 2;
    thrustDiameter = assemblyRadius / 2;
    centerX = width / 2;
    centerY = height - assemblyDiameter + assemblyRadius / 3;
    ofLog() << screenAdjust;
}
//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(Style.EOSBackground);
	
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
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
