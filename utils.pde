
Point transform(float x, float y) {

  float 
    buff,
    c = cos(angle),
    s = sin(angle);

  x -= fmin_x;
  y -= fmin_y;
  
  buff = c*x-s*y;
  y = s*x + c*y;
  x = buff;
  
  x -= min_x;
  y -= min_y;
  

  x *= zoom_adj;
  y *= zoom_adj;
  
  return new Point(int(x), int(y));
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
  
  Boolean withinRectangle(int x1, int y1, int x2, int y2) {
    if(x < x1 || x > x2 || y < y1 || y > y2) return false;
    return true;
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
  cardboard.fill(255, 230);
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
    strokeWeight(2);
    //rect(map_width/2 - 120, map_height/2 - 30, 240, 100, 50);
    fill(64);
    setColour(0); 
    
    for(int i = 0; i < 4; i++) {
      fill(255, 140 + 70*sin(radians(millis()/3 + 333*i/4)), 0);
      //stroke(255, 130 + 40*sin(radians(millis()/3 + 333*i/4)), 0);
      stroke(255);
      
      circle(
        map_width/2 - 60 + 40*i, 
        map_height/2+ 20 + sin(radians(millis()/3 + 333*i/4))*20,
        23
      );
    }
}
