// ARGUMENTS

int
no_of_vehicles = 2000,
WIDTH = 1900,
HEIGHT = 1000,
ANGLE = 299;

String proj_name = "LAPJV_reb1";
String map_path = "manhattan-compressed.dot";

PVector[] state_colour = { 
  new PVector(255, 120, 0),
  new PVector(14, 227, 24),
  new PVector(66, 135, 245),
  new PVector(218,112,214),
  new PVector(248, 232, 0)
};

String[] states_names = {
  "available", 
  "en route\nto pickup", 
  "en route\nto dropoff",
  "arrived\nat pickup",
  "arrived\nat dropoff"
};



Integer[] states = new Integer[5];
Boolean[] show_states = {true, true, true, true, true};

PGraphics 
vehicles_layer,
cardboard,
test;

Map map;

Requests requests = new Requests();
Vehicle[] vehicles = new Vehicle[no_of_vehicles];

int 
  zoom_adj = 100,
  scale = 60,            // map scale
  fr = 30,              // frame rate
  selected = -1,        // selected
  trail_start= -1,
  time= 2147483647,
  speed = 10,
  no_of_states = 5,
  map_width,
  map_height;

float  
  max_x = 0,
  max_y = 0,
  min_x = Integer.MAX_VALUE,
  min_y = Integer.MAX_VALUE,
  fmin_x = Integer.MAX_VALUE,
  fmin_y = Integer.MAX_VALUE,
  angle;

Boolean 
  show_dest = false,
  follow = true,
  vehicles_loaded = false;

Point 
  moved = new Point(0, 0),
  adjust_moved = new Point(0,0);


void settings() {
  size(WIDTH, HEIGHT);
  //fullScreen();
}

void setup() {
  surface.setTitle("AseemViewer");
  surface.setResizable(true);
  
  map_width = width-100;
  map_height = height-130;
  angle = radians(ANGLE);
  
  background(255);
  
  textFont(createFont("Ubuntu", 10));
  
  File proj_file = new File(dataPath(proj_name));
  
  if(!proj_file.exists() && !proj_file.isDirectory()) {
    String[] command = {"./process_logs.sh", proj_name};
    try {
      Runtime.getRuntime().exec(command, null, new File(sketchPath("")));
    } catch (Exception e) {
      println("Error running command!"); 
      println(e);
    }
    delay(8000);
  }
  thread("initVehicles");

  cardboard = createGraphics(width, height);
  
  for(int i = 0; i < 5; i++) states[i] = 0;
  
  
  vehicles_layer = createGraphics(map_width*100/scale, map_height*100/scale);
  
  map = new Map(map_path);
  map.renderMap();
  map.displayMap();
  
  renderCardboard();
  
  frameRate(fr);
  //filter(BLUR, 10);
  
}

void draw() {

  background(255);
  
  if(vehicles_loaded) {
    renderVehicles(time);
  }
  
  drawLayers();
  drawInfoBox();
  displayText();

  if(!vehicles_loaded) loadingAnimation();
  
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
  vehicles_layer.circle(vehicles[selected].curr_position.x, vehicles[selected].curr_position.y, 10 + 300/scale);
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
  
  map.displayMap();
  image(vehicles_layer, 50, 50);

  image(cardboard, 0, 0); //<>//
  rect(50, 50, map_width, map_height);
}



void drawInfoBox() {
  int v_dist = 170, h_dist = 80;
  textSize(15);
  textLeading(17);
  for(int i = 0; i < no_of_states; i++) {
    fill(0);
    text(states_names[i], 55 + v_dist*i, map_height + h_dist + 25);
    text(str(states[i]), 90 + v_dist*i, map_height + h_dist);
    
    fill(255, 0);
    stroke(0);
    strokeWeight(2);
    rect(55 + v_dist*i,map_height + h_dist - 15, 20, 20); 
    
    if(show_states[i]) {
      setColour(i);
      circle(65 + v_dist*i, map_height+h_dist-5, 10);
    }
  }
  
  stroke(0);
  fill(0);
  
  stroke(255, 0, 0);
  fill(255, 0);
  strokeWeight(3);
  circle(65 + v_dist*no_of_states, map_height+h_dist-5, 20);
  
  fill(0);
  
  if(selecting > -2) {
    float l = 0;
    if(selecting > -1) {
      text(str(selecting), 90 + v_dist*no_of_states, map_height+h_dist);
      l = textWidth(str(selecting));
    }
    strokeWeight(2);
    stroke(0);
    if(second() % 2 > 0) {
      line(
        v_dist*no_of_states+90+l+3,
        map_height+h_dist+3, 
        v_dist*no_of_states+90+l+3,
        map_height+h_dist-18);
    }
    
  } else if(selected > -1) text(str(selected), no_of_states*v_dist + 90, map_height+h_dist);
  else {
    fill(100);
    text("none", 90 + v_dist*no_of_states, map_height+h_dist-2);
    fill(0);
  }
  text("selected", 55 + v_dist*no_of_states, map_height+h_dist+25);
}
