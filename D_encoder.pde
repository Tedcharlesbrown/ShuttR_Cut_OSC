//--------------------------------------------------------------
// D_encoder.h && D_encoder.mm
//--------------------------------------------------------------

class ENCODER {
	PImage encoder;
	String parameter;
	float currentPos, lastPos = 0;
	float posX, posY;
	float newTick, oldTick;
	boolean clicked = false;
	PVector currentTouch, prevTouch, center;

	//--------------------------------------------------------------

	float encoderOutput = 0;
	boolean eventTrigger = false;

	void sendOSC() {
		eventTrigger = true;
	}

	//--------------------------------------------------------------

	void setup(float _size) {
		encoder = loadImage("Encoder.png");
		encoder.resize(int(_size), int(_size));
		currentTouch = new PVector(0, 0);
		prevTouch = new PVector(0, 0);
		center = new PVector(centerX, centerY);
	}

	//--------------------------------------------------------------
	void draw(float _x, float _y) {
		this.posX = _x;
		this.posY = _y;
		push();
		translate(posX, posY);
		rotate(currentPos + radians(90));
		image(encoder, - encoder.width / 2, - encoder.height / 2);
		pop();
	}

//--------------------------------------------------------------
// MARK: ----------ACTIONS----------
//--------------------------------------------------------------

	void touchDown() {
		if (dist(touch.x, touch.y, posX, posY) < encoder.width / 2) {
			this.clicked = true;
		}
	}

//--------------------------------------------------------------
	void touchMoved() {
		if (this.clicked) {
			currentTouch.x = touch.x; currentTouch.y = touch.y;
			prevTouch.x = ofGetPreviousMouseX(); prevTouch.y = ofGetPreviousMouseY();

			float angleOld = PVector.sub(prevTouch, center).heading();
			float angleNew = PVector.sub(currentTouch, center).heading();

			currentPos = angleNew; //ROTATE ENCODER

			float diff = angleNew - angleOld;

			if (diff > 1) {
				diff = 0;
			} else if (diff > PI) {
				diff = TWO_PI - diff;
			} else if (diff < -PI) {
				diff = TWO_PI + diff;
			}

			if (diff > 0) { //CLOCKWISE
				encoderOutput = 1;
			} else if (diff < 0) { //COUNTER-CLOCKWISE
				encoderOutput = -1;
			} else {
				encoderOutput = 0;
			}

			newTick += degrees(diff);

			int tickGate = 3;
			if (newTick > oldTick + tickGate || newTick < oldTick - tickGate) {
				oldTick = newTick;
				sendOSC();
			}
		}
	}

//--------------------------------------------------------------
	void touchUp() {
		this.clicked = false;
	}

//--------------------------------------------------------------
	void touchDoubleTap() {

	}


}