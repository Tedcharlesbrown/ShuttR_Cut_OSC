#ifndef style_h
#define style_h

#include "ofxiOS.h"
#include <stdio.h>

class style{
    
public:
    
    
    ofColor white = ofColor(255);
    ofColor EOSBackground = ofColor(15,25,35);
    
    void setup();
    void update();
    void draw();
    void exit();
    
    style() {
    }
    
private:
};

#endif /* particle_h */
