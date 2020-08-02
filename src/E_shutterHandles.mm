#include "E_shutterHandles.h"

//--------------------------------------------------------------
// MARK: ----------THRUST_HANDLE----------
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

void THRUST_HANDLE::touchMoved(ofTouchEventArgs & touch, bool fine){
    if (fine) {
        this-> diff = (cos(ofDegToRad(rotation) + rotateOffset) * (touch.x - ofGetPreviousMouseX()) + sin(ofDegToRad(rotation) + rotateOffset) * (touch.y - ofGetPreviousMouseY())) / 6;
    } else {
        this-> diff = cos(ofDegToRad(rotation) + rotateOffset) * (touch.x - ofGetPreviousMouseX()) + sin(ofDegToRad(rotation) + rotateOffset) * (touch.y - ofGetPreviousMouseY());
    }
    if (this-> clicked) {
        //        if (pairAC) {
        //            if (this-> ID == "A" || this-> ID == "C") { //WILL HAVE TO FLIP ONE INPUT
        //                buttonA.addOffset(ofMap(this-> diff, 0, _thrustDiameter, 0, 1));
        //                buttonC.addOffset(ofMap(this-> diff, 0, _thrustDiameter, 0, 1));
        //            }
        //        }
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
    this-> doubleClicked = false;
}

//--------------------------------------------------------------

void THRUST_HANDLE::touchDoubleTap(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, this-> sliderX, this-> sliderY) < clickRadius) {
        this-> doubleClicked = true;
        if (ID == "A") {
            buttonA.position = 1;
            buttonA.output = 0;
        } else if (ID == "B") {
            buttonB.output = 0;
            buttonB.position = 1;
        } else if (ID == "C") {
            buttonC.position = 1;
            buttonC.output = 0;
        } else if (ID == "D") {
            buttonD.position = 1;
            buttonD.output = 0;
        }
    }
}

//--------------------------------------------------------------
// MARK: ----------THRUST_BUTTON----------
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
    float topLimit = clickDiameter / assemblyRadius;
    int angle = abs(_angleRotateLimit);
    float angleLimit = 0;
    
    //TODO: FIX THIS IMPLEMENTATION, WHAT IS SPECIAL ABOUT 0.375? (PERCENTAGE OF THRUST)
    switch(angle) {
        case 0:
            angleLimit = angle;
            break;
        case 1:
            angleLimit = angle - 0.1;
            break;
        case 2:
            angleLimit = angle - 0.3;
            break;
        case 3:
            angleLimit = angle - 0.4;
            break;
        case 4:
            angleLimit = angle - 0.5;
            break;
        case 5:
            angleLimit = angle - 0.6;
            break;
        case 6:
            angleLimit = angle - 0.7;
            break;
        case 7:
            angleLimit = angle - 0.9;
            break;
        case 8:
            angleLimit = angle - 1;
            break;
        case 9:
            angleLimit = angle - 1.1;
            break;
        case 10:
            angleLimit = angle - 1.2;
            break;
        case 11:
            angleLimit = angle - 1.3;
            break;
        case 12:
            angleLimit = angle - 1.4;
            break;
        case 13:
        case 14:
            angleLimit = angle - 1.5;
            break;
        case 15:
            angleLimit = angle - 1.6;
            break;
        case 16:
        case 17:
            angleLimit = angle - 1.7;
            break;
        case 18:
        case 19:
        case 20:
        case 21:
        case 22:
        case 23:
            angleLimit = angle - 1.8;
            break;
        case 24:
        case 25:
            angleLimit = angle - 1.7;
            break;
        case 26:
            angleLimit = angle - 1.6;
            break;
        case 27:
            angleLimit = angle - 1.5;
            break;
        case 28:
            angleLimit = angle - 1.4;
            break;
        case 29:
            angleLimit = angle - 1.3;
            break;
        case 30:
            angleLimit = angle - 1.1;
            break;
        case 31:
            angleLimit = angle - 1;
            break;
        case 32:
            angleLimit = angle - 0.8;
            break;
        case 33:
            angleLimit = angle - 0.5;
            break;
        case 34:
            angleLimit = angle - 0.3;
            break;
        case 35:
            angleLimit = angle;
            break;
        case 36:
            angleLimit = angle + 0.3;
            break;
        case 37:
            angleLimit = angle + 0.7;
            break;
        case 38:
            angleLimit = angle + 1.1;
            break;
        case 39:
            angleLimit = angle + 1.5;
            break;
        case 40:
            angleLimit = angle + 2;
            break;
        case 41:
            angleLimit = angle + 2.5;
            break;
        case 42:
            angleLimit = angle + 3;
            break;
        case 43:
            angleLimit = angle + 3.6;
            break;
        case 44:
            angleLimit = angle + 4.3;
            break;
        case 45:
            angleLimit = angle + 5;
            break;
    }
    
    float angleBotLimit = ofMap(angleLimit, 0, 50, 1, topLimit + 0.375);
    float angleTopLimit = 1 - angleBotLimit;
    position = ofClamp(position, topLimit + angleTopLimit, angleBotLimit);
}

//--------------------------------------------------------------
// MARK: ----------ANGLE_HANDLE----------
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
        this-> clicked = true;
    }
}

//--------------------------------------------------------------

void ANGLE_HANDLE::touchMoved(ofTouchEventArgs & touch, bool fine){
    if (clicked) {
        ignoreOSC = true;
        
        int fineAdjust = 5;
        if (fine) {
            fineAdjust = 20;
        }
        
        if (ID == "A") {
            rotateAngle += (cos(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX()) + sin(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY())) / fineAdjust;
        } else if (ID == "B") {
            rotateAngle += (cos(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY()) + sin(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX())) / fineAdjust;
        } else if (ID == "C") {
            rotateAngle -= (cos(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX()) + sin(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY())) / fineAdjust;
        } else if (ID == "D") {
            rotateAngle -= (cos(ofDegToRad(rotation)) * (touch.y - ofGetPreviousMouseY()) + sin(ofDegToRad(rotation)) * (touch.x - ofGetPreviousMouseX())) / fineAdjust;
        }
    }
    calculateAngle();
}

//--------------------------------------------------------------
void ANGLE_HANDLE::touchUp(ofTouchEventArgs & touch){
    this-> clicked = false;
    this-> doubleClicked = false;
}

//--------------------------------------------------------------

void ANGLE_HANDLE::touchDoubleTap(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, x, y) < clickRadius) {
        this-> doubleClicked = true;
        rotateAngle = 0;
    }
}

//--------------------------------------------------------------
// MARK: ----------ANGLE_BUTTON----------
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

//--------------------------------------------------------------
// MARK: ----------ASSEMBLY----------
//--------------------------------------------------------------

void ASSEMBLY_HANDLE::setup() {
    frameX = centerX;
    frameY = centerY + assemblyRadius + clickDiameter * 1.5;
    defaultX = frameX;
    botLimit = centerX - assemblyRadius;
    topLimit = centerX + assemblyRadius;
}

//--------------------------------------------------------------

void ASSEMBLY_HANDLE::update() {
    frameX = ofClamp(frameX, botLimit, topLimit);
    rotation = ofMap(frameX, botLimit, topLimit, 45, -45);
    
    ofPushStyle();

    // ----------HORIZONTAL LINE----------
    ofSetColor(shutterOutsideStroke);
    ofDrawRectRounded(botLimit, frameY - assemblyLineWeight / 2, assemblyDiameter, assemblyLineWeight, buttonCorner);
    
    // ----------VERTICAL LINE----------
    ofSetColor(shutterOutsideStroke);
    ofDrawRectRounded(centerX - assemblyLineWeight / 2, frameY - clickRadius / 2, assemblyLineWeight, clickRadius, buttonCorner);
    
    // ----------BUTTON----------
    // OUTSIDE BUTTON
    ofSetColor(shutterFrameStroke);
    ofDrawCircle(frameX, frameY, clickRadius);
    // INSIDE BUTTON
    ofSetColor(shutterOutsideStroke);
    ofDrawCircle(frameX, frameY, clickRadius - assemblyButtonWeight);
    
    ofPopStyle();
}

//--------------------------------------------------------------

void ASSEMBLY_HANDLE::incomingOSC(float value){
    frameX = ofMap(value, -50, 50, botLimit, topLimit);
}

//--------------------------------------------------------------

void ASSEMBLY_HANDLE::touchDown(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, frameX, frameY) < clickRadius) {
        this-> clicked = true;
        ignoreOSC = true;
    }
}

//--------------------------------------------------------------

void ASSEMBLY_HANDLE::touchMoved(ofTouchEventArgs & touch, bool fine){
    if (clicked) {
        if (fine) {
            frameX += (touch.x - ofGetPreviousMouseX()) / 3;
        } else {
            frameX += (touch.x - ofGetPreviousMouseX());
        }
        output = ofMap(frameX, botLimit, topLimit, -50, 50);
    }
}

//--------------------------------------------------------------

void ASSEMBLY_HANDLE::touchUp(ofTouchEventArgs & touch){
    this-> clicked = false;
    this-> doubleClicked = false;
}

//--------------------------------------------------------------

void ASSEMBLY_HANDLE::touchDoubleTap(ofTouchEventArgs & touch){
    if (ofDist(touch.x, touch.y, frameX, frameY) < clickRadius) {
        this-> doubleClicked = true;
        rotation = 0;
        frameX = defaultX;
        output = 0;
    }
}

