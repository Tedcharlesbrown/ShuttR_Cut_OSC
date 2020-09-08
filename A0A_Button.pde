class Button {
	String ID, ID2;
	float x, y, w, h, t;
	color c;
	boolean clicked, toggle, toggled, released, action, doubleClicked, latch = false;

	Button(boolean toggleTemp, boolean latchTemp) {
		this.toggle = toggleTemp;
		this.latch = latchTemp;
	}

	void show(String ID, float xPos, float yPos, float xSize, float ySize, float textSize) { //GENERIC BUTTON
		this.ID = ID;
		this.x = xPos;
		this.y = yPos;
		this.w = xSize;
		this.h = ySize;
		this.t = textSize;
		this.c = liveBlindState;
		buttonShow();
		buttonText();
	}

	void show(String ID, String ID2, float xPos, float yPos, float xSize, float ySize, float textSize) { //BUTTON WITH SECOND ROW OF TEXT
		this.ID = ID;
		this.ID2 = ID2;
		this.x = xPos;
		this.y = yPos;
		this.w = xSize;
		this.h = ySize;
		this.t = textSize;
		this.c = liveBlindState;
		buttonShow();
		buttonDoubleText();
	}

	void show(String ID, float xPos, float yPos, float xSize, float ySize, float textSize, boolean readout) { //WITH READOUT
		this.ID = ID;
		this.x = xPos;
		this.y = yPos;
		this.w = xSize;
		this.h = ySize;
		this.t = textSize;
		this.c = liveBlindState;
		buttonReadoutShow();
		buttonText();
		//buttonReadoutText();
	}

	void show(String ID, float xPos, float yPos, float xSize, float ySize, float textSize, color colour) { //GENERIC BUTTON
		this.ID = ID;
		this.x = xPos;
		this.y = yPos;
		this.w = xSize;
		this.h = ySize;
		this.t = textSize;
		this.c = colour;
		buttonShow();
		buttonText();
	}

	void show(String ID, String ID2, float xPos, float yPos, float xSize, float ySize, float textSize, color colour) { //BUTTON WITH SECOND ROW OF TEXT
		this.ID = ID;
		this.ID2 = ID2;
		this.x = xPos;
		this.y = yPos;
		this.w = xSize;
		this.h = ySize;
		this.t = textSize;
		this.c = colour;
		buttonShow();
		buttonDoubleText();
	}

	

	void buttonShow() {
		push();
		if (this.clicked) {
			fill(buttonActive);
		} else {
			fill(black);
		}
		stroke(this.c);
		strokeWeight(buttonStrokeWeight);
		rectMode(CENTER);
		rect(this.x, this.y, this.w, this.h, buttonCorner);
		pop();
	}

	void buttonReadoutShow() {
		push();
		if (this.clicked) {
			fill(buttonActive);
		} else {
			fill(black);
		}
		stroke(this.c);
		strokeWeight(buttonStrokeWeight);
		rectMode(CENTER);
		rect(this.x, this.y + this.h / 2, this.w, this.h, buttonCorner);
		rect(this.x, this.y, this.w, this.h, buttonCorner);
		pop();
	}

	void buttonText() {
		push();
		textSize(this.t);
		textAlign(CENTER, CENTER);
		fill(white);
		text(this.ID, this.x, this.y);
		pop();
	}

	void buttonDoubleText() {
		push();
		textAlign(CENTER, CENTER);
		fill(white);
		textSize(this.t);
		text(this.ID, this.x, this.y - (this.t / 2));
		textSize(smallTextSize);
		text(this.ID2, this.x, this.y + (this.t / 2));
		pop();
	}

	void readoutText(String percent) {
		push();
		textSize(smallTextSize);
		textAlign(CENTER, CENTER);
		fill(white);
		if (percent != null) {
			text(percent, this.x, this.y + (smallTextSize / 1.25) + (this.h / 2));
		}
		pop();
	}

	void buttonClicked() {
		if (mouseX > this.x - this.w / 2 && mouseX < this.x + this.w / 2 && mouseY > this.y - this.h / 2 && mouseY < this.y + this.h / 2) {
			if (this.toggle && this.latch) {
				this.toggled = true;
				this.action = true;
				this.clicked = true;
			} else if (this.toggle && !this.latch) {
				this.toggled = true;
				this.action = true;
				this.clicked = !this.clicked;
			} else {
				this.clicked = true;
				this.action = true;
			}
		}
	}

	void buttonReleased() {
		if (!this.toggle) {
			if (this.clicked) {
				this.released = true;
			}
			this.clicked = false;
			this.doubleClicked = false;
		}
	}


	void mousePressed() {
		buttonClicked();
	}

	void mouseReleased() {
		buttonReleased();
	}

	void mouseDragged() {

	}

	void doubleClicked() {
		if (mouseX > this.x - this.w / 2 && mouseX < this.x + this.w / 2 && mouseY > this.y - this.h / 2 && mouseY < this.y + this.h / 2) {
			this.doubleClicked = true;
		}
	}
}