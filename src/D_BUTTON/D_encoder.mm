#include "D_encoder.h"

//--------------------------------------------------------------
void ENCODER::setup(float _size){
    encoder.load("Encoder.png");
    encoder.resize(_size, _size);
}
//--------------------------------------------------------------
void ENCODER::update(){
    
}

//--------------------------------------------------------------
void ENCODER::draw(float _x, float _y){
    this-> posX = _x;
    this-> posY = _y;
	ofPushMatrix();
    ofTranslate(posX, posY);
    ofRotateRad(ofDegToRad(currentPos) + ofDegToRad(-90));
    encoder.draw(- encoder.getWidth() / 2, - encoder.getHeight() / 2);
    ofPopMatrix();
}

//--------------------------------------------------------------
void ENCODER::touchDown(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, posX, posY) < encoder.getWidth() / 2) {
        this-> clicked = true;
    }
}

//--------------------------------------------------------------
void ENCODER::touchMoved(ofTouchEventArgs & touch, bool fine){
    if (this-> clicked) {
        lastPos = currentPos;
        currentPos = atan2(touch.y - posY, touch.x - posX);
        currentPos = ofMap(currentPos, -PI, PI, 0, 360);
        
        int fineAdjust = 1;
        if (fine) {
            fineAdjust = 8;
        }
        
        int tick = fmod(currentPos, fineAdjust);
        int direction = 0;
        
        if (currentPos > lastPos) {
            direction = 1;
        } else if (currentPos < lastPos) {
            direction = -1;
        }
        
        if (tick == 0) {
            output = direction;
            tick = -1;
        } else {
            output = 0;
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
