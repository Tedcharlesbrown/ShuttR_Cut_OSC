#pragma once

#include "ofxiOS.h"

class BUTTON {
    
public:
    void showPage(string ID, float x, float y, float width, float height);
//    void show(float x, float y, float width, float height); //NO TEXT
    
    void show(string ID, float x, float y, float width, float height, string textSize); //ONE TEXT
    void show(string ID, float x, float y, float width, float height, string textSize, ofColor color); //ONE TEXT WITH COLOR
    void show(string ID, string ID2, float x, float y, float width, float height); //TWO TEXT
    void show(string ID, string ID2, float x, float y, float width, float height, string textSize, ofColor color); //TWO TEXT

    void showInt(string ID, float x, float y , float width, float height);
    
    void showBig(string ID, string ID2, float x, float y, float width, float height); //TWO TEXT WITH BOTTOM
    
    void showDS(string _ID, string _ID2, float _x, float _y, float _w, float _h, ofColor color); //DIRECT SELECT
    
    void touchDown(ofTouchEventArgs & touch);
    void touchDown(ofTouchEventArgs & touch, bool toggle);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    string ID;
    float x, y, w, h;
    bool clicked = false;
    bool doubleClicked = false;
    bool action = false;
    bool released = false;
    
private:
};

