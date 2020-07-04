#ifndef B_page_h
#define B_page_h

#include "ofxiOS.h"

class PAGE {
public:

    void pageButton(float x, float y, float width, float height, float weight);
    
    void touchDown(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    float x, y, w, h;
    bool clicked = false;
    bool action = false;
    
    
    
private:
};

#endif
