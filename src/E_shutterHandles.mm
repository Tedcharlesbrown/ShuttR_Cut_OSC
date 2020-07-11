#include "E_shutterHandles.h"

//--------------------------------------------------------------

void THRUST_HANDLE::setup(string _ID) {
    this-> ID = _ID;
    if (ID == "A") {
        rotateOffset = (-90);
    } else if (ID == "B") {
        rotateOffset = (0);
    } else if (ID == "C") {
        rotateOffset = (90);
    } else if (ID == "D") {
        rotateOffset = (180);
    }
}


//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------

void ANGLE_HANDLE::setup(string _ID) {
    this-> ID = _ID;
    if (ID == "A") {
        rotateOffset = ofDegToRad(-90);
    } else if (ID == "B") {
        rotateOffset = ofDegToRad(0);
    } else if (ID == "C") {
        rotateOffset = ofDegToRad(90);
    } else if (ID == "D") {
        rotateOffset = ofDegToRad(180);
    }
}

void ANGLE_HANDLE::update() {
    ofPushMatrix();
    //rotateAngle += 0.1;
    ofTranslate(centerX, centerY);
    ofRotateDeg(rotateAngle);
    
    float rotateX = cos(ofDegToRad(rotation) + rotateOffset + ofDegToRad(rotateAngle));
    float rotateY = sin(ofDegToRad(rotation) + rotateOffset + ofDegToRad(rotateAngle));
    
    this-> x = centerX + rotateX * assemblyRadius;
    this-> y = centerY + rotateY * assemblyRadius;
    
    if (this-> ID == "A") {
        ofTranslate(0, -assemblyRadius);
        buttonA.draw("A", rotateAngle);
    } else if (this-> ID == "B") {
        ofTranslate(assemblyRadius, 0);
        buttonB.draw("B", rotateAngle);
    } else if (this-> ID == "C") {
        ofTranslate(0, assemblyRadius);
        buttonC.draw("C", rotateAngle);
    } else if (this-> ID == "D") {
        ofTranslate(-assemblyRadius, 0);
        buttonD.draw("D", rotateAngle);
    }
    ofPopMatrix();
    
    float magicNumber = clickRadius / 5.5; //THIS MAGIC NUMBER MUST BE FOUND
    
    float rotateAngleBot = -45 + magicNumber;
    float rotateAngleTop = 45 - magicNumber;
    rotateAngle = ofClamp(rotateAngle, rotateAngleBot, rotateAngleTop);
}

void ANGLE_HANDLE::frameDisplay() {
    ofPushMatrix();
    ofTranslate(centerX, centerY);
    ofRotateDeg(rotateAngle);
    
    if (this-> ID == "A") {
        buttonA.frameShow();
    } else if (this-> ID == "B") {
        buttonB.frameShow();
    } else if (this-> ID == "C") {
        buttonC.frameShow();
    } else if (this-> ID == "D") {
        buttonD.frameShow();
    }
    ofPopMatrix();
}

void ANGLE_HANDLE::touchDown(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, x, y) < clickRadius) {
        clicked = true;
    }
}

//--------------------------------------------------------------
void ANGLE_HANDLE::touchMoved(ofTouchEventArgs & touch){
    if (clicked) {
        ignoreOSC = true;
        if (ID == "A") {
            rotateAngle += (cos(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX()) + sin(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY())) / 5;
        } else if (ID == "B") {
            rotateAngle += (cos(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY()) + sin(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX())) / 5;
        } else if (ID == "C") {
            rotateAngle -= (cos(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX()) + sin(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY())) / 5;
        } else if (ID == "D") {
            rotateAngle -= (cos(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY()) + sin(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX())) / 5;
        }
    }
    
    float magicNumber = clickRadius / 5.5; //THIS MAGIC NUMBER MUST BE FOUND
    
    float rotateAngleBot = -45 + magicNumber;
    float rotateAngleTop = 45 - magicNumber;
    rotateAngle = ofClamp(rotateAngle, rotateAngleBot, rotateAngleTop);
    
    anglePercent = ofMap(rotateAngle,rotateAngleBot,rotateAngleTop,45,-45);
}

//--------------------------------------------------------------
void ANGLE_HANDLE::touchUp(ofTouchEventArgs & touch){
    clicked = false;
    ignoreOSC = false;
}

//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------

void ANGLE_BUTTON::draw(string _ID, float _rotateAngle) {
    this-> ID = _ID;
    this-> rotateAngle = _rotateAngle;
    
    ofSetColor(shutterFrameStroke);
    ofDrawCircle(0,0,clickRadius);
    ofSetColor(EOSBlue);
    ofDrawCircle(0,0,clickRadius - angleWeight);
    
    ofRotateDeg(-rotateAngle-rotation);
    
    ofSetColor(white);
    fontMedium.drawString(this-> ID, - fontMedium.stringWidth(ID) / 2, - (fontSmall.stringHeight(ID) / 2) + clickRadius / 2);
}

void ANGLE_BUTTON::frameShow() {
    ofPushStyle();
    ofPushMatrix();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    
    if (ID == "A") {
        ofTranslate(0, - assemblyDiameter - assemblyRadius / 2);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(0, assemblyRadius, assemblyDiameter, assemblyRadius);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(0, assemblyRadius, assemblyDiameter - shutterStrokeWeight, assemblyRadius - shutterStrokeWeight);
    } else if (ID == "B") {
        ofTranslate(assemblyDiameter + assemblyRadius / 2, 0);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(-assemblyRadius, 0, assemblyRadius, assemblyDiameter);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(-assemblyRadius, 0, assemblyRadius - shutterStrokeWeight, assemblyDiameter - shutterStrokeWeight);
    } else if (ID == "C") {
        ofTranslate(0, assemblyDiameter + assemblyRadius / 2);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(0, -assemblyRadius, assemblyDiameter, assemblyRadius);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(0, -assemblyRadius, assemblyDiameter - shutterStrokeWeight, assemblyRadius - shutterStrokeWeight);
    } else if (ID == "D") {
        ofTranslate(- assemblyDiameter - assemblyRadius / 2, 0);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(assemblyRadius, 0, assemblyRadius, assemblyDiameter);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(assemblyRadius, 0, assemblyRadius - shutterStrokeWeight, assemblyDiameter - shutterStrokeWeight);
    }
    
    ofPopMatrix();
    ofPopStyle();
}
