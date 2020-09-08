class thrustHandle {
  thrustSlider thrustSliderA; thrustSlider thrustSliderB; thrustSlider thrustSliderC; thrustSlider thrustSliderD;

  float offset, rotateOffset, sliderX, sliderY, defaultSliderX, defaultSliderY, diff;
  String ID;
  boolean clicked = false;

  thrustHandle(String tempID) {
    thrustSliderA = new thrustSlider("A"); thrustSliderB = new thrustSlider("B"); thrustSliderC = new thrustSlider("C"); thrustSliderD = new thrustSlider("D");

    this.ID = tempID; // Assign frame ID
    switch (this.ID) {
    case "A":
      rotateOffset = radians(-90);
      break;
    case "B":
      rotateOffset = radians(0);
      break;
    case "C":
      rotateOffset = radians(90);
      break;
    case "D":
      rotateOffset = radians(180);
      break;
    default:
      break;
    }
    this.defaultSliderX = centerX + cos(rotation + rotateOffset) * thrustDiameter;
    this.defaultSliderY = centerY + sin(rotation + rotateOffset) * thrustDiameter;
  }
  void display() {
    pushMatrix();
    switch (this.ID) {
    case "A":
      this.sliderX = centerX + cos(rotation + rotateOffset) * thrustSliderA.position * thrustDiameter;
      this.sliderY = centerY + sin(rotation + rotateOffset) * thrustSliderA.position * thrustDiameter;
      translate(0, -thrustSliderA.position * thrustDiameter);
      thrustSliderA.display(this.sliderX, this.sliderY);
      break;
    case "B":
      this.sliderX = centerX + cos(rotation + rotateOffset) * thrustSliderB.position * thrustDiameter;
      this.sliderY = centerY + sin(rotation + rotateOffset) * thrustSliderB.position * thrustDiameter;
      translate(thrustSliderB.position * thrustDiameter, 0);
      thrustSliderB.display(this.sliderX, this.sliderY);
      break;
    case "C":
      this.sliderX = centerX + cos(rotation + rotateOffset) * thrustSliderC.position * thrustDiameter;
      this.sliderY = centerY + sin(rotation + rotateOffset) * thrustSliderC.position * thrustDiameter;
      translate(0, thrustSliderC.position * thrustDiameter);
      thrustSliderC.display(this.sliderX, this.sliderY);
      break;
    case "D":
      this.sliderX = centerX + cos(rotation + rotateOffset) * thrustSliderD.position * thrustDiameter;
      this.sliderY = centerY + sin(rotation + rotateOffset) * thrustSliderD.position * thrustDiameter;
      translate(-thrustSliderD.position * thrustDiameter, 0);
      thrustSliderD.display(this.sliderX, this.sliderY);
      break;
    default:
      break;
    }
    popMatrix();
  }

  void mousePressed() {
    if (dist(mouseX, mouseY, this.sliderX, this.sliderY) < clickRadius) {
      this.clicked = true;
    }
  }

  void mouseReleased() {
    this.clicked = false;
    thrustSliderA.clicked = false; thrustSliderB.clicked = false; thrustSliderC.clicked = false; thrustSliderD.clicked = false;
  }

  void mouseDragged() {
    if (gui.fineClicked) {
      this.diff = ((cos(rotation + rotateOffset) * (mouseX - pmouseX) + sin(rotation + rotateOffset) * (mouseY - pmouseY)) / 5);
    } else {
      this.diff = ((cos(rotation + rotateOffset) * (mouseX - pmouseX) + sin(rotation + rotateOffset) * (mouseY - pmouseY)) / 1.5);
    }
    if (this.clicked) {
      switch (this.ID) {
      case "A":
        thrustSliderA.addOffset(map(this.diff, 0, thrustDiameter, 0, 1));
        break;
      case "B":
        thrustSliderB.addOffset(map(this.diff, 0, thrustDiameter, 0, 1));
        break;
      case "C":
        thrustSliderC.addOffset(map(this.diff, 0, thrustDiameter, 0, 1));
        break;
      case "D":
        thrustSliderD.addOffset(map(this.diff, 0, thrustDiameter, 0, 1));
        break;
      default:
        break;
      }
    }
  }
}