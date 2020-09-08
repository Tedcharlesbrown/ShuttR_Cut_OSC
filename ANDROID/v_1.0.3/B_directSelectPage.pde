//--------------------------------------------------------------
// B_directSelectPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- DIRECT SELECT - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void DSPageSetup() {
	bankOne.setup(1); bankTwo.setup(2);
}

//--------------------------------------------------------------
void DSPageUpdate() {
	bankOne.update(); bankTwo.update();
}

//--------------------------------------------------------------
void DSPageDraw() {
	bankOne.draw(row1Padding);
	bankTwo.draw(row1Padding + notchHeight / 2 + bankTwo.bankHeight); // notchHeight / 2

	if (bankOne.quickButton.clicked) {
		bankOne.quickSelectsShow();
	}
	if (bankTwo.quickButton.clicked) {
		bankTwo.quickSelectsShow();
	}
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void DSPageTouchDown() {
	bankOne.touchDown(); bankTwo.touchDown();
}

//--------------------------------------------------------------
void DSPageTouchMoved() {

}

//--------------------------------------------------------------
void DSPageTouchUp() {
	bankOne.touchUp(); bankTwo.touchUp();
}

//--------------------------------------------------------------
void DSPageDoubleTap() {

}

//--------------------------------------------------------------

void parseDirectSelectSend() {
	PVector dSelect = new PVector(0, 0, 0);
	boolean dFlexi = false;
	//X = BANK
	//Y = PARAMETER
	//Z = BUTTON
	//dSelectFlexi = FLEXI
	if (bankOne.vectorEventTrigger || bankTwo.vectorEventTrigger) {
		if (bankOne.vectorEventTrigger) {
			dSelect = bankOne.dSelectVector;
			dFlexi = bankOne.dSelectFlexi;
		} else {
			dSelect = bankTwo.dSelectVector;
			dFlexi = bankTwo.dSelectFlexi;
		}

		String directParameter = "";

		if (dSelect.y != 0 && dSelect.z == 0) { //QUICK SELECT
			int switchCase = int(dSelect.y);
			switch (switchCase) {
			case 1:
				directParameter = "chan"; break;
			case 2:
				directParameter = "group"; break;
			case 3:
				directParameter = "ip"; break;
			case 4:
				directParameter = "fp"; break;
			case 5:
				directParameter = "cp"; break;
			case 6:
				directParameter = "bp"; break;
			case 7:
				directParameter = "preset"; break;
			case 8:
				directParameter = "macro"; break;
			case 9:
				directParameter = "fx"; break;
			case 10:
				directParameter = "snap"; break;
			case 11:
				directParameter = "ms"; break;
			case 12:
				directParameter = "scene"; break;
			case 13:
				break;
			}

			if (dFlexi) {
				directParameter += "/flexi";
			}

			sendDSRequest(str(dSelect.x), directParameter);

		} else if (dSelect.y == 0 && dSelect.z != 0) {//DIRECT SELECT BUTTON

			sendDS(str(dSelect.x), str(dSelect.z));

		}
		bankOne.vectorEventTrigger = false;
		bankTwo.vectorEventTrigger = false;
	}
}
//--------------------------------------------------------------

void parseDirectSelectPage() {

	PVector dSelect = new PVector(0, 0);
	if (bankOne.pageEventTrigger || bankTwo.pageEventTrigger) {
		if (bankOne.pageEventTrigger) {
			dSelect = bankOne.dSelectPage;
		} else {
			dSelect = bankTwo.dSelectPage;
		}
		sendDSPage(str(dSelect.x), str(dSelect.y));
		bankOne.pageEventTrigger = false;
		bankTwo.pageEventTrigger = false;
	}
}
