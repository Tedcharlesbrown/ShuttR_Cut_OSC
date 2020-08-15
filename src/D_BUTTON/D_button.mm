#include "D_button.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ----------NO TEXT----------
//--------------------------------------------------------------

void BUTTON::show(float _x, float _y, float _w, float _h) { //NO TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(shutterOutsideStroke);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked && !settingsMenu) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------ONE LINE----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, float _x, float _y, float _w, float _h, string _size) { //ONE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    if (_size == "LARGE") {
        fontLarge.drawString(_ID, _x - fontLarge.stringWidth(_ID) / 2, _y + fontLarge.stringHeight("+") / 1.25);//INPUT
    } else if (_size == "MEDIUM") {
        fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y + fontMedium.stringHeight(_ID) / 2);//INPUT
    } else if (_size == "SMALL") {
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y + fontSmall.stringHeight(_ID) / 2);//INPUT
    }
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------ONE LINE - WITH COLOR----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, float _x, float _y, float _w, float _h, string _size, ofColor color) { //ONE TEXT WITH COLOR
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(color);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    if (_size == "LARGE") {
        fontLarge.drawString(_ID, _x - fontLarge.stringWidth(_ID) / 2, _y + fontLarge.stringHeight("+") / 1.25);//INPUT
    } else if (_size == "MEDIUM") {
        fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y + fontMedium.stringHeight(_ID) / 2);//INPUT
    } else if (_size == "SMALL") {
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y + fontSmall.stringHeight(_ID) / 2);//INPUT
    }
    
    ofPopStyle();
}


//--------------------------------------------------------------
// MARK: ----------TWO LINE----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, string _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y );//INPUT
    fontSmall.drawString(_ID2, _x - fontSmall.stringWidth(_ID2) / 2, _y + fontMedium.stringHeight("+") * 1.25);//INPUT
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------TWO LINE - WITH COLOR----------
//--------------------------------------------------------------

void BUTTON::show(string _ID, string _ID2, float _x, float _y, float _w, float _h, string _size, ofColor color) { //DOUBLE TEXT WITH COLOR
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(color);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    if (_size == "LARGE") {
        fontLarge.drawString(_ID, _x - fontLarge.stringWidth(_ID) / 2, _y);
    } else if (_size == "MEDIUM") {
        fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y);
    } else if (_size == "SMALL") {
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y);
    }
    fontSmall.drawString(_ID2, _x - fontSmall.stringWidth(_ID2) / 2, _y + fontMedium.stringHeight("+") * 1.25);//INPUT
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------TWO LINE (WITH BOTTOM)----------
//--------------------------------------------------------------

void BUTTON::showBig(string _ID, string _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT WITH BOTTOM
    this-> x = _x;
    this-> y = _y + _h / 2;
    this-> w = _w;
    this-> h = _h * 1.5;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y + _h / 1.5, _w, _h, buttonCorner);
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y + _h / 1.5, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    
    ofSetColor(EOSState);
    
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y + fontMedium.stringHeight(_ID) / 2);//INPUT
    fontMedium.drawString(_ID2, _x - fontMedium.stringWidth(_ID2) / 2, _y + _h / 1.25 + fontMedium.stringHeight(_ID2) / 2);//INPUT
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------DIRECT SELECT----------
//--------------------------------------------------------------

void BUTTON::showDS(string _ID, string _ID2, float _x, float _y, float _w, float _h, ofColor color) { //DIRECT SELECT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(color);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    
    fontTiny.drawString(_ID2, _x + (_w / 4) - fontTiny.stringWidth(_ID2) / 2, _y + (_h / 3) + fontTiny.stringHeight(_ID2) / 2);//NUMBER
    
    
    
    int maxLineLength = 8;
    string dName = _ID;
    vector<string> dNames;
    if (dName.find(" ") != string::npos) { //IF NAME HAS A SPACE
        
        
        fontSmall.drawString(dName, _x - fontSmall.stringWidth(_ID) / 2, _y + fontSmall.stringHeight(_ID) / 2);//INPUT
        
        
    } else if (dName.length() > maxLineLength) { //IF NAME DOES NOT HAVE SPACE IN IT
        for (int i = 0; i < dName.length(); i += maxLineLength) {
            dNames.push_back(dName.substr(i,maxLineLength));
        }
        if (dNames.size() == 2) {
            fontSmall.drawString(dNames.at(0), _x - fontSmall.stringWidth(dNames.at(0)) / 2, _y);//NAME
            fontSmall.drawString(dNames.at(1), _x - fontSmall.stringWidth(dNames.at(1)) / 2, _y + fontSmall.stringHeight(dNames.at(1)));//NAME
        } else if (dNames.size() == 3) {
            fontSmall.drawString(dNames.at(0), _x - fontSmall.stringWidth(dNames.at(0)) / 2, _y - fontSmall.stringHeight(dNames.at(0)) / 2);//NAME
            fontSmall.drawString(dNames.at(1), _x - fontSmall.stringWidth(dNames.at(1)) / 2, _y + fontSmall.stringHeight(dNames.at(1)) / 2);//NAME
            fontSmall.drawString(dNames.at(2), _x - fontSmall.stringWidth(dNames.at(2)) / 2, _y + fontSmall.stringHeight(dNames.at(2)) * 2);//NAME
        } else if (dNames.size() > 3) {
            ofPushMatrix();
            ofTranslate(0,-fontSmall.stringHeight("+") / 2);
            fontSmall.drawString(dNames.at(0), _x - fontSmall.stringWidth(dNames.at(0)) / 2, _y - fontSmall.stringHeight(dNames.at(0)));//NAME
            fontSmall.drawString(dNames.at(1), _x - fontSmall.stringWidth(dNames.at(1)) / 2, _y);//NAME
            fontSmall.drawString(dNames.at(2), _x - fontSmall.stringWidth(dNames.at(2)) / 2, _y + fontSmall.stringHeight(dNames.at(2)));//NAME
            fontSmall.drawString(dNames.at(3), _x - fontSmall.stringWidth(dNames.at(3)) / 2, _y + fontSmall.stringHeight(dNames.at(3)) * 2);//NAME
            ofPopMatrix();

        }
    }
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------EVENTS----------
//--------------------------------------------------------------

void BUTTON::touchDown(ofTouchEventArgs & touch){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        this-> clicked = true;
        this-> action = true;
    }
}

//--------------------------------------------------------------
void BUTTON::touchDown(ofTouchEventArgs & touch, bool toggle){
    if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
        if (toggle) {
            this-> clicked = !clicked;
        } else {
            this-> clicked = true;
        }
        this-> action = true;
    }
}

//--------------------------------------------------------------
void BUTTON::touchUp(ofTouchEventArgs & touch){
    if (clicked) {
        this-> released = true;
    }
    this-> clicked = false;
    this-> doubleClicked = false;
}

//--------------------------------------------------------------
void BUTTON::touchDoubleTap(ofTouchEventArgs & touch){
    this-> doubleClicked = true;
}
//--------------------------------------------------------------

