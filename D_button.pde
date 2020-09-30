//--------------------------------------------------------------
// D_button.h && D_button.mm
//--------------------------------------------------------------

class BUTTON {
    float x, y, w, h;
    boolean clicked = false;
    boolean doubleClicked = false;
    boolean action = false;
    boolean released = false;

//--------------------------------------------------------------
// MARK: ----------PAGE BUTTONS----------
//--------------------------------------------------------------

    void showPage(String _ID, float _x, float _y, float _w, float _h) {
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        color clickColor = white;

        if (this.clicked && !settingsMenu) {
            fill(buttonActive);
        } else {
            fill(black);
            clickColor = color(175, 175, 175);
        }
        stroke(shutterOutsideStroke);
        strokeWeight(buttonStrokeWeight);
        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, CENTER);
            textFont(fontSmall);
            fill(white);

            if (_ID != "DS") {
                fill(EOSBackground);
                text(_ID, _x + textWidth(_ID) / 50, _y + smallTextSize / 25); //SHADOW
                fill(clickColor);
                text(_ID, _x, _y); //INPUT
            } else {
                fill(EOSBackground);
                text("DIRECT", _x + textWidth("DIRECT") / 50, _y - smallTextSize / 2.25); //SHADOW
                text("SELECTS", _x + textWidth("SELECTS") / 50, _y + smallTextSize / 1.75); //SHADOW
                fill(clickColor);
                text("DIRECT", _x, _y - smallTextSize / 2); //INPUT
                text("SELECTS", _x, _y + smallTextSize / 2); //INPUT
            }

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------ONE LINE----------
//--------------------------------------------------------------

    void show(String _ID, float _x, float _y, float _w, float _h, String _size) { //ONE TEXT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);

        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, CENTER);
            fill(white);

            if (_size == "LARGE") {
                textFont(fontLarge);
            } else if (_size == "MEDIUM") {
                textFont(fontMedium);
            } else if (_size == "SMALL") {
                textFont(fontSmall);
            }
            text(_ID, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------ONE LINE - WITH COLOR----------
//--------------------------------------------------------------

    void show(String _ID, float _x, float _y, float _w, float _h, String _size, color _color) { //ONE TEXT WITH COLOR
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(_color);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, CENTER);
            fill(white);

            if (_size == "LARGE") {
                textFont(fontLarge);
            } else if (_size == "MEDIUM") {
                textFont(fontMedium);
            } else if (_size == "SMALL") {
                textFont(fontSmall);
            }
            text(_ID, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------TWO LINE----------
//--------------------------------------------------------------

    void show(String _ID, String _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);

        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            fill(white);

            translate(0, smallTextSize / 4);

            textAlign(CENTER, BOTTOM);
            textFont(fontMedium);
            text(_ID, _x, _y); //INPUT

            textAlign(CENTER, TOP);
            textFont(fontSmall);
            text(_ID2, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------TWO LINE - WITH COLOR----------
//--------------------------------------------------------------

    void show(String _ID, String _ID2, float _x, float _y, float _w, float _h, String _size, color _color) { //DOUBLE TEXT WITH COLOR
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(_color);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, BOTTOM);
            fill(white);

            if (_size == "LARGE") {
                textFont(fontLarge);
            } else if (_size == "MEDIUM") {
                translate(0, smallTextSize / 4);
                textFont(fontMedium);
            } else if (_size == "SMALL") {
                textFont(fontSmall);
            }
            text(_ID, _x, _y); //INPUT

            textAlign(CENTER, TOP);
            textFont(fontSmall);
            text(_ID2, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------TWO LINE (WITH BOTTOM)----------
//--------------------------------------------------------------

    void showBig(String _ID, String _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT WITH BOTTOM
        this.x = _x;
        this.y = _y + _h / 2;
        this.w = _w;
        this.h = _h * 1.5;

        push();
        rectMode(CENTER);
        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y + _h / 1.5, _w, _h, buttonCorner); //BOTTOM BUTTON

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner); //TOP BUTTON

        try {

            textAlign(CENTER, CENTER);
            fill(white);
            textFont(fontMedium);

            text(_ID, _x, _y); //INPUT

            text(_ID2, _x, _y + _h / 1.15); //INPUT / - mediumTextSize / 2.5

        } catch (Exception e) {

        }


        pop();
    }

//--------------------------------------------------------------
// MARK: ----------IMAGE BUTTON - COLOR----------
//--------------------------------------------------------------

    void showImage(String _ID, String _ID2, float _x, float _y, float _w, float _h, boolean active) { //TWO TEXT
        this.x = _x;
        this.y = _y + _h / 2.4;
        this.w = _w;
        this.h = _h * 1.9;

        push();
        rectMode(CENTER);
        strokeWeight(buttonStrokeWeight);

        //MIDDLE
        if (active) {
            stroke(EOSState);
        } else {
            stroke(EOSDarkGrey);
        }
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }
        rect(_x, _y + _h / 1.5, _w, _h, buttonCorner);
        
        //TOP
        if (active) {
            stroke(EOSState);
        } else {
            stroke(EOSDarkGrey);
        }
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }
        rect(_x, _y, _w, _h, buttonCorner);

        fill(white);
        textAlign(CENTER, CENTER);
        textFont(fontSmall);

        try {
            text(_ID, _x, _y); //INPUT
            if (_ID2.equals("---")) {
                text(_ID2, _x + _w / 10, _y + _h / 1.2); //INPUT
            } else {
                text(_ID2, _x + _w / 10, _y + _h / 1.2); //INPUT
            }
        } catch (Exception e) {

        }

        textFont(fontTiny);

        if (this.clicked) {
            fill(black);
        } else {
            fill(100);
        }

        try {
            textAlign(LEFT, CENTER);
            String index = "INDEX: ";
            text(index, _x - _w / 2.2, _y + _h / 1.2); //INPUT
        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------IMAGE BUTTON - GOBO,BEAM,ANIMATION----------
//--------------------------------------------------------------

    void showImage(String _ID, String _ID2, String _ID3, float _x, float _y, float _w, float _h, boolean active) { //THREE TEXT
        this.x = _x;
        this.y = _y + _h / 1.8;
        this.w = _w;
        this.h = _h * 2.5;

        push();
        rectMode(CENTER);
        strokeWeight(buttonStrokeWeight);

        //BOTTOM
        if (active) {
            stroke(EOSState);
        } else {
            stroke(EOSDarkGrey);
        }
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y + _h / 0.75, _w, _h, buttonCorner);

        //MIDDLE
        if (active) {
            stroke(EOSState);
        } else {
            stroke(EOSDarkGrey);
        }
         if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }
        rect(_x, _y + _h / 1.5, _w, _h, buttonCorner);

        //TOP
        if (active) {
            stroke(EOSState);
        } else {
            stroke(EOSDarkGrey);
        }
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }
        rect(_x, _y, _w, _h, buttonCorner);

        fill(white);
        textAlign(CENTER, CENTER);
        textFont(fontSmall);
        try {
            text(_ID, _x, _y); //INPUT
            if (_ID2.equals("---")) {
                text(_ID2, _x + _w / 10, _y + _h / 1.25); //INPUT
                text(_ID3, _x + _w / 10, _y + _h * 1.5); //INPUT
            } else {
                text(_ID2, _x + _w / 10, _y + _h / 1.25); //INPUT
                text(_ID3, _x + _w / 10, _y + _h * 1.5); //INPUT
            }
        } catch (Exception e) {

        }

        textFont(fontTiny);
        if (this.clicked) {
            fill(black);
        } else {
            fill(100);
        }

        try {
            textAlign(LEFT, CENTER);
            String index = "INDEX: ";
            String speed = "IND/SPD: ";
            text(index, _x - _w / 2.2, _y + _h / 1.2); //INPUT
            text(speed, _x - _w / 2.2, _y + _h * 1.5); //INPUT
        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------INTENSITY----------
//--------------------------------------------------------------

    void showInt(String _ID, float _x, float _y, float _w, float _h) { //ONE TEXT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);

        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {
            pushStyle();
            textAlign(CENTER, CENTER);
            textFont(fontMedium);
            colorMode(HSB, 255, 255, 255, 255);

            color intensityColor = color(channelHue, channelSat, 100);
            fill(intensityColor);

            text(_ID, _x + textWidth(_ID) / 100, _y + (_h / 4) + smallTextSize / 25); //SHADOW

            intensityColor = color(channelHue, channelSat, 255);
            fill(intensityColor);

            text(_ID, _x, _y + _h / 4); //INPUT

            popStyle();

        } catch (Exception e) {

        }
        pop();
    }

//--------------------------------------------------------------
// MARK: ----------DIRECT SELECT----------
//--------------------------------------------------------------

    void showDS(String _ID, String _ID2, float _x, float _y, float _w, float _h, color _color) { //DIRECT SELECT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(_color);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(RIGHT, BOTTOM);
            fill(white);
            textFont(fontTiny);

            text(_ID2, _x + (_w / 2.25), _y + (_h / 2.25)); //NUMBER

            textAlign(CENTER, CENTER);
            textFont(fontDS);

            int maxLineLength = 6;
            String dName = _ID;
            StringList dNames = new StringList();

            if (textWidth(dName) < w - buttonStrokeWeight / 2) {
                dNames.append(dName);
            } else {
                if (dName.indexOf(' ') != -1) { //IF NAME HAS A SPACE
                    int numSpaces = count(dName, ' ');
                    int letterCount = 0;
                    int indexValueEnd = dName.indexOf(" ");

                    while (numSpaces > 0) {
                        indexValueEnd = dName.indexOf(" ");
                        letterCount += dName.length();
                        dNames.append(dName.substring(0, indexValueEnd));
                        dName = dName.substring(indexValueEnd + 1);
                        if (textWidth(dName) < w - buttonStrokeWeight / 2) {
                            dNames.append(dName);
                            numSpaces -= count(dName, ' ');
                        }
                        numSpaces--;
                    }
                } else { //IF NAME DOES NOT HAVE SPACE IN IT
                    dNames.append(dName.substring(0, maxLineLength));
                }
            }

            if (dNames.size() == 1) {
                text(dNames.get(0), _x, _y); //NAME
            } else if (dNames.size() == 2) {
                text(dNames.get(0), _x, _y - dsTextSize / 2); //NAME
                text(dNames.get(1), _x, _y + dsTextSize / 2); //NAME
            } else if (dNames.size() == 3) {
                text(dNames.get(0), _x, _y - dsTextSize); //NAME
                text(dNames.get(1), _x, _y); //NAME
                text(dNames.get(2), _x, _y + dsTextSize); //NAME
            } else if (dNames.size() > 3) {
                push();
                translate(0, - dsTextSize / 2);
                text(dNames.get(0), _x, _y - dsTextSize * 1.5); //NAME
                text(dNames.get(1), _x, _y - dsTextSize / 2); //NAME
                text(dNames.get(2), _x, _y + dsTextSize / 2); //NAME
                text(dNames.get(3), _x, _y + dsTextSize * 1.5); //NAME
                pop();
            }

        } catch (Exception e) {

        }

        pop();
    }
//------------------------PROCESSING ONLY-----------------------------
    int count(String string, char search) {
        int count = 0;
        int startIndex = 0;
        while (string.indexOf(search, startIndex) != -1) { //COUNT NUMBER OF SPACES
            startIndex = string.indexOf(search, startIndex) + 1;
            count += 1;
        }
        return count;
    }


//--------------------------------------------------------------
// MARK: ----------EVENTS----------
//--------------------------------------------------------------

    void touchDown() {
        if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
            this.clicked = true;
            this.action = true;
        }
    }

    //--------------------------------------------------------------
    void touchDown(boolean toggle) { //TOGGLE
        if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
            if (toggle) {
                this.clicked = !clicked;
            } else {
                this.clicked = true;
            }
            this.action = true;
        }
    }

//--------------------------------------------------------------
    void touchUp() {
        if (clicked) {
            this.released = true;
        }
        this.clicked = false;
        this.doubleClicked = false;
    }

//--------------------------------------------------------------
    void touchDoubleTap() {
        this.doubleClicked = true;
    }
//--------------------------------------------------------------




}