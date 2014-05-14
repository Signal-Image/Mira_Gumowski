import java.awt.event.*;

int i, NbPoint = 1024;
float a=-0.918, b=.9;
float x0 = 1, y0 = 1;
float x,y,xa,ya;
float c,f;

boolean displayInfo = true;
boolean randomizer = false;
boolean random0 = false;
boolean cls = true;
int colorMode = 0;
float zoom = 10;

void setup() {
  size(600, 600);
  background(255);
  noStroke();
  smooth();

  /* Gestion de la molette */
  frame.addMouseWheelListener(new MouseWheelInput());

  /* Gestion des polices */
  PFont myFont = createFont(PFont.list()[2], 10);
  textFont(myFont);
}

void fillColor(float x, float y) {
  if (colorMode == 0)
    colorMode(HSB);
  else
    colorMode(RGB);

  switch(colorMode) {
  case 0:
    fill(map(atan2(x,y),-PI,PI,0,255),255,255,100);
    break;
  case 1:
    fill(255,0,0,100); /* red */
    break;
  case 2:
    fill(0,255,0,100); /* green */
    break;
  case 3:
    fill(0,0,255,100); /* blue */
    break;
  default:
    fill(0,0,0,100);   /* black */
  }
}

void draw() {
  
  if(NbPoint == 0)
     NbPoint = 1;
  
  pushMatrix();
  if(mousePressed) {
    if(mouseButton == LEFT) {
      a = map(mouseX,0,width,-2,2);
      b = map(mouseY,0,height,-2,2);
    }
    if(mouseButton == RIGHT) {
      x0 = map(mouseX,0,width,-20,20);
      y0 = map(mouseY,0,height,-20,20);
    }  
  }

  if(random0) {
    x0 = random(-20,20);
    y0 = random(-20,20);    
  }

  if(cls) {
    fill(255,30);
    rect(0,0,width,height);
  }
  
  c=2*(1-a);
  xa=x0; 
  ya=y0;
  f = a*xa+c*xa*xa/(1+xa*xa);

  if(displayInfo) {
    fill(255);
    rect(0,0,200,30);
    fill(0);
    text("a = " + a, 10,10);
    text("b = " + b, 10,20);
    text("NbPoint = " + NbPoint, 10, 30);
    text("x0 = " + x0, 110,10);
    text("y0 = " + y0, 110,20);
    text("Appuyer sur I pour masquer les informations", width-300, 10);
    text("R et T pour activer la randomisation", width-300, 30);
    text("B et N pour modifier le nombre de points", width-300, 40);
    text("C pour changer le mode colorimétrique", width-300, 50);
    text("ESPACE pour enregistrer l'image", width-300, 60);
  }

  translate(width/2,height/2);
  for(int i = 0; i < NbPoint; i++) {
    x = f+b*ya;
    f = a*x+c*x*x/(1+x*x);
    y = f-xa;
    fillColor(x,y);
    ellipse(zoom*x,zoom*y,3,3);
    if(randomizer) {
      x += random(-.1,.1);
      y += random(-.1,.1);
    }
    xa = x;
    ya = y;
  }
  fill(0);
  popMatrix();
}

class MouseWheelInput implements MouseWheelListener{  
  void mouseWheelMoved(MouseWheelEvent e) {
    int step=e.getWheelRotation();
    zoom=zoom*exp(step/10.);
    redraw = true;
  }
}

void keyPressed() {
  if(key == ' ')
    saveFrame("mira-" + frameCount + ".png");
  if(key == 'i' || key == 'I')
    displayInfo = !displayInfo;
  if(key == 'b' || key == 'B')
    NbPoint /= 2;
  if(key == 'n' || key == 'N')
    NbPoint *= 2;
  if(key == 'r' || key == 'R')
    randomizer = !randomizer;
  if(key == 't' || key == 'T')
    random0 = !random0;
  if(key == 'k' || key == 'K')
    cls = !cls;
  if(key == 'c' || key == 'C')
    colorMode = (colorMode + 1) % 5;
}

