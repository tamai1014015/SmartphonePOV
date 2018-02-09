/*
概要
・回転中にタップし続けると曲が流れるアプリ
問題点
・中心の赤い円をうまく活かせていない→後日アプデ予定
・
thanks
・音楽を演奏するには(AndroidMode編)
http://mslabo.sakura.ne.jp/WordPress/make/processing%E3%80%80%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9/%E9%9F%B3%E6%A5%BD%E3%82%92%E6%BC%94%E5%A5%8F%E3%81%99%E3%82%8B%E3%81%AB%E3%81%AF%EF%BC%88androidmode%E7%B7%A8%EF%BC%89/
・魔王魂 フリー高音質BGM素材 アコースティック
https://maoudamashii.jokersounds.com/list/bgm3.html
*/

//音楽
import android.app.Activity;
import android.content.Context;
import android.media.MediaPlayer;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import java.io.IOException;
import java.text.MessageFormat;
AssetManager assetManager;
AssetFileDescriptor fd = null;
MediaPlayer player = null;
Activity    act;
Context     con;
boolean touch=false;
//フラグメント停止時のリソース開放   
@Override
public void onDestroy() {
  if( player != null ){
      player.release();
  }
  super.onDestroy();
}
//センサ
import ketai.sensors.*;
KetaiSensor sensor;
PVector gyroscope,magneticField;
void onGyroscopeEvent(float x, float y, float z) {
  gyroscope.set(x, y, z);
}
void onMagneticFieldEvent(float x, float y, float z, long time, int accuracy) {
  magneticField.set(x, y, z);
}
float preX, preY, preZ;
//ナビゲーションバー隠し
import android.view.View;
import android.app.Activity;
//Activity act;
private static final int SYSTEM_UI_FLAG_HIDE_NAVIGATION = 0x00000002;
private static final int SYSTEM_UI_FLAG_FULLSCREEN = 0x00000004;
private static final int SYSTEM_UI_FLAG_LAYOUT_STABLE = 0x00000100;
private static final int SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION = 0x00000200;
private static final int SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN = 0x00000400;
private static final int SYSTEM_UI_FLAG_IMMERSIVE_STICKY = 0x00001000;
//その他
int n=0;//何文字目 0～splitData.length-1
int c=0;//何列目 0～3
int[][] T = {{1, 1, 1, 0},{0, 1, 0, 0},{0, 1, 0, 0},{0, 1, 0, 0},{0, 1, 0, 0}};
int[][] O = {{1, 1, 1, 0},{1, 0, 1, 0},{1, 0, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0}};
int[][] U = {{1, 0, 1, 0},{1, 0, 1, 0},{1, 0, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0}};
int[][] C = {{1, 1, 1, 0},{1, 0, 0, 0},{1, 0, 0, 0},{1, 0, 0, 0},{1, 1, 1, 0}};
int[][] H = {{1, 0, 1, 0},{1, 0, 1, 0},{1, 1, 1, 0},{1, 0, 1, 0},{1, 0, 1, 0}};
int[][] error = {{0, 0, 0, 0},{0, 0, 0, 0},{1, 1, 1, 0},{0, 0, 0, 0},{0, 0, 0, 0}};
char data[] = new char[10];//テキスト
    
void setup() {
  orientation(LANDSCAPE);
  size(displayWidth, displayHeight);
  textSize(24);
  textAlign(CENTER);
  frameRate(60);
  //センサ
  sensor = new KetaiSensor(this);
  sensor.start();
  gyroscope = new PVector();
  magneticField = new PVector();
  //テキスト
  data[0]='T';
  data[1]='O';
  data[2]='U';
  data[3]='C';
  data[4]='H';
  //変数の初期化、各リソースの読み込み
  act = getActivity();
  con = act.getApplicationContext();
  //MediaPlayerの生成
  player = new MediaPlayer();
  //アセットからBGMの読み込み    
  assetManager = act.getResources().getAssets();    
  try{
    //アセットのOPEN
    fd = assetManager.openFd("bgm_maoudamashii_acoustic50.ogg");
    //音楽データの割り当て
    player.setDataSource( 
        fd.getFileDescriptor(), 
        fd.getStartOffset(), fd.getLength());
    //同期読み込み
    player.prepare();
    //アセットのclose
    fd.close();
  } catch( IOException e){
    //例外
    throw new IllegalStateException(
      MessageFormat.format(
        "music Preparation error: msg={0}, value={1}",
        e.getMessage(), e.getStackTrace()));
  }
}
 
public void draw() {
  background(0);
  translate(width/2/*+35*/, height/2);
  playMusic();
  if(gyroscope.z>=1||gyroscope.z<=-1){
    array();
  }else{
    showDisk();
  }
}

void showDisk() {
  noStroke();
  fill(255,0,0);
  ellipse(0, 0, 480, 480);
  fill(0);
  ellipse(0,0,45,45);
}

public void mousePressed() {
  if(gyroscope.z>=1||gyroscope.z<=-1){
    touch=true;
  }
}

public void mouseReleased(){
  touch=false;
}

void playMusic(){
  /*if(gyroscope.z<1||gyroscope.z>-1){
    touch=false;
  }*/
  if(touch==false){
    if(player.isPlaying()){
      player.pause();
    }
  }else{
    if(player.isPlaying()==false){
      player.start();
    }
  }
}

public void onResume(){//ナビバー隠し
  super.onResume();
  act = this.getActivity();
  View decorView = act.getWindow().getDecorView();
  // Hide both the navigation bar and the status bar.
  int uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
  | SYSTEM_UI_FLAG_FULLSCREEN
  | SYSTEM_UI_FLAG_LAYOUT_STABLE
  | SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
  | SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
  | SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
  decorView.setSystemUiVisibility(uiOptions);
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
  //pushMatrix();
  rect(-240+44*n, -4, 44, 8);
  rect(240-44*n, -4, -44, 8);
  /*rotate(PI);
  fill(255);
  rect(60-width/2+50*n, -5, 50, 10);
  popMatrix();*/
}

void bitmapColumn(int[][] t, int c){
  for(int r=0; r<5; r++){
      if(t[r][c]==1){
        fill(255);
        led(r);
      }else{
        fill(255,0,0);
        led(r);
      }
  }
}

int[][] bitmap(char[] c,int n){
  if(c[n]=='T') return T;
  else if(c[n]=='O') return O;
  else if(c[n]=='U') return U;
  else if(c[n]=='C') return C;
  else if(c[n]=='H') return H;
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