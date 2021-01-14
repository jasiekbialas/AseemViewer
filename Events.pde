Point mouse;
int selecting = -2;
Boolean paused = false, render = true;

void mousePressed() {
  mouse = new Point(mouseX, mouseY);
}


void mouseDragged() {
  moved.sub(mouse);
  mouse = new Point(mouseX, mouseY);
  moved.add(mouse);
}

void mouseClicked() {

  if( mouseX > 50 && mouseX < map_width+50 &&
      mouseY > 50 && mouseY < map_height+50) {
    
    for(Vehicle v : vehicles) {
      if(v.curr_position == null) continue;
      if(abs(mouseX - 50 - v.curr_position.x) < 5+9/scale && (abs(mouseY - 50 - v.curr_position.y) < 5+9/scale)) {
        if(v.id == selected) {
          trail_start = -1;
          selected = -1;
        }
        else selected = v.id;
      }
    }
    redraw();
  }
  

}


void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
      case RIGHT: time += 100; break;
      case LEFT: time -= 100; break;
      case UP: time += 600; break;
      case DOWN: time -= 600; break;
      case BACKSPACE: print("backspace\n"); break;
    }
  }
  //print(key, ": ", int(key), "\n");
  if(47 < int(key) && int(key) < 58 && selecting > -2) {
    if(selecting == -1) selecting = 0;
    if(10*selecting + int(key)-48 < no_of_vehicles) {
      selecting = 10*selecting + int(key)-48;
    }
      
    redraw();
    return;
  }
  switch(key) {
    case 10:
      if(selecting > -1) {
        if(selecting < no_of_vehicles) selected = selecting;
        selecting = -2;
      }
      break;
    case 8:
      if(selecting > -1) {
        selecting = selecting /10;
        if(selecting  == 0) selecting--;
      }
      break;
    //SPACE -> PAUSE
    case ' ': paused = !paused;
      break;
      
    // [, ] control framerate
    case ']': speed ++; break;
    case '[': speed --; break;
      
    // -, +(=) control zoom
    case '-':
      scale+=1;
      rerenderZoom(-1);
      break;
    case '=':
      if(scale > 1) {
        scale-=1;    
        rerenderZoom(1);
      }
      break;
      
    // A,W,S,D move the map
    case 'a': moved.x += 30; break;
    case 'd': moved.x -= 30; break;
    case 'w': moved.y += 15; break;
    case 's': moved.y -= 15; break;
    
    //1,2,3 controll if states are displayed
    case '1': show_states[0] = !show_states[0]; break;
    case '2': show_states[1] = !show_states[1]; break;
    case '3': show_states[2] = !show_states[2]; break;
    
    case 'e': show_dest = !show_dest; break;
    
    case 't': 
      if(trail_start == -1) trail_start = time;
      else {
        trail_start = -1;
      }
      break;
    
    case 'h':
      selecting = -1;
      break;
      
    case 'f': follow = ! follow; break;
    case 'r': 
      if(render) { 
        textSize(400);
        fill(255, 0, 0);
        text("R", width/2 - 170, height/2 + 150);
        noLoop();
      }
      else loop();
      render = !render;
      break; 
    
  }

}

void rerenderZoom(int sign) {
  
  int
    focus_point_x, 
    focus_point_y;
  
  if(follow && selected > -1) {
    focus_point_x = vehicles[selected].curr_position.x;
    focus_point_y = vehicles[selected].curr_position.y;
  } else {
    focus_point_x = mouseX - 50 - (int)moved.x;
    focus_point_y = mouseY - 50 - (int)moved.y;
  }
  //mouseX - 50 - moved.x
  
  moved.x += focus_point_x - ((scale+sign)*focus_point_x)/(scale);
  moved.y += focus_point_y - ((scale+sign)*focus_point_y) /(scale);
  
  map = createGraphics(map_width*9/scale, map_height*9/scale);

  renderManhattan();
}
