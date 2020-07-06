#include "A_ofApp.h"

//--------------------------------------------------------------

void GUI::pageTwoUpdate() {
    if (irisButton.action && irisButton.clicked) {
        irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
        irisButton.action = false;
    } else if (edgeButton.action && edgeButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
        edgeButton.action = false;
    } else if (zoomButton.action && zoomButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
        zoomButton.action = false;
    } else if (frostButton.action && frostButton.clicked) {
        irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
        frostButton.action = false;
    }
}

void GUI::pageTwoShow() {
    irisButton.show("IRIS", "100%", guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight, true);
    edgeButton.show("EDGE", "40%", guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, true);
    zoomButton.show("ZOOM", "20%", guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, true);
    frostButton.show("FROST", "74%", guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight, true);
    
    minusPercentButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    homeButton.show("HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
    plusPercentButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, "MEDIUM");
}
