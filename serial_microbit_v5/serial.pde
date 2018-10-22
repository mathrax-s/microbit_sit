//シリアル通信
import processing.serial.*;
Serial myPort;

int portNumber;

//シリアルポートをオープンする
void serialOpen(int num) {
  if (num>=0) {
    myPort = new Serial(this, Serial.list()[num], 115200);   
    delay(1000);
    myPort.clear();
  }
}

String[] serialString;  
int serialCount = 0;

//シリアルポートをさがす
void searchSerialPort() {
  boolean firstContact = false; 
  String serialCheck;  
  int serialIndex;  
  int unknown;

  unknown=0;
  serialString = Serial.list();  
  for (int i = serialString.length - 1; i > 0; i--) {  
    serialCheck = serialString[i];
  }
  //println(Serial.list());
}

//シリアルポートがオープンなら、クリアしてクローズする
void serialClose() {
  if (myPort!=null) {
    myPort.clear();
    myPort.stop();
  }
}


//データが送られてきたとき
void serialEvent (Serial p) {
  //文字列の改行まで読み取る
  String stringData=p.readStringUntil(10);

  if (stringData!=null) {
    //受け取った文字列にある先頭と末尾の空白を取り除き、データだけにする
    stringData=trim(stringData);
    
    //「,」で区切られたデータ部分を分離してbufferに格納する
    int buffer[] = int(split(stringData, ','));
    
    //bufferのデータをstoreData関数に送る(store_dataタブ内）
    storeData(buffer);
  }
}