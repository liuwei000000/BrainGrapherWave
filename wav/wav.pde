/*
one pakges 8 bytes
 one big pakge 36 bytes
 1 second 512 pakges + 1 big pakges = 512 * 8 + 36 = 4132 bytes
 */

import processing.serial.*;
Serial port;
//String s = "/dev/tty.Sichiray-Port";
String s = "COM4";
long right = 0;
long wrong = 0;
float[] data;
byte[] inBuffer;
int BL = 4132;
int p = 0;
int scan = 1;

void setup() {
  size(640, 440);
  frameRate(30);
  smooth();
  fill(255, 20, 50);
  port = new Serial(this, s, 57600);
  port.buffer(BL);
  inBuffer = new byte[BL];
  data = new float[width]; 
  //for (int i = 0; i < width; i++) data[i] = 100*sin(i*1.0/20) + 150;  
  for (int i = 0; i < width; i++) data[i] = 0;  
  background(0);
}

void draw0() {
  background(0);
  stroke(255,0,0,80);
  strokeWeight(1);
  p++;
  for (int j = 0; j < width; j+= scan) {
    int x = p + j/scan;
    while (x >= width) x -= width;
    if (j + scan < width && x + 1 < width) {
      line(j, height - data[x], j + scan, height - data[x + 1]);
    }
  }
}

void draw() {
  //delay(100);
  draw0();
  print(wrong);
  print("|"); 
  println(right);
}

int p1 = 0;
void serialEvent(Serial port) {
  while (port.available() > 0) {
    inBuffer = port.readBytes();
    for (int m = 0; m < BL - 4; m++) {
      if (inBuffer[m] == byte(0xAA) &&
        inBuffer[m + 1] == byte(0xAA) &&
        inBuffer[m + 2] == byte(0x04)) {
        int d1 = int(inBuffer[m + 5]);
        int d2 = int(inBuffer[m + 6]);
        int sum = int(inBuffer[m + 7]);
        int csum = ((0x80 + 0x02 + d1 + d2) ^ 0xffffffff) & 0xff;
        if (sum == csum) {
          right++;
          long d = (d1 << 8) | d2;
          if (d > 32768) d -=65536;
          float v = map(d, -1500, 1500, 0, height);
          data[p1] = v;
          p1++;if (p1 >= width - 1) p1 =0;
        } else {
          wrong++;
        }
      }
    }
  }
}