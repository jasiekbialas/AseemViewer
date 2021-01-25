PVector center = new PVector(900, 300);

class Vehicle {
  
  ArrayList<Integer> times = new ArrayList();
  ArrayList<Point> positions = new ArrayList();
  ArrayList<Integer> states = new ArrayList();
  ArrayList<Point> destinations = new ArrayList();
  
  ArrayList<String> messages = new ArrayList();
  
  
  Point 
  curr_position = new Point(-1, -1),
  curr_dest = null;
  
  int id, index, curr_state = 0;
  
  String curr_m = "";
  
  Vehicle(int id) {
    this.id = id;
  }
  
  void add(int t, Point position, Point dest, int s, String m) {
    times.add(t);
    positions.add(position);
    states.add(s);
    destinations.add(dest);
    messages.add(m);
  }
  
  void update(int t) {
    while(t < times.get(index)) {
      if(index == 0) break;
      index -= 1;
    }
    if(index+1 >= times.size()) index = times.size()-2;
    
    while(t >= times.get(index+1)) {
      if(index+2 >= times.size()) break;
      index +=1;
    }
    
    float a = (float)(t - times.get(index)) / (float)(times.get(index+1) - times.get(index));
    
    
    curr_position = new Point(positions.get(index+1));
    curr_position.sub(positions.get(index));
    curr_position.mult(a);
    curr_position.add(positions.get(index));
    
    curr_position.div(scale);
    
    curr_position.add(moved);
    curr_state = states.get(index);
    
    if(destinations.get(index) != null) {
      curr_dest = new Point(destinations.get(index));
      curr_dest.div(scale);
      curr_dest.add(moved);
    } else {
      curr_dest = null;
    }
    curr_m = messages.get(index);
  }
  
  void draw(PGraphics layer) {
    if(curr_position.x < 0 || curr_position.y > map_width || curr_position.y < 0 || curr_position.y > map_height) return;
    
    setColour(layer, curr_state);

    if(show_dest) {
      if(curr_dest != null) {
        if(selected == id) layer.strokeWeight(1);
        else layer.strokeWeight(0.2);
        layer.line(curr_position.x, curr_position.y, curr_dest.x, curr_dest.y);
      }
    }
    
    layer.circle(curr_position.x, curr_position.y, 5+9/scale);
  }
  
  void drawTrail(PGraphics layer, int st) {
    int tind = 0;
    Point last;
    
    while(times.get(tind) < st) {
      tind++;
    }
    if(tind > index) return;
    
    last = positions.get(tind);
    
    setColour(layer, states.get(tind));
    
    tind++;
    
    layer.beginDraw();
    while(times.get(tind) < time) {
      
      layer.strokeWeight(3 + 3/scale);
      layer.line(last.x/scale + moved.x, last.y/scale + moved.y, positions.get(tind).x/scale+moved.x, positions.get(tind).y/scale+moved.y);
      
      layer.strokeWeight(1 + 3/scale);
      layer.stroke(255);
      layer.circle(last.x/scale+moved.x, last.y/scale+moved.y, 5 + 9/scale);
      
      last = new Point(positions.get(tind));
      
      setColour(layer, states.get(tind));
      
      tind++;
      
    }
    layer.stroke(255);
    layer.circle(last.x/scale+moved.x, last.y/scale+moved.y, 5 + 9/scale);
    layer.strokeWeight(3 + 3/scale);
    
    setColour(layer, curr_state);
     
    layer.line(last.x/scale +moved.x, last.y/scale + moved.y, curr_position.x, curr_position.y);
    
  }
}

Point last;

void initVehicles() {
  String line, msg_type, state_str;
  int log_time, id;
  
  BufferedReader reader = createReader("data/"+proj_name+"/logs.v");
  
  JSONObject log, position;
  int state;
  
  Point pv, dest;
  
  Point[] curr_position = new Point[no_of_vehicles];
  for(int i = 0; i < no_of_vehicles; i++) {
    vehicles[i] = new Vehicle(i);
  }
  
  try {   
    while((line = reader.readLine()) != null) {

      log = parseJSONObject(line);
      log_time = log.getInt("CreatedAtTimestamp")*10;
      
      if(time > log_time) {
        time = log_time;
      }
      
      
      msg_type = log.getString("MsgType");
     
      if(msg_type.equals("FleetMessages.BookingRequest") ) {
        
        position = log.getJSONObject("Origin");
        //events.add(new BookingRequest(time, position.getInt("X"), position.getInt("Y")));
      
      } else if(msg_type.equals("FleetMessages.VehicleStatus") || msg_type.equals("FleetMessages.VehicleInit")) {
        
        id = log.getInt("VehicleID");
        position = log.getJSONObject("Location");
        
        pv = transform(position.getFloat("X"), position.getFloat("Y"));

        state_str = log.getString("VehicleState");
        state = 0;
        
        if(state_str.equals("Available")) {
          state = 0;
        } else if (state_str.equals("EnrouteToPickup")) {
          state = 1;
        } else if(state_str.equals("EnrouteToDropoff")) {
          state = 2;
        } else if(state_str.equals("ArrivedAtPickup")) {
          state = 3;
        } else if(state_str.equals("ArrivedAtDropoff")) {
          state = 4;
        }
        
        if(msg_type.equals("FleetMessages.VehicleInit")) {
          dest = null;
        } else {
          position = log.getJSONObject("GoalLocation");
          if(position.getFloat("X") +  position.getFloat("Y") == 0) {
            dest = null;
          } else {
            dest = transform(position.getFloat("X"), position.getFloat("Y"));
          }
        }
        
          
         vehicles[id].add(log_time, pv, dest, state, line);
         curr_position[id] = new Point(pv);

      }
    }
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  vehicles_loaded = true;
}

       //if(id == 1681) {
       //   if(log_time > 433700 && log_time < 434400) {
       //     print(line, "\n");
       //     print(pv.x, " ", pv.y, "\n\n");
       //   }
       //   map.beginDraw();
       //   if(last != null) {         
       //     map.stroke(255, 0, 0);
       //     map.strokeWeight(2);
       //     map.fill(0, 0, 255); 
       //     map.line(pv.x/scale, pv.y/scale, last.x/scale, last.y/scale);
       //     map.strokeWeight(1);
       //     map.stroke(255);
       //     map.circle(last.x/scale, last.y/scale, 5);
       //   }
       //   last = new Point(pv);
       //   map.endDraw();
       // }
