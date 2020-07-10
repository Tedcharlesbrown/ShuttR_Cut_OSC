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
        rotateOffset = (-90);
    } else if (ID == "B") {
        rotateOffset = (0);
    } else if (ID == "C") {
        rotateOffset = (90);
    } else if (ID == "D") {
        rotateOffset = (180);
    }
}

void ANGLE_HANDLE::update() {
    ofPushMatrix();
    //rotateAngle += 0.1;
    ofRotateDeg(rotateAngle);
    this-> x = centerX + cos(rotation + rotateOffset + rotateAngle) * assemblyRadius;
    this-> y = centerY + sin(rotation + rotateOffset + rotateAngle) * assemblyRadius;
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
    
//    if (this-> ID == "A") {
//        ofRotateDeg(rotateAngle);
//        this-> x = centerX + cos(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        this-> y = centerY + sin(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        ofTranslate(0, -assemblyRadius);
//        buttonA.draw();
//    } else if (this-> ID == "B") {
//        ofRotateDeg(rotateAngle);
//        this-> x = centerX + cos(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        this-> y = centerY + sin(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        ofTranslate(assemblyRadius, 0);
//        buttonB.draw();
//    } else if (this-> ID == "C") {
//        ofRotateDeg(rotateAngle);
//        this-> x = centerX + cos(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        this-> y = centerY + sin(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        ofTranslate(0, assemblyRadius);
//        buttonC.draw();
//    } else if (this-> ID == "D") {
//        ofRotateDeg(rotateAngle);
//        this-> x = centerX + cos(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        this-> y = centerY + sin(rotation + rotateOffset + rotateAngle) * assemblyRadius;
//        ofTranslate(-assemblyRadius, 0);
//        buttonD.draw();
//    }
    ofPopMatrix();
}

//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------

//rotate(-rotation);
//fill(angleText);
//textSize(clickRadius);
//textAlign(CENTER, CENTER);
//text(this.ID, -1, -3);

void ANGLE_BUTTON::draw(string _ID, float _rotateAngle) {
    this-> ID = _ID;
    this-> rotateAngle = _rotateAngle;
    
    ofSetColor(shutterFrameStroke);
    ofDrawCircle(0,0,clickRadius);
    ofSetColor(EOSBlue);
    ofDrawCircle(0,0,clickRadius - angleWeight);
    
    ofRotateDeg(-rotateAngle);
    
    ofSetColor(white);
    fontMedium.drawString(this-> ID, - fontMedium.stringWidth(ID) / 2, - (fontSmall.stringHeight(ID) / 2) + clickRadius / 2);
    
}
