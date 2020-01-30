Visualizer visualizer = null;
Minim minim = null;
FilePlayer filePlayer = null;

void setup() {
  size(1200, 1200);
  
  minim = new Minim(this);
  filePlayer = new FilePlayer(minim.loadFileStream("example.mp3", 1024, false));
  visualizer = new Visualizer(minim, filePlayer);
  
  filePlayer.play();
}

void draw() {
  visualizer.draw();
}

void stop(){
  minim.stop();
  super.stop();
}
