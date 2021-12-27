
public class SoundPlayer {
  SoundFile music; // is null until fully loaded
  String musicFileName = "sound-ararat-deep.mp3";
  float speed = 0.8;
  float volume = 0.3;
  
  
  void setMusicSpeed() {
    music.rate(speed);
  }
  
  void setMusicVolume() {
    music.amp(volume); // change volume (1.0 is max, 0.0 is silence)
  }
  
  void increaseMusicSpeed() {
    speed *= 1.05;
    music.rate(speed);
  }
}
