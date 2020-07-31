#include "E_shutterHandles.h"

//--------------------------------------------------------------

void THRUST_HANDLE::setup(string _ID) {
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

void THRUST_HANDLE::update() {
    _thrustDiameter = thrustDiameter * 1.5;
    ofPushMatrix();
    if (this-> ID == "A") {
        this-> sliderX = centerX + cos(ofDegToRad(rotation) + (rotateOffset))  * buttonA.position * _thrustDiameter;
        this-> sliderY = centerY + sin(ofDegToRad(rotation) + (rotateOffset))  * buttonA.position * _thrustDiameter;
        ofTranslate(0,- buttonA.position * _thrustDiameter);
        buttonA.draw(this-> ID, (rotateOffset));
    } else if (this-> ID == "B") {
        this-> sliderX = centerX + cos(ofDegToRad(rotation) + (rotateOffset)) * buttonB.position * _thrustDiameter;
        this-> sliderY = centerY + sin(ofDegToRad(rotation) + (rotateOffset)) * buttonB.position * _thrustDiameter;
        ofTranslate(buttonB.position * _thrustDiameter,0);
        buttonB.draw(this-> ID, (rotateOffset));
    } else if (this-> ID == "C") {
        this-> sliderX = centerX + cos(ofDegToRad(rotation) + (rotateOffset)) * buttonC.position * _thrustDiameter;
        this-> sliderY = centerY + sin(ofDegToRad(rotation) + (rotateOffset)) * buttonC.position * _thrustDiameter;
        ofTranslate(0,buttonC.position * _thrustDiameter);
        buttonC.draw(this-> ID, (rotateOffset));
    } else if (this-> ID == "D") {
        this-> sliderX = centerX + cos(ofDegToRad(rotation) + (rotateOffset)) * buttonD.position * _thrustDiameter;
        this-> sliderY = centerY + sin(ofDegToRad(rotation) + (rotateOffset)) * buttonD.position * _thrustDiameter;
        ofTranslate(- buttonD.position * _thrustDiameter, 0);
        buttonD.draw(this-> ID, (rotateOffset));
    }
    ofPopMatrix();
}

void THRUST_HANDLE::touchDown(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, this-> sliderX, this-> sliderY) < clickRadius) {
        this-> clicked = true;
        ignoreOSC = true;
    }
}

void THRUST_HANDLE::touchMoved(ofTouchEventArgs & touch){
    this-> diff = (cos(ofDegToRad(rotation) + rotateOffset) * (touch.x - ofGetPreviousMouseX()) + sin(ofDegToRad(rotation) + rotateOffset) * (touch.y - ofGetPreviousMouseY()));
    if (this-> clicked) {
        if (this-> ID == "A") {
            buttonA.addOffset(ofMap(this-> diff, 0, _thrustDiameter, 0, 1));
        } else if (this-> ID == "B") {
            buttonB.addOffset(ofMap(this-> diff, 0, _thrustDiameter, 0, 1));
        } else if (this-> ID == "C") {
            buttonC.addOffset(ofMap(this-> diff, 0, _thrustDiameter, 0, 1));
        } else if (this-> ID == "D") {
            buttonD.addOffset(ofMap(this-> diff, 0, _thrustDiameter, 0, 1));
        }
    }
}

void THRUST_HANDLE::touchUp(ofTouchEventArgs & touch){
    this-> clicked = false;
}

//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------

void THRUST_BUTTON::draw(string _ID, float _rotateAngle) {
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

void THRUST_BUTTON::addOffset(float _diff) {
    float topLimit = clickDiameter / assemblyRadius;
    position = ofClamp(position + _diff, topLimit, 1);
    output = ofMap(position,topLimit,1,100,0);
}

void THRUST_BUTTON::angleLimit(float _angleRotateLimit){
    float angleLimit = abs(_angleRotateLimit);
    angleLimit = ofMap(angleLimit, 0, 45, 1, (clickDiameter / assemblyRadius) + 0.5);
    position = ofClamp(position, clickDiameter / assemblyRadius, angleLimit);
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
    magicNumber = clickRadius / 5.5; //THIS MAGIC NUMBER MUST BE FOUND
}

void ANGLE_HANDLE::update() {
    ofPushMatrix();
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
    
    calculateAngle();
}

void ANGLE_HANDLE::frameDisplay(float _thrust) {
    ofPushMatrix();
    ofTranslate(centerX, centerY);
    
    float rotateAngleBot = (-45) + magicNumber;
    float rotateAngleTop = (45) - magicNumber;
    
    float rotateAngleReal = ofMap(rotateAngle, rotateAngleBot, rotateAngleTop, -45, 45);
    
    ofRotateDeg(rotateAngleReal + rotation);
    
    if (this-> ID == "A") {
        buttonA.frameShow(_thrust);
    } else if (this-> ID == "B") {
        buttonB.frameShow(_thrust);
    } else if (this-> ID == "C") {
        buttonC.frameShow(_thrust);
    } else if (this-> ID == "D") {
        buttonD.frameShow(_thrust);
    }
    ofPopMatrix();
}

//--------------------------------------------------------------

void ANGLE_HANDLE::calculateAngle() {
    float rotateAngleBot = -45 + magicNumber;
    float rotateAngleTop = 45 - magicNumber;
    rotateAngle = ofClamp(rotateAngle, rotateAngleBot, rotateAngleTop);
    
    anglePercent = ofMap(rotateAngle,rotateAngleBot,rotateAngleTop,45,-45);
}

//--------------------------------------------------------------

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
    calculateAngle();
}

//--------------------------------------------------------------
void ANGLE_HANDLE::touchUp(ofTouchEventArgs & touch){
    clicked = false;
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

void ANGLE_BUTTON::frameShow(float _thrust) {
    ofPushStyle(); ofPushMatrix();
    ofSetRectMode(OF_RECTMODE_CENTER);
    float thrustOffset = ofMap(_thrust, clickDiameter / assemblyRadius, 1, 1, 0);
    
    float shutterWidth = assemblyDiameter + outsideWeight * 2;
    float shutterHeight = assemblyRadius + outsideWeight;
    
    if (ID == "A") {
        ofTranslate(0, - assemblyDiameter + assemblyRadius / 2);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(0, assemblyRadius * thrustOffset, shutterWidth, shutterHeight);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(0, assemblyRadius * thrustOffset, shutterWidth - shutterStrokeWeight, shutterHeight - shutterStrokeWeight);
    } else if (ID == "B") {
        ofTranslate(assemblyDiameter - assemblyRadius / 2, 0);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(-assemblyRadius * thrustOffset, 0, shutterHeight, shutterWidth);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(-assemblyRadius * thrustOffset, 0, shutterHeight - shutterStrokeWeight, shutterWidth - shutterStrokeWeight);
    } else if (ID == "C") {
        ofTranslate(0, assemblyDiameter - assemblyRadius / 2);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(0, -assemblyRadius * thrustOffset, shutterWidth, shutterHeight);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(0, -assemblyRadius * thrustOffset, shutterWidth - shutterStrokeWeight, shutterHeight - shutterStrokeWeight);
    } else if (ID == "D") {
        ofTranslate(- assemblyDiameter + assemblyRadius / 2, 0);
        ofSetColor(shutterFrameStroke);
        ofDrawRectangle(assemblyRadius * thrustOffset, 0, shutterHeight, shutterWidth);
        ofSetColor(shutterFrameFill);
        ofDrawRectangle(assemblyRadius * thrustOffset, 0, shutterHeight - shutterStrokeWeight, shutterWidth - shutterStrokeWeight);
    }
    
    ofPopStyle(); ofPopMatrix();
}
