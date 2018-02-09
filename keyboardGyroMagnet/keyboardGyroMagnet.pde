import ketai.ui.*;//ketaiのキーボードやポップアップを使うときに記す。ナビバー隠しと相性悪し

import ketai.sensors.*;//センサ。ジャイロ用

//char配列にキーボードで打ち込んだ文字が入る。data[i]。表示用にStringに変換
char[] data = new char[10];
int i=0;
String sentence = " ";
int state=0;//画面の状態。0→キーボード画面、1→残像画面
int n=0;//何文字目 0～splitData.length-1
int c=0;//何列目 0～3
//ビットマップフォントを二次元配列で表現。縦5列、空白込みで横4列
int[][] error = {{0, 0, 0, 0},{0, 0, 0, 0},{1, 1, 1, 0},{0, 0, 0, 0},{0, 0, 0, 0}};
int[][] zero = {{1, 1, 1, 0},{1, 0, 1, 0},{1, 0, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0}};
int[][] one = {{0, 0, 1, 0},{0, 0, 1, 0},{0, 0, 1, 0},{0, 0, 1, 0},{0, 0, 1, 0}};
int[][] two = {{1, 1, 1, 0},{0, 0, 1, 0},{1, 1, 1, 0},{1, 0, 0, 0},{1, 1, 1, 0}};
int[][] three = {{1, 1, 1, 0},{0, 0, 1, 0},{1, 1, 1, 0},{0, 0, 1, 0},{1, 1, 1, 0}};
int[][] four = {{1, 0, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0},{0, 0, 1, 0},{0, 0, 1, 0}};
int[][] five = {{1, 1, 1, 0},{1, 0, 0, 0},{1, 1, 1, 0},{0, 0, 1, 0},{1, 1, 1, 0}};
int[][] six = {{1, 1, 1, 0},{1, 0, 0, 0},{1, 1, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0}};
int[][] seven = {{1, 1, 1, 0},{0, 0, 1, 0},{0, 0, 1, 0},{0, 0, 1, 0},{0, 0, 1, 0}};
int[][] eight = {{1, 1, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0}};
int[][] nine = {{1, 1, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0},{0, 0, 1, 0},{1, 1, 1, 0}};
//ジャイロ
KetaiSensor sensor;
float rotationX, rotationY, rotationZ;
float preX, preY, preZ;
int r=0, g=0, b=0;
float R=0, G=0, B=0;
PVector magneticField;

//セットアップ。文字の大きさなど。
void setup(){
  orientation(LANDSCAPE);//画面の配置に関係する？　(PORTRAIT)とかもある
  size(displayWidth, displayHeight);
  textSize(18);
  textAlign(CENTER);
  frameRate(60);
  //センサ
  sensor = new KetaiSensor(this);
  sensor.start();
  magneticField = new PVector();
}

//ドロー。ステータスで画面遷移
void draw(){
  switch(state){
    case 0://キーボード
      background(255);
      drawUI();
      fill(0);
      text(sentence, width/2, height/2-60);
    break;
    case 1://残像
      background(0);
      drawUI2();
      noStroke();
      translate(width/2+35,height/2);
      array();
      //colortable();
      //gyrovalueAndColorbar();
    break;
  }
}

//どこをタップしたらどうなるか。画面の状態で挙動を分けている
void mousePressed(){
  if(mouseY < 100){
    if(mouseX < width/3)
      if(state==0){
        KetaiKeyboard.toggle(this);
      }else{
        //else 
      }
    else if(width/3 < mouseX && mouseX < width-(width/3)){
      if(state==0){
        state=1;//残像画面に移行
      }else{
        state=0;//キーボード画面に移行
      }
    }else{
      if(state==0){
        for(int i=0; i<data.length; i++){
          data[i] = '\0';
        }
        i=0;
        sentence="\0";
      }else{
        //else
      }
    }
  }
}

//キーボード画面
void drawUI(){
  textAlign(LEFT);
  fill(0);
  stroke(255);
  rect(0, 0, width/3, 100);
  rect(width/3, 0, width/3, 100);
  rect((width/3)*2, 0, width/3, 100);
  fill(255);
  text("キーボード(オン/オフ)", 10, 60);//keyboard
  text("残像", width/3 + 10, 60);//popup 
  text("テキストリセット", width/3*2 + 10, 60);//reset 
}

//残像画面
void drawUI2(){
  textAlign(LEFT);
  fill(0);
  stroke(51);
  rect(width/3, 0, width/3, 100);
  fill(51);
  text("キーボード", width/3 + 10, 60);//popup 
}

//キーボードで打ち込んだ文字列の表示
public void keyPressed(){  
  data[i] = key;
  sentence = sentence + data[i];
  i++;
}

/*
各メソッド説明
led(int n)…第一アレイのn行目を表示。rotate()で座標を回転して分身→複数表示。
bitmapColumn(int[][] t, int c)…ビットマップのc列目において、行が「1」なら描画。
bitmap(char[] c, int n)…テキストのn番目の文字が'1'ならone(自作したビットマップ)を返す。
array…bitmapColumn(bitmap(data, b), c)
       dataのb文字目に対応した自作ビットマップのc列目において、行が「1」なら描画。
       c列目!=文字の最後の列→次の列へ
       c列目==文字の最後の列→
       　今の文字!=最後…　次の文字の最初の列へ
       　今の文字==最後…最初の文字の最初の列へ
*/

void led(int n) {
  /*if(magneticField.x<=-50){
    fill(255,0,0);
  }else{
    fill(0,0,255);
  }
  ellipse(0,0,100,100);
  //中央位置合わせ用赤点*/
  
  //pushMatrix();
  fill(255);
  rect(60-width/2+50*n, -5, 50, 10);
  /*for(int i=0; i<1; i++){
    rotate(PI);
    fill(255);
    rect(60-width/2+50*n, -5, 50, 10);
  }
  popMatrix();*/
}

void bitmapColumn(int[][] t, int c){
  for(int r=0; r<5; r++){
      if(t[r][c]==1) led(r);
  }
}

int[][] bitmap(char[] c,int n){
  if(c[n]=='0') return zero;
  else if(c[n]=='1') return one;
  else if(c[n]=='2') return two;
  else if(c[n]=='3') return three;
  else if(c[n]=='4') return four;
  else if(c[n]=='5') return five;
  else if(c[n]=='6') return six;
  else if(c[n]=='7') return seven;
  else if(c[n]=='8') return eight;
  else if(c[n]=='9') return nine;
  else return error;
}

void array(){
  bitmapColumn(bitmap(data, n), c);
  if(c==3){
    c=0;
    if(data[n+1]=='\0')
      n=0;
    else
      n++;
  }else{
    c++;
  }
  if((magneticField.x-preX>=50)||(magneticField.y-preY<=-50)||(magneticField.z-preZ>=50)){
    n=0;
    c=0;
  }
  preX=magneticField.x;
  preY=magneticField.y;
  preZ=magneticField.z;
}

void onGyroscopeEvent(float x, float y, float z) {//置き換え
  rotationX = x;
  rotationY = y;
  rotationZ = z;
}

void onMagneticFieldEvent(float x, float y, float z, long time, int accuracy){
  magneticField.set(x, y, z);
}

//ジャイロ閾値別色
void colortable(){
  if(rotationZ*180/PI>=0){
    B=(rotationZ*180/PI)/3.893;
    R=255-B;
  }else{
    B=(-rotationZ*180/PI)/3.893;
    R=255-B;
  }
  r=(int)R;
  b=(int)B;
}

void gyrovalueAndColorbar(){//カラーバー
  fill(r,g,b);
  rect(-displayWidth/2,-displayHeight/2,2.5,displayHeight);
}