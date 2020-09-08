class DirectSelect {
	String ID, n;
	int index;
	float x, y, w, h, t;
	color c;
	boolean clicked, toggle, toggled, released, action, doubleClicked, latch, held = false;

	float releaseDelay;

	DirectSelect(int tempIndex) {
		this.index = tempIndex;
	}

	void show(String ID, String number, float xPos, float yPos, float xSize, float ySize, float textSize, color Color) { //DIRECT SELECT WITH COLOR
		this.ID = ID;
		this.n = number;
		this.x = xPos;
		this.y = yPos;
		this.w = xSize;
		this.h = ySize;
		this.t = textSize;
		this.c = Color;
		buttonShow();
		buttonText();

		if (this.releaseDelay + 100 < millis()) {
			this.released = false;
		}
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

	void buttonText() {
		push();
		textSize(this.t);
		textLeading(this.t * 1.25);
		textAlign(CENTER, CENTER);
		fill(white);
		text(this.ID, this.x, this.y);

		textAlign(RIGHT, BOTTOM);
		textSize(this.t / 1.5);
		if (this.n != null) {
			if (this.n.length() > 0) {
				text("(" + this.n + ")", this.x + this.w / 2.25, this.y + this.h / 2.25);
			}
		}
		pop();
	}

	void buttonClicked() {
		if (mouseX > this.x - this.w / 2 && mouseX < this.x + this.w / 2 && mouseY > this.y - this.h / 2 && mouseY < this.y + this.h / 2) {
			this.action = true;
			this.clicked = true;
		}
	}

	void buttonReleased() {
		if (this.clicked) {
			this.releaseDelay = millis();
			this.clicked = false;
			this.doubleClicked = false;
			this.released = true;
			this.held = false;
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

	void mouseHeld() {
		if (this.clicked) {
			this.held = true;
			keyboard.open = true;
		}
	}
}