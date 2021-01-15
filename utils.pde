Point transform(float x, float y) {
  float angl = radians(28);
  
  x -= 582000;
  y -= 4505000;
  
  //x *= 1000;
  //y *= 1000;
  
  float c = cos(angl);
  float s = sin(angl);
  
  x = c*x-s*y;
  y = s*x + c*y;
  
  y -= 1320;
  x += 2150;

  return new Point(int(y), int(x));
}

class Point {
  int x,y;
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  Point(Point other) {
    this.x = other.x;
    this.y = other.y;  
  }
  
  void add(Point other) {
    x += other.x;
    y += other.y;
  }
  
  void sub(Point other) {
    x -= other.x;
    y -= other.y;
  }
  
  void sub(int x, int y) {
    this.x -= x;
    this.y -=y;
  }
  
  void mult(float a) {
    x = int(x*a);
    y = int(y*a);
  }
  
  void div(int a) {
    x = int(x/a);
    y = int(y/a);
  }
  
  String asString() {
    return str(x) + " " + str(y);
  }
  
  void zero() {
    x = 0;
    y = 0;
  }
}

void setColour(PGraphics layer, int state) {
   layer.stroke(
    state_colour[state].x,
    state_colour[state].y,
    state_colour[state].z
  );
  
  layer.fill(
    state_colour[state].x,
    state_colour[state].y,
    state_colour[state].z
   );
}

void setColour(int state) {
  stroke(
    state_colour[state].x,
    state_colour[state].y,
    state_colour[state].z
  );
  
  fill(
    state_colour[state].x,
    state_colour[state].y,
    state_colour[state].z
   );
}


void renderCardboard() {
  cardboard.beginDraw();
  cardboard.fill(255);
  cardboard.stroke(255);
  
  cardboard.rect(0, 0, width, 50);
  cardboard.rect(0, 0, 50, height);
  cardboard.rect(map_width+50, 0, 50, height);
  cardboard.rect(0, map_height+50, width, 350);
  cardboard.endDraw();
}

void loadingAnimation() {

    fill(255);
    stroke(255);
    strokeWeight(4);
    rect(map_width/2 - 200, map_height/2 - 150, 400, 250, 20);
    fill(64);
    textSize(50);
    text("LOADING", map_width/2 - 110, map_height/2 - 60);
    setColour(0); 
    
    for(int i = 0; i < 4; i++) {
      fill(255, 110 + 10*sin(radians(millis()/3)), 0);
      stroke(255, 110 + 10*sin(radians(millis()/3)), 0);
      
      circle(
        map_width/2 - 60 + 40*i, 
        map_height/2+ 20 + sin(radians(millis()/3 + 333*i/4))*20,
        20
      );
    }
}
