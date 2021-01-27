import java.util.regex.Pattern;

class Map {
  
  int edges = 0;

  PGraphics map_layer;
  
  Pattern pattern = Pattern.compile("^[0-9].*->[0-9].*$");
  
  ArrayList<Integer> edge_from = new ArrayList();
  ArrayList<Integer> edge_to = new ArrayList();
  ArrayList<Point> vertices = new ArrayList();
  ArrayList<Float> xs = new ArrayList();
  ArrayList<Float> ys = new ArrayList();
  
  
  Map(String path) {

    String[] list;
    String line;
    
    float 
      c = cos(angle),
      s = sin(angle),
      buff;
   
  
    try {
        BufferedReader reader = createReader(path);
        line = reader.readLine();
        line = reader.readLine();

        float x, y;
        while(!pattern.matcher(line).matches()) {

          list = split(line, "=");
          
          x = int(split(list[2], ",")[0]);
          y = int(split(list[3], ",")[0]);
          
          if(x < fmin_x) fmin_x = x;
          if(y < fmin_y) fmin_y = y;
          
          xs.add(x);
          ys.add(y);
          line = reader.readLine();
        }
        
        for(int i = 0; i < xs.size(); i++) {

          x = xs.get(i);
          y = ys.get(i);
          
          x -= fmin_x;
          y -= fmin_y;
          
          buff = c*x-s*y;
          y = s*x + c*y;
          x = buff;
         
          if(x < min_x) min_x = x;
          if(x > max_x) max_x = x;
          if(y < min_y) min_y = y;
          if(y > max_y) max_y = y;
          
          xs.set(i, x);
          ys.set(i, y);
        }
        zoom_adj = map_height*100/int(max_y - min_y);
        if(zoom_adj > map_width*100/int(max_x - min_x)) zoom_adj = map_width*100/int(max_x - min_x);
       
        for(int i = 0; i < xs.size(); i++) {
          vertices.add(i, new Point(int(xs.get(i) - min_x)*zoom_adj, int(ys.get(i)-min_y)*zoom_adj) );
        }
        
        println(min_x, max_x);
        
        int a, b;
        
        while(true) {
          if(line.charAt(0) == '}') break;
          list = split(line, " ");
          a = int(split(list[0], "->")[0]);
          b = int(split(list[0], "->")[1]);
          edge_from.add(a);
          edge_to.add(b); 
          edges++;
          line = reader.readLine();
        }
      
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
  }
  
  
  void renderMap() {
    
    int w = width;
    int h = height;
    int x1, y1, x2, y2;
    if(scale > 40) {
      w = int(max_x - min_x)*zoom_adj/scale;
      h = int(max_y - min_y)*zoom_adj/scale;
    }

    
    map_layer = createGraphics(w, h);
    println("map:", w, h);
    
    Point a,b;
    
    map_layer.beginDraw();
    map_layer.clear();
    map_layer.stroke(100);
    map_layer.strokeWeight(min(1, 100/scale));
    
    //map_layer.textSize(10);
    //map_layer.stroke(0);
    //map_layer.fill(0);
    
    //for(int i = 0; i < N; i++) {
    //   print(i,": ", vertices[i].x, " - ", vertices[i].y, "\n");
    //   map_layer.text(str(i), vertices[i].x/scale, vertices[i].y/scale);
    //}
    for(int i = 0; i < edges; i++) {
      a = new Point(vertices.get(edge_from.get(i)));
      b = new Point(vertices.get(edge_to.get(i)));
      a.div(scale);
      b.div(scale);
      
      if(scale > 40) {

      } else {
        a.add(moved);
        b.add(moved);
        
        if(
          !a.withinRectangle(-50, -50, map_width+50, map_height+50) &&
          !b.withinRectangle(-50, -50, map_width+50, map_height+50)
          ) continue;
      }
      map_layer.line(
          a.x,
          a.y,
          b.x,
          b.y
        );
      //map_layer.text(str(i), 
      //  (vertices[a].x + vertices[b].x)/(2*scale), 
      //  (vertices[b].y + vertices[a].y)/(2*scale));
    }
    
    map_layer.endDraw();
  }
  
  void displayMap() {
    if(scale <= 40) {
      renderMap(); 
      image(map_layer, 50, 50);
    } else {
      image(map_layer, 50+moved.x, 50+moved.y);
    }
    
  }
}
