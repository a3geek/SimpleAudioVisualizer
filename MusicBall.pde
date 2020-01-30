public class MusicBall {
  private final float Diameter = 2.5f;
  
  private float vx;
  private float vy;
  private float x;
  private float y;
  private float s;
  private float level;
  
  
  public MusicBall() {
    this.vx = random(-1f, 1f);
    this.vy = random(-1f, 1f);
    this.x = random(width);
    this.y = random(height);
    
    int s = width < height ? width : height;
    this.s = random(0.1 * s, s);
    this.level = 0f;
  }
  
  /// ボールを表示
  public void draw(float level) {
    this.level = this.lerp(this.level, level, 0.5f);
    float s = Diameter + this.s * this.level * 0.05f;
    ellipse(this.x, this.y, s, s);

    this.x += this.vx * (1f + level);
    this.y += this.vy * (1f + level);

    if (this.x > width || this.x < 0f) {
      this.vx = -this.vx;
    }
    if (this.y > height || this.y < 0f) {
      this.vy = -this.vy;
    }
  }
  
  private float lerp(float start, float end, float t) {
    return (1f - t) * start  + t * end;
  }
}
