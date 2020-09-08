class angleSlider {
  float position = 1; // The position of the slider between 0 and 1
  String ID;
  float rotateAngle;

  angleSlider(String tempID) {
    this.ID = tempID;
  }

  void display() {
    displayButton();
    displayText();
  }

  void displayButton() {
    stroke(angleStroke);
    strokeWeight(angleWeight);
    fill(angleFill);
    circle(0, 0, clickDiameter);
  }

  void displayText() {
    rotate(-rotation);
    fill(angleText);
    textSize(clickRadius);
    textAlign(CENTER, CENTER);
    text(this.ID, -1, -3);
  }

  void displayFrame() {
    pushMatrix();
    strokeWeight(shutterStrokeWeight);
    stroke(frameStroke);
    fill(frameFill);
    rectMode(CENTER);
    switch (this.ID) {
    case "A":
      translate(0, - assemblyDiameter - assemblyRadius / 2);
      rect(0, assemblyRadius * thrustA.thrustSliderA.outputBinary(), assemblyDiameter, assemblyRadius);
      this.rotateAngle = -degrees(angleA.rotateAngle);
      break;
    case "B":
      translate(assemblyDiameter + assemblyRadius / 2, 0);
      rect(-assemblyRadius * thrustB.thrustSliderB.outputBinary(), 0, assemblyRadius, assemblyDiameter);
      this.rotateAngle = -degrees(angleB.rotateAngle);
      break;
    case "C":
      translate(0, assemblyDiameter + assemblyRadius / 2);
      rect(0, -assemblyRadius * thrustC.thrustSliderC.outputBinary(), assemblyDiameter, assemblyRadius);
      this.rotateAngle = -degrees(angleC.rotateAngle);
      break;
    case "D":
      translate(- assemblyDiameter - assemblyRadius / 2, 0);
      rect(assemblyRadius * thrustD.thrustSliderD.outputBinary(), 0, assemblyRadius, assemblyDiameter);
      this.rotateAngle = -degrees(angleD.rotateAngle);
      break;
    default:
      break;
    }
    popMatrix();
  }
}