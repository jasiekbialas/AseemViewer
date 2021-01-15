class Map {
  
  int N, edges = 0;
  Point[] vertices;
  PGraphics map_layer;
  
  ArrayList<Integer> edge_from = new ArrayList();
  ArrayList<Integer> edge_to = new ArrayList();
  
  Map(int n, String path) {
    this.N = n;
    vertices = new Point[N];
    String[] list;
    String line;
  
    try {
        BufferedReader reader = createReader(path);
        line = reader.readLine();
        float x, y;
        
        for(int i = 0; i < N; i++) {
          line = reader.readLine();
          list = split(line, "=");
          
          x = float(split(list[2], ",")[0]);
          y = float(split(list[3], ",")[0]);
    
          vertices[i] = transform(x, y);
        }
        
        int a, b;
        
        while(true) {
          line = reader.readLine();
          if(line.charAt(0) == '}') break;
          list = split(line, " ");
          a = int(split(list[0], "->")[0]);
          b = int(split(list[0], "->")[1]);
          edge_from.add(a);
          edge_to.add(b); 
          edges++;
        }
      
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
  }
  
  
  void renderMap() {
    
    map_layer = createGraphics(map_width*9/scale, map_height*9/scale);
    int a,b;
    map_layer.beginDraw();
    map_layer.clear();
    map_layer.stroke(100);
    map_layer.strokeWeight(min(1, 9/scale));
    
    for(int i = 0; i < edges; i++) {
      a = edge_from.get(i);
      b = edge_to.get(i);
      map_layer.line(
        vertices[a].x/scale,
        vertices[a].y/scale,
        vertices[b].x/scale,
        vertices[b].y/scale
      );
    }
    
    map_layer.endDraw();
  }
  
  void displayMap() {
    image(map_layer, 50+moved.x, 50+moved.y);
  }
}
