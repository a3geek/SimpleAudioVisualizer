import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

public class Visualizer {
  public final int FftOffset = 128;

  private AudioOutput output = null;
  private FilePlayer filePlayer = null;
  private FFT fft = null;
  private ArrayList<MusicBall> musicBalls = new ArrayList<MusicBall>();


  public Visualizer(Minim minim, FilePlayer filePlayer) {
    this.filePlayer = filePlayer;
    this.output = minim.getLineOut();
    filePlayer.patch(this.output);

    // setup FFT
    this.fft = new FFT(this.output.bufferSize(), this.output.sampleRate());
    this.fft.window(FFT.HAMMING);

    println("buffer size: " + output.bufferSize());
    println("sample rate: " + output.sampleRate());

    for (int i = 0; i< this.fft.specSize() - this.FftOffset; i++) {
      musicBalls.add(new MusicBall());
    }
  }

  /// オーディオビジュアライザーを表示
  public void draw() {
    background(0);

    this.fft.forward(output.mix);

    float min = 999999f;
    float max = 0f;
    int size = this.fft.specSize() - this.FftOffset;
    for (int i = 0; i < size; i++) {
      float value = this.fft.getBand(i);

      if (value < min) {
        min = value;
      } else if (value > max) {
        max = value;
      }
    }

    colorMode(HSB);
    strokeWeight(0);
    
    PVector center = new PVector(0.5f * width, 0.5f * height);
    for (int i = 0; i < size; i++) {
      float hue = map(i, 0, size, 0, 255);
      
      fill(hue, 255, min + max == 0f ? hue : map(this.fft.getBand(i), min, max, 128f, 255f));
      musicBalls.get(i).draw(min + max == 0f ? 0f : map(this.fft.getBand(i), min, max, 0f, 1f));
    }
    
    strokeWeight(2);
    for (int i = 0; i < size; i++) {
      float angle = map(i, 0, size, 0f, 2f * PI) - 0.5 * PI;
      float hue = map(i, 0, size, 0, 255);

      PVector p1 = PVector.fromAngle(angle).mult(100.0f).add(center);
      PVector p2 = PVector.mult(PVector.sub(p1, center), 
        min + max == 0f ? 1f : map(this.fft.getBand(i), min, max, 1f, 4f)
        ).add(center);

      stroke(hue, 255, 255);
      line(p1.x, p1.y, p2.x, p2.y);
    }

    colorMode(RGB);
    stroke(255, 0, 0);
    fill(255, 0, 0);
    drawPlayPosition();
  }
  
  /// 再生中の音楽のプログレスバーを表示
  private void drawPlayPosition() {
    float songPos = map(this.filePlayer.position(), 0, this.filePlayer.length(), 0, width);
    rect(0f, 0f, songPos, 5f);
  }
}
