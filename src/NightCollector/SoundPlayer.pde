
public class SoundPlayer {
  // For music
  SoundFile music; // is null until fully loaded
  final String musicFileName = "sound/sound-ararat-deep.wav"; // Music from a band of mine: https://andreasmusic.ch/ararat-quintet
  final float startSpeed = 0.8;
  float speed;
  float musicVolume = 0.3;
  
  // For game sounds
  SoundFile soundCollect;
  SoundFile soundBomb;
  SoundFile soundMissed;
  SoundFile soundPowerUp;
  SoundFile soundMissedPowerUp;
  SoundFile soundGameOver;
  SoundFile soundStar; // for End-Screen
  
  // From https://freesound.org/people/Triper/sounds/115792 - Creative Commons 0 license
  final String soundCollectName = "sound/sound-collect.wav"; 
  // From https://freesound.org/people/Zangrutz/sounds/155235 - Attribution License: https://creativecommons.org/licenses/by/3.0/
  // Hereby attributed to author "Zangrutz"
  final String soundBombName = "sound/sound-bomb.wav";
  // From https://freesound.org/people/Raclure/sounds/405548 - Creative Commons 0 license
  final String soundMissedName = "sound/sound-missed.wav";
  // From https://freesound.org/people/GameAudio/sounds/220173 - Creative Commons 0 license
  final String soundPowerUpName = "sound/sound-powerup.wav";
  // From https://freesound.org/people/jhyland/sounds/539664 - Creative Commons 0 license
  final String soundMissedPowerUpName = "sound/sound-missed-powerup.wav";
  // From https://freesound.org/people/cabled_mess/sounds/350984 - Creative Commons 0 license
  final String soundGameOverName = "sound/sound-game-over.wav";
  // From https://freesound.org/people/GameAudio/sounds/220173 - Creative Commons 0 license
  final String soundStarName = "sound/sound-star.wav";
  
  void resetMusicSpeed() {
    speed = startSpeed;
    if (music != null) music.rate(speed);
  }
  
  void setMusicVolume() {
    if (music != null) music.amp(musicVolume); // change volume (1.0 is max, 0.0 is silence)
  }
  
  void startMusic() {
    if (music != null) soundPlayer.music.loop();
    soundPlayer.resetMusicSpeed();
    soundPlayer.setMusicVolume();
  }
  
  void updateMusicSpeed(float soundSpeedIncreaseFactor) {
    speed *= soundSpeedIncreaseFactor;
    if (music != null) music.rate(speed);
  }
}
