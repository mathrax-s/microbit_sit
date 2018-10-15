//micro:bitとつなぐサンプル
import processing.pdf.*;
boolean serialPortSelect;
int selectSerialPortNum;

void setup() {
  //画面サイズを800x600にする
  size(800, 600);

  //シリアルポートを探す
  searchSerialPort();
}

void draw() {
  drawMain();

  //シリアルポートを選んでない場合
  if (!serialPortSelect) {
    //シリアルポート選択画面を表示
    serialPortSelectScene();
    return;
  }

  //micro:bitからのデータが何かあれば、doMain()へ
  if (microbitData!=null) {
    drawMain();
  } else {
    //micro:bitからのデータが何もなければ「クリックして戻る」表示
    background(0);
    fill(255);
    text("No data...\r\n Click and back to select serialport.", width/2, height/2);
  }
}

//micro:bitのデータを使ったプログラム
void drawMain() {
  //microbitDataを、0.0〜1.0に整える  
  float x = map(microbitData[0], -1024, 1023, 0, 1);
  float y = map(microbitData[1], -1024, 1023, 0, 1);
  float z = map(microbitData[2], -1024, 1023, 0, 1);
  float a = microbitData[3];  //ボタンAをオンオフ
  float b = microbitData[4];  //ボタンBのオンオフ

  //ボタンAを押したら
  if (a==1) {
    background(255, 255, 255);   //背景を白で塗りつぶす
  }

  pushMatrix();                //座標を変換
  translate(x*800, y*600);     //xで0〜800、yで0〜600移動
  rotate(radians(z*360));      //zで0〜360°回転
  scale(1.0+z*9.0);            //zで1.0〜5.0倍
  noFill();                  //線をナシに
  //塗りの色をbで変える（ランダムの要素を入れて）
  stroke(random(255)*b, 100*b, 255*b, random(100));
  if (b==1) {
    ellipse(0, 0, 10, 10);    //四角を描く
  } else {
    rect(-5, -5, 10, 10);    //四角を描く
  }
  popMatrix();
}




int recDone=0;

void keyPressed() {
  if (key==' ') {
    background(255);
  }
  if (key=='s') {
    if (recDone==0) {
      recDone=1;
      beginRecord(PDF, "line_####.pdf");
    } else {
      recDone=0;
      endRecord();
    }
  }
}

//マウスクリックしたとき
void mousePressed() {
  //シリアルポート選択がまだの場合
  if (!serialPortSelect) {
    //シリアルポートを開く
    serialOpen(selectSerialPortNum);
    //シリアルポート選択した、と記憶する
    serialPortSelect=true;
    //画面を白で消去
    background(255);
  } else {  //シリアルポート選択している場合

    //micro:bitからのデータが空の時
    if (microbitData==null) {
      //間違ったポートを開いたとみなし、いったんポートを閉じる
      serialClose();
      //シリアルポート未選択とする
      serialPortSelect=false;
      //画面を白で消去
      background(255);
    }
  }
}


//シリアルポートを選ぶ画面の表示
void serialPortSelectScene() {
  colorMode(RGB);
  background(0);
  selectSerialPortNum=-1;
  for (int i=0; i<serialString.length; i++) {
    int h = height/serialString.length;
    if (overRect(0, h*i, width, h)) {
      //
      noStroke();
      fill(255, 255, 255);
      selectSerialPortNum=i;
    } else {
      //
      stroke(100, 100, 100);
      noFill();
    }
    rect(0, h*i, width-1, h);

    if (selectSerialPortNum==i) {
      fill(0, 0, 0);
    } else {
      fill(255, 255, 255);
    }
    textAlign(CENTER, CENTER);
    textSize(20);
    text(serialString[i], width/2, h/2+h*i);
  }
}

//マウスが指定したエリア内に入ったかどうか調べる
boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}