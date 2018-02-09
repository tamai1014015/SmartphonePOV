PImage img;
int mosaicWidth = 12;
int mosaicHeight = 12;
int[][] imgBit = new int [25][25];
int c=0;
 
void setup() {
  size(displayWidth, displayHeight);
  //noStroke();
  img = loadImage("pict.jpg");
  image(img, 0, 0, 300, 300);
  loadPixels();
  for(int i=0; i<25; i++){
    for(int j=0; j<25; j++){
      imgBit[j][i]=9;//とりま全ての配列に9を代入
    }
  }
  for(int j=0; j<img.height; j+=mosaicHeight){  
    for(int i=0; i<img.width; i+=mosaicWidth){ 
      color c=pixels[j*width+i];
      
      if(0<=red(c)&&red(c)<=5){//黒(絵がある)なら
        if(0<=green(c)&&green(c)<=5){
          if(0<=blue(c)&&blue(c)<=5){
            imgBit[j/mosaicHeight][i/mosaicWidth]=1;//配列に1を代入
            //an=a+(n-1)d=0+(j-1)mH 
          }
        }
      }else if(250<=red(c)&&red(c)<=255){//白(絵がない)なら
        if(250<=green(c)&&green(c)<=255){
          if(250<=blue(c)&&blue(c)<=255){
            imgBit[j/mosaicHeight][i/mosaicWidth]=0;//配列に0を代入
          }
        }
      }else{
        imgBit[j/mosaicHeight][i/mosaicWidth]=6;//それ以外なら6
      }
    }
  }
}
 
void draw() {
  background(0);
  array();
}

void led(int n) {
  //pushMatrix();
  fill(255);
  rect(width/2-5, 60+10*n, 10, 10);
  /*for(int i=0; i<1; i++){
    rotate(PI);
    fill(255);
    rect(width/2-5, 60+10*n, 10, 10);
  }
  popMatrix();*/
}

void bitmapColumn(int[][] t, int c){
  for(int r=0; r<25; r++){
      if(t[r][c]==1) led(r);
  }
}

void array(){
  bitmapColumn(imgBit, c);
  if(c==24){
    c=0;
  }else{
    c++;
  }
}

/*
  for(int i=0; i<25; i++){//配列に値がちゃんと入っているかチェック
    for(int j=0; j<25; j++){
      if(imgBit[j][i]==1){
        fill(255);
        rect(i*12,j*12,12,12);
      }else if(imgBit[j][i]==0){
        fill(0);
        rect(i*12,j*12,12,12);
      }else if(imgBit[j][i]==6){
        fill(180);
        rect(i*12,j*12,12,12);
      }else{
        fill(255,100,100);
        rect(i*12,j*12,12,12);
      }
    }
  }*/