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
    state_col[state].x,
    state_col[state].y,
    state_col[state].z
  );
  
  layer.fill(
    state_col[state].x,
    state_col[state].y,
    state_col[state].z
   );
}

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
