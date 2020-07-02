#ifndef gui_h
#define gui_h

#include "ofxiOS.h"

class gui {
    
public:
    void settingsBar(float x,float y,float width,float height,ofColor stroke,float strokeWeight,ofColor fill);
    void settingsButton(float x, float y, float width, float height, float round, ofColor stroke, float strokeWeight, ofColor onFill, ofColor offFill);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    bool oscPackageSendLight = false;
    bool oscPackageReceiveLight = false;
    
    float settingsX, settingsY, settingsWidth, settingsHeight;
    bool settingsMenu = false;
    
private:
};

#endif 

