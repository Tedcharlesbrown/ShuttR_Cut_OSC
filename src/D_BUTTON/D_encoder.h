#ifndef D_encoder_h
#define D_encoder_h

#include "ofxiOS.h"

class ENCODER : public ofxiOSApp {
    
public:
    void setup(float size);
    void update();
    void draw(float x, float y);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch, bool fine);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    ofImage encoder;
    int output = 0;
    float currentPos, lastPos = 0;
    float posX, posY;
    bool clicked = false;
    
private:
};

#endif
