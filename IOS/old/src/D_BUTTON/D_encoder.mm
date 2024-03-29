#include "D_encoder.h"

//--------------------------------------------------------------
void ENCODER::setup(float _size){
    encoder.load("Encoder.png");
    encoder.resize(_size, _size);
}

//--------------------------------------------------------------
void ENCODER::draw(float _x, float _y){
    this-> posX = _x;
    this-> posY = _y;
	ofPushMatrix();
    ofTranslate(posX, posY);
    ofRotateRad(ofDegToRad(currentPos) + ofDegToRad(150));
    encoder.draw(- encoder.getWidth() / 2, - encoder.getHeight() / 2);
    ofPopMatrix();
}

//--------------------------------------------------------------
// MARK: ----------ACTIONS----------
//--------------------------------------------------------------

void ENCODER::touchDown(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, posX, posY) < encoder.getWidth() / 2) {
        this-> clicked = true;
    }
}

//--------------------------------------------------------------
void ENCODER::touchMoved(ofTouchEventArgs & touch){
    if (this-> clicked) {
        ofVec2f center;
        ofVec2f prevTouch;
        ofVec2f currentTouch;
        center.set(posX, posY);
        prevTouch.set(ofGetPreviousMouseX(),ofGetPreviousMouseY());
        currentTouch.set(touch.x,touch.y);
        
        ofVec2f oldVector;
        oldVector = prevTouch - center;
        float angleOld = oldVector.angle(prevTouch); //HEADING
        
        ofVec2f newVector;
        newVector = currentTouch - center;
        float angleNew = newVector.angle(currentTouch); //HEADING
        
        currentPos = -angleNew; //ROTATE ENCODER
        
        float diff = ofDegToRad(angleOld - angleNew);
        
        if (diff > 1) {
            diff = 0;
        } else if (diff>PI) {
            diff = TWO_PI - diff;
        } else if (diff<-PI) {
            diff = TWO_PI + diff;
        }
        
        if (diff > 0) { //CLOCKWISE
            encoderOutput = 1;
        } else if (diff < 0) { //COUNTER-CLOCKWISE
            encoderOutput = -1;
        } else {
            encoderOutput = 0;
        }
        
        newTick += ofRadToDeg(diff);

        int tickGate = 3;
        if (newTick > oldTick + tickGate || newTick < oldTick - tickGate) {
            oldTick = newTick;
            sendOSC();
        }
    }
}

//--------------------------------------------------------------
void ENCODER::touchUp(ofTouchEventArgs & touch){
    this-> clicked = false;
}

//--------------------------------------------------------------
void ENCODER::touchDoubleTap(ofTouchEventArgs & touch){

}
