//micro:bitとつなぐサンプル
//加速度XYZ＋ボタンAB
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
    background(255, 255, 255); //背景を白で塗りつぶす
  }

  pushMatrix();                //座標を変換
  translate(x*800, y*600);     //xで0〜800、yで0〜600移動
  rotate(radians(z*360));      //zで0〜360°回転
  scale(1.0+z*9.0);            //zで1.0〜5.0倍
  noFill();                    //線をナシに
  //塗りの色をbで変える（ランダムの要素を入れて）
  stroke(random(255)*b, 100*b, 255*b, random(100));
  if (b==1) {
    ellipse(0, 0, 10, 10);    //四角を描く
  } else {
    rect(-5, -5, 10, 10);    //四角を描く
  }
  popMatrix();
}