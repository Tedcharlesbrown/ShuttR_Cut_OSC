//--------------------------------------------------------------
// B_topbar.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- TOP BAR - UPDATE / DRAW ----------
//--------------------------------------------------------------

void topBarUpdate() {
	if (shutterPage.action && shutterPage.clicked) {
		shutterPage.clicked = true; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = false; dSelectPage.clicked = false;
		shutterPage.action = false;
		settingsMenu = false;
	} else if (focusPage.action && focusPage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = true; formPage.clicked = false; imagePage.clicked = false;  dSelectPage.clicked = false;
		focusPage.action = false;
		settingsMenu = false;
	} else if (formPage.action && formPage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = true; imagePage.clicked = false;  dSelectPage.clicked = false;
		formPage.action = false;
		settingsMenu = false;
	} else if (imagePage.action && imagePage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = true;  dSelectPage.clicked = false;
		imagePage.action = false;
		settingsMenu = false;
	} else if (dSelectPage.action && dSelectPage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = false;  dSelectPage.clicked = true;
		dSelectPage.action = false;
		settingsMenu = false;
	}
}

void topBarDraw() {
	statusBarDraw();
	settingsBar(0, notchHeight, width, settingsBarHeight, settingsBarStrokeWeight);
	settingsButton(width - settingsBarHeight - buttonStrokeWeight / 2, notchHeight, settingsBarHeight, settingsBarHeight, buttonStrokeWeight); //X adjust
	oscLight("TX", lightWidth / 2, notchHeight + settingsBarStrokeWeight, lightWidth, settingsBarHeight / 2 - settingsBarStrokeWeight, buttonStrokeWeight);
	oscLight("RX", lightWidth / 2, notchHeight + settingsBarStrokeWeight + settingsBarHeight / 2 - settingsBarStrokeWeight, lightWidth, settingsBarHeight / 2 - settingsBarStrokeWeight, buttonStrokeWeight);
}

//--------------------------------------------------------------
// MARK: ---------- SETTINGS - BAR / BUTTON / LIGHT ----------
//--------------------------------------------------------------

void settingsBar(float _x, float _y, float _w, float _h, float _weight) {
	push();
	fill(EOSBarState);
	noStroke();
	rect(_x, _y - buttonStrokeWeight / 2, _w, _h + buttonStrokeWeight); //Settings Bar Background - Adjusts for Processing

	stroke(shutterOutsideStroke);
	strokeWeight(_weight);
	line(_x, notchHeight, _w, notchHeight); //TOP BAR
	line(_x, _h + notchHeight, _w, _h + notchHeight); //BOTTOM BAR

	pop();

	shutterPage.showPage("SHUTTER", centerX - (smallButtonWidth / 1.1) * 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
	focusPage.showPage("FOCUS", centerX - smallButtonWidth / 1.1, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
	formPage.showPage("FORM", centerX, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
	imagePage.showPage("IMAGE", centerX + smallButtonWidth / 1.1, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);
	dSelectPage.showPage("DS", centerX + (smallButtonWidth / 1.1) * 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1, settingsBarHeight);

}

//--------------------------------------------------------------

void settingsButton(float _x, float _y, float _w, float _h, float _weight) {
	this.settingsX = _x;
	this.settingsY = _y;
	this.settingsWidth = _w;
	this.settingsHeight = _h + notchHeight;
	push();
	rectMode(CENTER);

	stroke(shutterOutsideStroke); //stroke
	if (settingsMenu) {
		fill(white); //fill
	} else {
		fill(black); //fill
	}
	strokeWeight(_weight);
	rect(_x + _w / 2, _y + _h / 2, _w, _h, buttonCorner); //outer

	fill(shutterOutsideStroke);
	circle(_x + _w / 2, _y + _h / 2, (_w / 5) * 2); //circle

	pop();
}

//--------------------------------------------------------------

void oscLight(String _ID, float _x, float _y, float _w, float _h, float _weight) {
	push();
	rectMode(CENTER);
	_y = _y + _h / 2;
	if (_ID == "TX") {
		stroke(black); //stroke
		strokeWeight(_weight);
		if (oscSendLight) {
			fill(EOSLightGreen); //fill
		} else {
			fill(EOSGreen); //fill
		}
		rect(_x, _y, _w, _h, buttonCorner / 2); //outer
	} else if (_ID == "RX") {
		stroke(black); //stroke
		strokeWeight(_weight);
		if (oscReceiveLight) {
			fill(EOSLightRed); //fill
		} else {
			fill(EOSRed); //fill
		}
		rect(_x, _y, _w, _h, buttonCorner / 2); //outer
	}
	pop();
}

//--------------------------------------------------------------
// MARK: ---------- STATUS BAR DRAW ----------
//--------------------------------------------------------------

void statusBarDraw() {
	push();
	String amPM = "AM";
	if (hour() > 11) {
		amPM = "PM";
	}
	String hour = str(hour() % 12);
	if (hour.equals("0")) {
		hour = "12";
	}
	String minutes = str(minute());
	if (minute() < 10) {
		minutes = "0" + minutes;
	}
	String time = hour + ":" + minutes + " " + amPM;
	String time24 = str(hour()) + ":" + minutes;

	textAlign(CENTER, CENTER);
	textFont(fontSmall);
	fill(white);

	text(time, width - textWidth(time) / 1.5, notchHeight / 2); //TIME

	text(headerName, width / 2, notchHeight / 2);

//    string WIFI = "ShuttR" + version;
//    fontSmall.drawString(WIFI,10, notchHeight - fontSmall.stringHeight("WIFI") / 2); //APP NAME

	pop();
}