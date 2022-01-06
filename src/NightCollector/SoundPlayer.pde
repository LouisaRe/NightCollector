
public class SoundPlayer {
  // For music
  SoundFile music; // is null until fully loaded
  String musicFileName = "sound-ararat-deep.mp3"; // Music from a band of mine: https://andreasmusic.ch/ararat-quintet
  float speed;
  float volume = 0.3;
  
  // For game sounds
  SoundFile soundCollect;
  SoundFile soundBomb;
  
  // From https://freesound.org/people/Triper/sounds/115792 - Creative Commons 0 license
  String soundCollectName = "sound-collect-115792.wav"; 
  // From https://freesound.org/people/Zangrutz/sounds/155235 - Attribution License: https://creativecommons.org/licenses/by/3.0/
  // Hereby attributed to author "Zangrutz"
  String soundBombName = "sound-bomb-155235.wav";
  
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
