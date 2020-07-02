#ifndef gui_h
#define gui_h

#include "ofxiOS.h"

class gui {
    
public:
    void settingsBar(float x,float y,float width,float height,ofColor stroke,float strokeWeight,ofColor fill);
    void settingsButton(float x, float y, float width, float height, float round, ofColor stroke, float weight, ofColor onFill, ofColor offFill);
    void oscLight(string ID, float x, float y, float width, float height, float round, ofColor stroke, float weight, ofColor onSend, ofColor offSend, ofColor onGet, ofColor offGet);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    bool oscSendLight = false;
    bool oscReceiveLight = false;
    
    float settingsX, settingsY, settingsWidth, settingsHeight;
    bool settingsMenu = false;
    
private:
};

#endif 

