class Color {
  
  private int[] rgb = {255, 255, 255};
  
  Color () {}
  
  Color (int r, int g, int b) {
    this.setColor(r, g, b);
  }
  
  void setColor (int r, int g, int b) {
    this.rgb[0] = (r >= 0) ? r : 0;
    this.rgb[1] = (g >= 0) ? g : 0;
    this.rgb[2] = (b >= 0) ? b : 0;
  }
  
  int r () { return this.rgb[0]; }
  int g () { return this.rgb[1]; }
  int b () { return this.rgb[2]; }
}
  
