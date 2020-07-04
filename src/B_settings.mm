#include "B_gui.h"
#include "A_ofApp.h"

void SETTINGS::ipFieldDraw(float _x, float _y, float _w, float _h, float _weight) {
    this-> ip_x = _x;
    this-> ip_y = _y;
    this-> ip_w = _w;
    this-> ip_h = _h;
    
    string ip = "IP ADDRESS";

    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);

    if (this-> ip_clicked) {
        ofSetColor(EOSBlind);
    } else {
        ofSetColor(EOSLive);
    }
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner); //OUTSIDE STROKE
    
    ofSetColor(black);
    ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, buttonCorner); //INNER FILL
    
    ofSetColor(white);
    fontMedium.drawString(ip, _x - fontMedium.stringWidth(ip) / 2, _y - fontMedium.stringHeight(ip) - _weight * 2); //"IP ADDRESS"
    
    fontLarge.drawString(userInputIP, _x - fontLarge.stringWidth(userInputIP) / 2, _y + fontLarge.stringHeight(userInputIP) / 2); //INPUT
    

    ofPopStyle();
}

void SETTINGS::idFieldDraw(float _x, float _y, float _w, float _h, float _weight) {
    this-> id_x = _x;
    this-> id_y = _y;
    this-> id_w = _w;
    this-> id_h = _h;

    string user = "USER";

    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);

    if (this-> id_clicked) {
        ofSetColor(EOSBlind);
    } else {
        ofSetColor(EOSLive);
    }
    ofDrawRectRounded(_x, _y, _w, _h, buttonCorner); //OUTSIDE STROKE
    
    ofSetColor(black);
    ofDrawRectRounded(_x, _y, _w - _weight, _h - _weight, buttonCorner); //INNER FILL
    
    ofSetColor(white);
    fontMedium.drawString(user, _x - fontMedium.stringWidth(user) / 2, _y - fontMedium.stringHeight(user) - _weight * 2); //"USER"
    
    fontLarge.drawString(userInputID, _x - fontLarge.stringWidth(userInputID) / 2, _y + fontLarge.stringHeight(userInputID) / 2);//INPUT
    

    ofPopStyle();
}

void SETTINGS::touchDown(ofTouchEventArgs & touch){
    if (touch.x > ip_x - ip_w / 2 && touch.x < ip_x + ip_w / 2 && touch.y > ip_y - ip_h / 2 && touch.y < ip_y + ip_h / 2) {
        this-> ip_clicked = true;
        this-> ip_action = true;
    } else if (touch.x > id_x - ip_w / 2 && touch.x < id_x + ip_w / 2 && touch.y > id_y - ip_h / 2 && touch.y < id_y + ip_h / 2) {
        this-> id_clicked = true;
        this-> id_action = true;
    }
}
