// ARGUMENTS

int
map_width = 1800,
map_height = 820,
no_of_vehicles = 2000;

String logs_path = "data/fullLog2.log";
String map_path = "manhattan-compressed.dot";

//AVAILABLE = 0, ASSIGNED = 1, ENROUTE = 2;
PVector[] state_col = { 
  new PVector(255, 120, 0),
  new PVector(14, 227, 24),
  new PVector(66, 135, 245),
  new PVector(218,112,214),
  new PVector(248, 252, 3)
  
};



//time: 47056
//1840


Integer[] states = new Integer[5];
Boolean[] show_states = {true, true, true, true, true};
String[] states_names = {"available", "assigned", "en route"};


PGraphics 
map,
vehicles_layer,
cardboard,
test;


Vehicle[] vehicles = new Vehicle[no_of_vehicles];

int 
  scale = 3,            // map scale
  fr = 30,              // frame rate
  selected = -1,        // selected
  trail_start= -1,
  time= 2147483647,
  speed = 10;

Boolean 
  show_dest = false,
  follow = true;

Point 
  moved = new Point(0, 0),
  adjust_moved = new Point(0,0);


void setup() {
  size(1900, 1000);
  
  cardboard = createGraphics(width, height);
  
  vehicles_layer = createGraphics(map_width*9/scale, map_height*9/scale);
  map = createGraphics(map_width*9/scale, map_height*9/scale);
  
  test = createGraphics(500, 500);
  
  test.beginDraw();
  test.fill(0);
  test.rect(100, 100, 300, 300);
  test.fill(0, 0);
  test.rect(200, 200, 100, 100);
  test.endDraw();
  
  renderMap();
  renderCardboard();

  initVehicles();
  
  states[0] = 0;
  states[1] = 0;
  states[2] = 0;
  
  frameRate(fr);
}


void draw() {
  background(255);

  
  renderVehicles(time);
  drawLayers();
  drawInfoBox();
  displayText();
  
  if(!paused) time += speed;
  moved.add(adjust_moved);
  adjust_moved.zero();
}




void renderVehicles(int t) {
  vehicles_layer.beginDraw();
  vehicles_layer.clear();
  

  for(int i = 0; i < 5; i++) states[i] = 0;
  if(trail_start > -1 && selected > -1) {
    vehicles[selected].drawTrail(vehicles_layer, trail_start);
  }
  
  for(Vehicle v : vehicles) {
    if(v != null) {
      v.update(t);
      states[v.curr_state] += 1;
      if(show_states[v.curr_state]) {
        v.draw(vehicles_layer);
      }
    }
  }
  
  if(selected > -1) {
    handleSelected();
  }
  
  vehicles_layer.endDraw();
}

void handleSelected() {

  vehicles[selected].draw(vehicles_layer);
  
  if(follow) {
    if(vehicles[selected].curr_position.x < (map_width/2) - 100) {
      adjust_moved.x = ((map_width/2) - 100 - (int)vehicles[selected].curr_position.x) / 100;
    } else if(vehicles[selected].curr_position.x > (map_width/2) + 100) {
      adjust_moved.y = ((map_width/2) + 100 - (int)vehicles[selected].curr_position.x) / 100;
    }
    if(vehicles[selected].curr_position.y < (map_height/2) - 50) {
      adjust_moved.y = ((map_height/2) - 50 - (int)vehicles[selected].curr_position.y) / 50;
    } else if(vehicles[selected].curr_position.y > (map_height/2) + 50) {
      adjust_moved.y = ((map_height/2) + 50 - (int)vehicles[selected].curr_position.y) / 50;
    }
  }


  vehicles_layer.fill(0,0);
  vehicles_layer.stroke(255, 0, 0);
  vehicles_layer.strokeWeight(3);
  vehicles_layer.circle(vehicles[selected].curr_position.x, vehicles[selected].curr_position.y, 10 + 27/scale);
  vehicles_layer.strokeWeight(1);
}  //<>//

void displayText() {
  
  fill(0); //<>//
  textSize(10);
  
  text("time:", 55, 45);
  text("   speed:" , 233, 45);
  text("scale:" , 463, 45);
  
  textSize(20);
  

  text(str(float(speed)/10), 300, 45);
  text(str(scale), 500, 45); //<>//
  
  textSize(22);
  text(str(time/10), 90, 45);
 
}


void drawLayers() {

  fill(255, 0);
  stroke(0); //<>//
  
  image(map, 50+moved.x, 50+moved.y);
  image(vehicles_layer, 50, 50);

  image(cardboard, 0, 0); //<>//
  rect(50, 50, map_width, map_height);
  
}



void drawInfoBox() {
  textSize(20);
  
  for(int i = 0; i < 3; i++) {
    fill(0);
    text(states_names[i], 55 + 200*i, map_height + 135);
    text(str(states[i]), 90 + 200*i, map_height + 100);
    
    fill(255, 0);
    stroke(0);
    strokeWeight(2);
    rect(55 + 200*i,map_height + 80, 20, 20); 
    
    if(show_states[i]) {
      
      fill(state_col[i].x, state_col[i].y, state_col[i].z);
      stroke(state_col[i].x, state_col[i].y, state_col[i].z);
      circle(65 + 200*i, map_height+90, 10);
    }
  }
  
  stroke(0);
  fill(0);
  String t;
  
  stroke(255, 0, 0);
  fill(255, 0);
  strokeWeight(3);
  //if(selecting ==-2 || time % 200 > 50)
  circle(665, map_height+90, 20);
  
  fill(0);
  
  if(selecting > -2) {
    float l = 0;
    if(selecting > -1) {
      text(str(selecting), 690, map_height+100);
      l = textWidth(str(selecting));
    }
    strokeWeight(2);
    stroke(0);
    if(time % 300 > 150) line(690+l+3, map_height+103, 690+l+3, map_height+80);
    
  } else if(selected > -1) text(str(selected), 690, map_height+100);
  else {
    fill(100);
    text("none", 690, map_height+98);
    fill(0);
  }
  text("selected", 655, map_height+135);
}
