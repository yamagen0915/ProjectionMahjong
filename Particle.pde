class Particle {
  
  private static final int BORDER = 140;
  private static final int LIGHT_DISTANCE= BORDER * BORDER;
  private static final int LIGHT_FORCE_RATIO = 1;
  
  private static final int MIN_VELOCITY = 50;
  private static final int MAX_VELOCITY = 70;
  
  private final int DAMPING_RATIO = (int)random(1,3);
  
  private Color rgb = new Color();
  
  private int x, y;
  private int vx, vy;
  
  private int count;
  
  Particle () {
    this(0, 0, 0);
  }
  
  Particle (int x, int y, float rotate) {
    this.x = x;
    this.y = y;
    
    int v   = (int)random(MIN_VELOCITY, MAX_VELOCITY);
    this.vx = (int) (v * sin(rotate));
    this.vy = (int) (v * cos(rotate));
  } 
  
  void setColor (int r, int g, int b) {
    rgb.setColor(r, g, b);
  }
  
  void draw () {
    
    if (x < -BORDER || x > width+BORDER)  return;
    if (y < -BORDER || y > height+BORDER) return;
    
    count++;
    
    loadPixels();
    this.x += this.vx;
    this.y += this.vy;
    
    int damp = 1 + count/2;
    rgb.setColor(
      rgb.r() - (damp*damp)*DAMPING_RATIO,
      rgb.g() - (damp*damp)*DAMPING_RATIO,
      rgb.b() - (damp*damp)*DAMPING_RATIO
    );
 
    int left   = max(0      , this.x - BORDER);
    int right  = min(width  , this.x + BORDER);
    int top    = max(0      , this.y - BORDER);
    int bottom = min(height , this.y + BORDER);
    
    for (int y=top; y<bottom; y++) {
      for (int x=left; x<right;x++) {
        int pid = x + y * width;
 
        int r = pixels[pid] >> 16 & 0xFF;
        int g = pixels[pid] >> 8 & 0xFF;
        int b = pixels[pid] & 0xFF;
 
        int dx = x - this.x;
        int dy = y - this.y;
        int distance = (dx * dx) + (dy * dy);
 
        if (distance < LIGHT_DISTANCE) {
          int fixFistance = distance * LIGHT_FORCE_RATIO;
          if (fixFistance < 1)  fixFistance = 1;
          
          r = r + rgb.r()*rgb.r() / fixFistance;
          g = g + rgb.g()*rgb.g() / fixFistance;
          b = b + rgb.b()*rgb.b() / fixFistance;
        }
        
        pixels[pid] = color(r, g, b);
      }
    }
    
    updatePixels();
  }
}
