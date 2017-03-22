//Tiao Ken by LiuW 2017 //<>//
/*
one pakges 8 bytes
 one big pakge 36 bytes
 1 second 512 pakges + 1 big pakges = 512 * 8 + 36 = 4132 bytes
 */
import processing.serial.*;
Serial port;
//String s = "/dev/tty.Sichiray-Port";
String s = "COM14";
long right = 0;
long wrong = 0;
float[] data;
byte[] inBuffer;
int BL = 4132;
int p = 0;
int scan = 1;

int[][] level = new int [100][];
float sx = 0;
float sy = 200;
float px = 125;
float py = 475;
float psx = 0;
float psy = 0;
int ground = 0;
float gx = 0;
float gy = 0;
float gsx = 0;
float gsy = 0;
float death = 0;
int power = 0;
int powerb = 0;
int powermax = 0;
int powermaxb = 0;
int died = 0;
float hp = 100;
int saverofworlds = 0;
int mem1 = 0;
int scaleX = 0;
int scaleY = 0;

void setup() {
  size(600, 400);
  //port = new Serial(this, s, 57600);
  //port.buffer(BL);
  inBuffer = new byte[BL];
  data = new float[width]; 
  //for (int i = 0; i < width; i++) data[i] = 100*sin(i*1.0/20) + 150;  
  for (int i = 0; i < width; i++) data[i] = 0;  

  noStroke();
  //generate level
  for (int x = 0; x < 100; x++) {
    level[x] = new int [100];
    for (int y = 0; y < 100; y++) {
      if (y < 10) {
        level[x][y] = 0;
      } else if (y < 14) {
        level[x][y] = 1;
      } else {
        level[x][y] = 6;
      }
    }
  }    
  // creat water
  for (int k = 0; k < 6; k++) {
    gx = random(1, 98);
    gy = 10;
    gsx = 0;
    gsy = 0;
    level[round(gx)][round(gy)] = 3;
    level[round(gx - 1)][round(gy)] = 3;
    level[round(gx + 1)][round(gy)] = 3;
    level[round(gx)][round(gy + 1)] = 3;
  }

  //create tree
  for (int l = 0; l < 8; l++) {
    gx = random(1, 98);
    gy = 9;
    if (level[round(gx)][round(gy + 1)] == 1 && level[round(gx)][round(gy)] == 0 && level[round(gx - 1)][round(gy)] == 0 && level[round(gx + 1)][round(gy)] == 0) {
      level[round(gx)][round(gy)] = 4;
      level[round(gx)][round(gy) - 1] = 4;
      level[round(gx - 1)][round(gy) - 1] = 5;
      level[round(gx) + 1][round(gy) - 1] = 5;
      level[round(gx - 1)][round(gy) - 2] = 5;
      level[round(gx)][round(gy) - 2] = 5;
      level[round(gx) + 1][round(gy) - 2] = 5;
      level[round(gx) - 1][round(gy) - 3] = 5;
      level[round(gx)][round(gy) - 3] = 5;
      level[round(gx) + 1][round(gy) - 3] = 5;
      level[round(gx)][round(gy) - 4] = 5;
    } else {
      l -= 0.9999;
    }
  }
}


void draw() {

  scale(width / 600, height / 400);
  scaleX = width / 600;
  scaleY = height / 400;  
  powerb = 0; 
  if (hp < 0) {
    die();
  }
  if (hp > 100) {
    hp = 100;
  } 
   if (random(1, 1000) > 990)
      p = 1;
   else 
      p = 0;
   p = 1;
   for (int i = 0; i < 10; i++) {

   //p = 1 ;
    movement();
    ground = 0;
    //screen movement and safe gaurds
    if (sx + 10 * 50 < px) {
      sx += abs(psx);
    }
    if (sx + 2 * 50 > px) {
      sx -= abs(psx);
    }
    if (sy + 6 * 50 < py) {
      sy += abs(psy);
    }
    if (sy + 2 * 50 > py) {
      sy -= abs(psy);
    }
    if (px < 0) {
      px = 0;
      psx = 0.4;
    }
    if (py < 0) {
      py = 0;
      psy = 0.4;
    }
    if (px > 100 * 50) {
      px = 100 * 50;
      psx = -0.4;
    }
    if (py > 100 * 50) {
      py = 100 * 50;
      psy = -0.4;
      ground = 1;
    }
    if (sx < 0) {
      sx = 0;
    }
    if (sy < 0) {
      sy = 0;
    }
    if (sx > 87.99 * 50) {
      sx = 87.99 * 50;
    }
    if (sy > 92 * 50) {
      sy = 92 * 50;
    }
    //display level
    for (int x = round(sx / 50 - 0.5); x < round(sx / 50 - 0.5) + 13; x++) {
      for (int y = round(sy / 50 - 0.5); y < round(sy / 50 - 0.5) + 9; y++) {
        if (level[x][y] == 0) {
          if (i == 0) {
            fill(250 - map(y, 0, 15, 200, 0), 250 - map(y, 0, 15, 50, 0), 250);
            rect(x * 50 - sx, y * 50 - sy, 50, 50);
          }
        } else if (level[x][y] == 1) {
          bounce(x, y);
          if (i == 0) {
            if (y > 0) {
              if (level[x][y - 1] == 0 || level[x][y - 1] == 4 || level[x][y - 1] == 5) {
                fill(120, 80, 0);
                rect(x * 50 - sx, y * 50 - sy, 50, 50);
                fill(0, 200, 0);
                rect(x * 50 - sx, y * 50 - sy, 50, 12);
              } else if (level[x][y - 1] == 28) {
                fill(120, 80, 0);
                rect(x * 50 - sx, y * 50 - sy, 50, 50);
                fill(50);
                rect(x * 50 - sx, y * 50 - sy, 50, 12);
              } else {
                fill(120, 80, 0);
                rect(x * 50 - sx, y * 50 - sy, 50, 50);
              }
            } else {
              fill(120, 80, 0);
              rect(x * 50 - sx, y * 50 - sy, 50, 50);
            }
          }
          if (death > 220) {
            fill(100, 100, 100);
            rect(x * 50 - sx, y * 50 - sy, 50, 50);
          }
        } else if (level[x][y] == 3) {
          if (px > x * 50 && py > y * 50 && px < x * 50 + 50 && py < y * 50 + 50) {
            hp -= 0.012;
          }
          if (i == 0) {
            fill(0, 200, 250);
            rect(x * 50 - sx, y * 50 - sy, 50, 50);
          }
          if (px > x * 50 - 10 && py > y * 50 - 10 && px < x * 50 + 60 && py < y * 50 + 60) {
            psx = psx / 1.01;
            psy = psy / 1.01;
            ground = 3;
          }
          if (y < 99) {
            if (level[x][y + 1] == 0 && random(1) < 0.02) {
              level[x][y + 1] = 3;
              level[x][y] = 0;
            }
          }
          if (x < 99) {
            if (level[x + 1][y] == 0 && random(1) < 0.01) {
              level[x + 1][y] = 3;
              level[x][y] = 0;
            }
          }
          if (x > 0) {
            if (level[x - 1][y] == 0 && random(1) < 0.01) {
              level[x - 1][y] = 3;
              level[x][y] = 0;
            }
          }
        } else if (level[x][y] == 4) {
          if (i == 0) {
            fill(150, 100, 0);
            rect(x * 50 - sx, y * 50 - sy, 50, 50);
          }
          if (death > 200) {
            fill(100, 100, 100);
            rect(x * 50 - sx, y * 50 - sy, 50, 50);
          }
        } else if (level[x][y] == 5) {
          if (i == 0) {
            fill(40, 180, 40);
            rect(x * 50 - sx, y * 50 - sy, 50, 50);
            if (death > 160) {
              fill(100, 100, 100);
              rect(x * 50 - sx, y * 50 - sy, 50, 50);
            }
          }
        } else if (level[x][y] == 6) {
          bounce(x, y);
          if (i == 0) {
            fill(100, 100, 100);
            rect(x * 50 - sx, y * 50 - sy, 50, 50);
          }
        }  
      }
    }
    if (i == 0) {
      fill(100, 100, 255);
      rectMode(CENTER);
      rect(px - sx, py - sy, 20, 20);
      rectMode(CORNER);
      ellipse(mouseX / scaleX, mouseY / scaleY, 5, 5);
    }
    if (i == 0) {
      for (int x = round(sx / 50 - 0.5); x < round(sx / 50 - 0.5) + 13; x++) {
        for (int y = round(sy / 50 - 0.5); y < round(sy / 50 - 0.5) + 9; y++) {
          if (level[x][y] == 28) {
            for (int a = 0; a < 20; a++) {
              fill(250, 250, 200, 5);
              //ellipse(x * 50 - sx + 25, y * 50 - sy + 25, random(80, 150));
            }
          } else if (level[x][y] == 29) {
            if (y > 0) {
              if (level[x][y - 1] == 30 || level[x][y - 1] == 33) {
                if (power > 0) {
                  power -= 1;
                  for (int a = 0; a < 50; a++) {
                    fill(250, 8);
                    //ellipse(x * 50 - sx + 25, y * 50 - sy + 25, a * 10);
                  }
                }
              }
            }
          }
        }
      }
    }
    psx = psx / 1.003;
    psy = psy / 1.003;
    py += psy;
    px += psx;
    psy += 0.0016;
  }
  fill(160, 140, 120, death);
  rect(0, 0, 600, 400);
  stroke(100);
  fill(250, 0, 0);
  rect(0, 1, hp * 6, 10);
  strokeWeight(1);
  noStroke();
  if (death > 255) {
    death = 0;
  }
  if (died > 0) {
    background(255, 0, 0, died * 5);
    died--;
  }
  powermaxb = powermax;
  powermax = 0; 
}

void  movement() {
  if (keyPressed && key == CODED) {
    if (keyCode == UP  && ground == 1) {
      psy -= 0.6;
      println(aaa++);
    } else if (keyCode == UP  && ground == 2) {
      psy -= 0.002;
    } else if (keyCode == UP  && ground == 3) {
      psy -= 0.003;  
    } else if (keyCode == RIGHT) {
      psx += 0.001;
    } else if (keyCode == LEFT) {
      psx -= 0.001;
    }
  }

  //println(scan);

  if ((p > 0) && ((millis() - scan) > 1000)) {    
    psy -= 0.6;
    scan = millis();
    println(ground);
  }
  //print(scan);
  //print("|");
  //println(millis());
}
int aaa = 0;
void die() {
  sx = 0;
  sy = 200;
  px = 125;
  py = 475;
  psx = 0;
  psy = 0;
  died = 80;
  hp = 100;
}

void bounce(int x, int y) {
  if (px > x * 50 - 9 && py > y * 50 - 10 && px < x * 50 + 59 && py < y * 50) {
    if (psy > 0.45) {
      double mem1 = 1; float a = 0;
      for (a = psy; a > 0; a = a) {
        a -= 0.01;
        mem1 = mem1 * 2;
      }
      hp -= mem1 / 1000000000;
    }
    py -= psy;
    py = y * 50 - 10;
    psy = 0;
    ground = 1;
  }
  if (px > x * 50 - 9 && py > y * 50 + 50 && px < x * 50 + 59 && py < y * 50 + 60) {
    py -= psy;
    py = y * 50 + 60;
    psy = 0;
  }
  if (px > x * 50 - 10 && py > y * 50 - 9 && px < x * 50 && py < y * 50 + 59) {
    px -= psx;
    px = x * 50 - 10;
    psx = 0;
  }
  if (px > x * 50 + 50 && py > y * 50 - 9 && px < x * 50 + 60 && py < y * 50 + 59) {
    px -= psx;
    px = x * 50 + 60;
    psx = 0;
  }
  if (px > x * 50 && py > y * 50 && px < x * 50 + 50 && py < y * 50 + 50) {
    hp -= 0.08;
  }
}

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
          if (v > 500 ) {
            p = 1;
          } 
        } else {
          wrong++;
        }
      }
    }
  }
}