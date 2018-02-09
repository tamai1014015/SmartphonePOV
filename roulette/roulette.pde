import ketai.ui.*;
import ketai.sensors.*;
KetaiSensor sensor;
float preX, preY, preZ;
PVector gyroscope,magneticField;
int i=0;
int state=0;
boolean spinning = false;
boolean spun = false;
int resultNum;
int a=0,d=0;
boolean flag=true;
//int r=0,g=0,b=0;
int r=255,g=255,b=255;
void onGyroscopeEvent(float x, float y, float z) {
  gyroscope.set(x, y, z);
}
void onMagneticFieldEvent(float x, float y, float z, long time, int accuracy) {
  magneticField.set(x, y, z);
}

void setup() {
  sensor = new KetaiSensor(this);
  sensor.start();
  gyroscope = new PVector();
  magneticField = new PVector();
  orientation(LANDSCAPE);
  size(displayWidth, displayHeight);
  textSize(28);
  textAlign(CENTER);
  frameRate(60);
  resultNum=randomInt();
}

void draw() {
  translate(width/2+35, height/2);
  transition();
  switch(state) {
  case 0:
    background(0);
    disk();
    sentenceFirst();
    arrow();
    break;
  case 1:
    background(0);
    diskPOV();
    //sentenceFirst();
    arrowPOV();
    break;
  case 2:
    background(0);
    disk();
    sentenceLast();
    arrow();
    break;
  }
}

void transition() {
  if (gyroscope.z*180/PI>=360||gyroscope.z*180/PI<=-360) {
    spinning=true;
    spun=true;
  } else {
    spinning=false;
  }
  if (spinning==true) {
    state=1;
  } else {
    if (spun==false) {
      state=0;
    } else {
      state=2;
    }
  }
}

void mousePressed() {
  spun = false;
  state=0;
  resultNum=randomInt();
}

int randomInt() {
  if (0<=random(4)&&random(4)<1)
    return 0;
  else if (1<=random(4)&&random(4)<2)
    return 1;
  else if (2<=random(4)&&random(4)<3)
    return 2;
  else
    return 3;
}

void arrowPOV() {
  switch(a) {
  case 0:
    a++;
    break;
  case 1:
    fill(r, g, b);
    noStroke();
    rect(-(width/2+35)+70, -5, 40, 10);
    a++;
    break;
  case 2:
    fill(r, g, b);
    noStroke();
    rect(-(width/2+35)+70, -5, 80, 10);
    a++;
    break;
  case 3:
    fill(r, g, b);
    noStroke();
    rect(-(width/2+35)+70, -5, 120, 10);
    a++;
    break;
  case 4:
    fill(r, g, b);
    noStroke();
    rect(-(width/2+35)+70, -5, 80, 10);
    a++;
    break;
  case 5:
    fill(r, g, b);
    noStroke();
    rect(-(width/2+35)+70, -5, 40, 10);
    a++;
    break;
  case 6:
    a++;
    break;
  case 7:
    a++;
    break;
  case 8:
    a++;
    break;
  case 9:
    a=0;
    break;
  }
  /*
  if (flag==true) {
    if ((magneticField.x-preX>=50)||(magneticField.y-preY<=-50)||(magneticField.z-preZ>=50)) {
      y=1;
      r=255;
      g=255;
      b=255;
      flag=false;
    }
  }
  preX=magneticField.x;
  preY=magneticField.y;
  preZ=magneticField.z;
  if ((magneticField.x<=-10)||(magneticField.y>=10)||(magneticField.z<=-10)) {
    flag=true;
    r=0;
    g=0;
    b=0;
  }
  */
}

void diskPOV(){
  switch(d) {
  case 0:
    fill(0);
    noStroke();
    rect(125, -5, 100, 10);
    d++;
    break;
  case 1:
    fill(255,60,60);
    noStroke();
    rect(125, -5, 100, 10);
    d=0;
    break;
  }
}

void sentenceFirst() {
  pushMatrix();
  fill(0);
  text('B', 0, -165);
  rotate(PI/2);
  text('C', 0, -165);
  rotate(PI/2);
  text('D', 0, -165);
  rotate(PI/2);
  text('A', 0, -165);
  fill(255, 90, 90);
  text("スマホを回してルーレット開始", 0, -width/2);
  popMatrix();
}

void sentenceLast() {
  if (resultNum==0) {
    pushMatrix();
    fill(0);
    text('A', 0, -165);
    rotate(PI/2);
    text('B', 0, -165);
    rotate(PI/2);
    text('C', 0, -165);
    rotate(PI/2);
    text('D', 0, -165);
    fill(255, 90, 90);
    text("画面をタップして最初から", 0, -width/2);
    text('D', 0, 0);
    popMatrix();
  } else if (resultNum==1) {
    pushMatrix();
    fill(0);
    text('B', 0, -165);
    rotate(PI/2);
    text('C', 0, -165);
    rotate(PI/2);
    text('D', 0, -165);
    rotate(PI/2);
    text('A', 0, -165);
    fill(255, 90, 90);
    text("画面をタップして最初から", 0, -width/2);
    text('A', 0, 0);
    popMatrix();
  } else if (resultNum==2) {
    pushMatrix();
    fill(0);
    text('C', 0, -165);
    rotate(PI/2);
    text('D', 0, -165);
    rotate(PI/2);
    text('A', 0, -165);
    rotate(PI/2);
    text('B', 0, -165);
    fill(255, 90, 90);
    text("画面をタップして最初から", 0, -width/2);
    text('B', 0, 0);
    popMatrix();
  } else {
    pushMatrix();
    fill(0);
    text('D', 0, -165);
    rotate(PI/2);
    text('A', 0, -165);
    rotate(PI/2);
    text('B', 0, -165);
    rotate(PI/2);
    text('C', 0, -165);
    fill(255, 90, 90);
    text("画面をタップして最初から", 0, -width/2);
    text('C', 0, 0);
    popMatrix();
  }
}

void arrow() {
  noStroke();
  fill(128);
  triangle(-(width/2+35)+70, -60, -(width/2+35)+70, 60, -(width/2+35)+190, 0);
}

void disk() {
  noStroke();
  fill(128);
  ellipse(0, 0, 450, 450);//max470
  fill(0);
  ellipse(0, 0, 250, 250);
  fill(255,0,0);
  stroke(0);
  strokeWeight(5);
  line(450, 450, -450, -450);
  line(450, -450, -450, 450);
  /*//test
  fill(255,60,60);
  noStroke();
  rect(125, -5, 100, 10);*/
}