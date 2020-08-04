#include "A_ofApp.h"

//--------------------------------------------------------------
void GUI::panTiltPageSetup(){
    float encoderSize = assemblyDiameter / 2;
    
    panTiltEncoder.load("Encoder.png");
    panTiltEncoder.resize(encoderSize, encoderSize);
}
//--------------------------------------------------------------
void GUI::panTiltPageUpdate(){
}

//--------------------------------------------------------------
void GUI::panTiltPageDraw(){
    
    ofPushMatrix();
    ofTranslate(centerX,centerY);
    panTiltEncoder.draw(- panTiltEncoder.getWidth() / 2, - panTiltEncoder.getHeight() * 1.1);
    panTiltEncoder.draw(- panTiltEncoder.getWidth() / 2, 0);
    ofPopMatrix();
    
    ofPushMatrix();
    ofTranslate(centerX + panTiltEncoder.getWidth() / 1.75, centerY);
    //    panTiltEncoder.draw(- panTiltEncoder.getWidth() / 2, - panTiltEncoder.getHeight() / 2);
    ofPopMatrix();
    
    ofPushMatrix();
    ofTranslate(centerX - panTiltEncoder.getWidth() / 1.75, centerY);
    //    panTiltEncoder.draw(- panTiltEncoder.getWidth() / 2, - panTiltEncoder.getHeight() / 2);
    ofPopMatrix();
}

//--------------------------------------------------------------
void GUI::panTiltPageTouchDown(ofTouchEventArgs & touch){
    minusButton.touchDown(touch);
    plusButton.touchDown(touch);
    fineButton.touchDown(touch, true);
    highButton.touchDown(touch, true);
    flashButton.touchDown(touch);
    channelButton.touchDown(touch, true);
}

//--------------------------------------------------------------
void GUI::panTiltPageTouchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void GUI::panTiltPageTouchUp(ofTouchEventArgs & touch){
    minusButton.touchUp(touch);
    plusButton.touchUp(touch);
    flashButton.touchUp(touch);
    
    thrustButton.touchUp(touch);
    angleButton.touchUp(touch);
    shutterButton.touchUp(touch);
}

//--------------------------------------------------------------
void GUI::panTiltPageDoubleTap(ofTouchEventArgs & touch){

}
