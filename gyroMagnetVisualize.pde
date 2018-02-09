/*
概要
・センサの値を視覚化したアプリ
・色：ジャイロセンサ、位置：磁気センサ
問題点
・磁石検知判定の閾値調整ができておらず、一周で数回検知してしまう
*/

int n=0;
int dir=1;
boolean flag=true;
int r=0, g=0, b=0;
float R=0, G=0, B=0;
//センサ
import ketai.sensors.*;
KetaiSensor sensor;
PVector gyroscope,magneticField;
void onGyroscopeEvent(float x, float y, float z) {
  gyroscope.set(x, y, z);
}
void onMagneticFieldEvent(float x, float y, float z, long time, int accuracy){
  magneticField.set(x, y, z);
}
float preX, preY, preZ;

void setup(){
  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);
  textSize(18);
  textAlign(CENTER);
  frameRate(60);
  //センサ
  sensor = new KetaiSensor(this);
  sensor.start();
  magneticField = new PVector();
}

void draw(){
  background(0);
  noStroke();
  translate(width/2+35,height/2);
  colortable();
  
  led(n);
  if(flag==true){
    if((magneticField.x-preX>=50)||(magneticField.y-preY<=-50)||(magneticField.z-preZ>=50)){ 
      n+=dir;
      flag=false;
      if(n==4&&dir==1)
        dir=-1;
      if(n==0&&dir==-1)
        dir=1;
    }
  }
  preX=magneticField.x;
  preY=magneticField.y;
  preZ=magneticField.z;
  if((magneticField.x<=-10)||(magneticField.y>=10)||(magneticField.z<=-10)){
    flag=true;
  }
}

void led(int n) {
  pushMatrix();
  fill(r,g,b);
  rect(-32.5-65*n, -32.5, 65, 65);
  rotate(PI);
  fill(r,g,b);
  rect(-32.5-65*n, -32.5, 65, 65);
  popMatrix();
}

void colortable(){//ジャイロ閾値別色
  if(gyroscope.z*180/PI>=0){
    B=(gyroscope.z*180/PI)/3.893;
    R=255-B;
  }else{
    B=(-gyroscope.z*180/PI)/3.893;
    R=255-B;
  }
  r=(int)R;
  b=(int)B;
}