#include "D_button.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ----------PAGE BUTTONS----------
//--------------------------------------------------------------

void BUTTON::showPage(string _ID, float _x, float _y, float _w, float _h) { //ONE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(shutterOutsideStroke);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    ofColor clickColor = white;
    
    if (this-> clicked && !settingsMenu) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
        clickColor = ofColor(175,175,175);
    }
    
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    if (_ID != "DS") {
        ofSetColor(EOSBackground);
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2.2, _y + fontSmall.stringHeight(_ID) / 1.75);//SHADOW
        ofSetColor(clickColor);
        fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y + fontSmall.stringHeight(_ID) / 2);//INPUT
    } else {
        ofSetColor(EOSBackground);
        fontSmall.drawString("DIRECT", _x - fontSmall.stringWidth("DIRECT") / 2.1, _y + fontSmall.stringHeight("DIRECT") * 0.2);//SHADOW
        fontSmall.drawString("SELECTS", _x - fontSmall.stringWidth("SELECTS") / 2.1, _y + fontSmall.stringHeight("SELECTS") * 1.45);//SHADOW
        ofSetColor(clickColor);
        fontSmall.drawString("DIRECT", _x - fontSmall.stringWidth("DIRECT") / 2, _y );//INPUT
        fontSmall.drawString("SELECTS", _x - fontSmall.stringWidth("SELECTS") / 2, _y + fontSmall.stringHeight("SELECTS") * 1.25);//INPUT
    }
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
// MARK: ----------IMAGE BUTTON----------
//--------------------------------------------------------------

void BUTTON::showImage(string _ID, string _ID2, string _ID3, float _x, float _y, float _w, float _h) { //DOUBLE TEXT WITH BOTTOM
    this-> x = _x;
    this-> y = _y + _h / 2;
    this-> w = _w;
    this-> h = _h * 1.5;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);

    //BOTTOM
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y + _h / 0.75, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y + _h / 0.75, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    //MIDDLE
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y + _h / 1.5, _w, _h, buttonCorner);
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y + _h / 1.5, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    //TOP
    ofSetColor(EOSState);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    ofSetColor(white);
    fontSmall.drawString(_ID, _x - fontSmall.stringWidth(_ID) / 2, _y + fontSmall.stringHeight(_ID) / 2);//INPUT
    fontMedium.drawString(_ID2, _x - fontMedium.stringWidth(_ID2) / 2, _y + _h / 1.25 + fontMedium.stringHeight(_ID2) / 2);//INPUT
    fontMedium.drawString(_ID3, _x - fontMedium.stringWidth(_ID3) / 2, _y + _h * 1.5 + fontMedium.stringHeight(_ID3) / 2);//INPUT
    
    ofPopStyle();
}

//--------------------------------------------------------------
// MARK: ----------INTENSITY----------
//--------------------------------------------------------------

void BUTTON::showInt(string _ID, float _x, float _y, float _w, float _h) { //ONE TEXT
    this-> x = _x;
    this-> y = _y;
    this-> w = _w;
    this-> h = _h;
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    
    ofSetColor(EOSState);
//    ofSetColor(shutterColor);
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner);
    
    ofColor intensityColor = shutterColor;
    
    
    if (this-> clicked) {
        ofSetColor(buttonActive);
    } else {
        ofSetColor(black);
    }
    ofDrawRectRounded(_x, _y, _w - buttonStrokeWeight, _h - buttonStrokeWeight, buttonCorner);
    
    intensityColor.setBrightness(100);
    ofSetColor(intensityColor);
    fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2.1, _y + (fontMedium.stringHeight(_ID) / 2) + _h / 3.85);//INPUT
    
    intensityColor.setBrightness(255);
    ofSetColor(intensityColor);
    fontMedium.drawString(_ID, _x - fontMedium.stringWidth(_ID) / 2, _y + (fontMedium.stringHeight(_ID) / 2) + _h / 4);//INPUT
    
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
    
    
    int maxLineLength = 7;
    string dName = _ID;
    vector<string> dNames;
    
    if (fontDS.stringWidth(dName) < w - buttonStrokeWeight / 2) {
        dNames.push_back(dName);
    } else {
        if (dName.find(" ") != string::npos) { //IF NAME HAS A SPACE
            int numSpaces = std::count(dName.begin(),dName.end(), ' ');
            int letterCount = 0;
            int indexValueEnd = dName.find(" ");
            
            while (numSpaces > 0) {
                indexValueEnd = dName.find(" ");
                letterCount += dName.size();
                dNames.push_back(dName.substr(0,indexValueEnd));
                dName = dName.substr(indexValueEnd + 1);
                if (fontDS.stringWidth(dName) < w - buttonStrokeWeight / 2) {
                    dNames.push_back(dName);
                    numSpaces -= std::count(dName.begin(),dName.end(), ' ');
                }
                numSpaces--;
            }
        } else { //IF NAME DOES NOT HAVE SPACE IN IT
            for (int i = 0; i < dName.length(); i += maxLineLength) {
                dNames.push_back(dName.substr(i,maxLineLength));
            }
        }
    }
    
    if (dNames.size() == 1) {
        fontDS.drawString(dNames.at(0), _x - fontDS.stringWidth(dNames.at(0)) / 2, _y + fontDS.stringHeight(dNames.at(0)) / 2);//INPUT
    } else if (dNames.size() == 2) {
        fontDS.drawString(dNames.at(0), _x - fontDS.stringWidth(dNames.at(0)) / 2, _y);//NAME
        fontDS.drawString(dNames.at(1), _x - fontDS.stringWidth(dNames.at(1)) / 2, _y + fontDS.stringHeight("/") * 1.25);//NAME
    } else if (dNames.size() == 3) {
        fontDS.drawString(dNames.at(0), _x - fontDS.stringWidth(dNames.at(0)) / 2, _y - fontDS.stringHeight("/") / 2);//NAME
        fontDS.drawString(dNames.at(1), _x - fontDS.stringWidth(dNames.at(1)) / 2, _y + fontDS.stringHeight("/") / 2);//NAME
        fontDS.drawString(dNames.at(2), _x - fontDS.stringWidth(dNames.at(2)) / 2, _y + fontDS.stringHeight("/") * 1.5);//NAME
    } else if (dNames.size() > 3) {
        ofPushMatrix();
        ofTranslate(0,-fontDS.stringHeight("+") / 1.5);
        fontDS.drawString(dNames.at(0), _x - fontDS.stringWidth(dNames.at(0)) / 2, _y - fontDS.stringHeight("/"));//NAME
        fontDS.drawString(dNames.at(1), _x - fontDS.stringWidth(dNames.at(1)) / 2, _y);//NAME
        fontDS.drawString(dNames.at(2), _x - fontDS.stringWidth(dNames.at(2)) / 2, _y + fontDS.stringHeight("/"));//NAME
        fontDS.drawString(dNames.at(3), _x - fontDS.stringWidth(dNames.at(3)) / 2, _y + fontDS.stringHeight("/") * 2);//NAME
        ofPopMatrix();
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

