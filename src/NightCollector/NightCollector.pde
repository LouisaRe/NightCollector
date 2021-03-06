import processing.sound.*;

//GAME BALANCING PARAMETERS
//adjust as required
final float startGameSpeed            =  0.80;
final float gameSpeedIncreaseFactor   =  1.20;
final float soundSpeedIncreaseFactor  =  1.08;
final int   secondsUntilSpeedIncrease =    20; 
final int   startlifes                =     5;
final float startStarSpawnFactor      =  1500;
final float startPowerStarSpawnFactor =  8000;
final float startBombSpawnFactor      =  9000;
final int   secondsForOneStar         =    40;
final int   secondsForTwoStars        =    90;
final int   secondsForThreeStars      =   120;

//window
int windowWidth      = 1000;
int windowHeight     =  800;

//screen
Screen        currentScreen = Screen.START_SCREEN;
DrawFunctions drawFuncs     = new DrawFunctions();
boolean       clicked       = false;

//colors & fonts
color  bgColor1      = color(  7,  22,  62);
color  bgColor2      = color(196, 177, 161);
PFont  titleFont;
PFont  standardFont;

//stars
ArrayList<Star>      stars;
ArrayList<Star>      collectedStars;
float                millisBetweenStars;
int                  starTimer;
float                starSpawnFactor;


ArrayList<PowerStar> powerStars;
float                millisBetweenPowerStars;
int                  powerStarTimer;
float                powerStarSpawnFactor;

//bombs
ArrayList<Bomb>      bombs;
ArrayList<Bomb>      avoidedBombs;
float                millisBetweenBombs;
int                  bombTimer;
float                bombSpawnFactor;

//clouds
ArrayList<Cloud> clouds;

//basket
Basket basket;

//mountain
ArrayList<Mountain> mountains = new ArrayList<Mountain>();
Mountain mountain;

//ground
Ground ground;

//rating, lifes
int lifes;
int rating;
ProgressElements progressElements;

//time
int     startGameTime;
int     seconds;
boolean inNewSecond = false;

//sounds
SoundPlayer soundPlayer;
boolean     gameMusicLoaded = false;

//game speed
float gameSpeed;


void settings()
{
  soundPlayer        = new SoundPlayer();
  thread("loadMusicAsync"); // Execute method 'loadMusic' in a separate thread according to: https://processing.org/reference/thread_.html. Because this takes some seconds
  loadSounds(); // only small files, don't load asynchroniously
  
  size(windowWidth, windowHeight);  
  progressElements   = new ProgressElements("img/img-life.png", 20, "img/img-ratingStarUnfilled.png", "img/img-ratingStarFilled.png", 150, "img/img-stopWatch.png", 16.67);
  basket             = new Basket("img/img-basket.png", 100) ;
  ground             = new Ground();

  createMountains();
  starTimer          = millis();
  powerStarTimer     = millis();
  bombTimer          = millis();
}

void setup(){
  titleFont    = createFont("font/CURLZ___.TTF",80);
  standardFont = createFont("font/lucida sans regular.ttf", 18);
}


void draw(){
  
  switch(currentScreen){
    case START_SCREEN :
      drawFuncs.drawStartScreen();
      break;
    case GAME_SCREEN :
      drawFuncs.drawGameScreen();
      showIfMusicStillLoading();
      break;
    case END_SCREEN :
      drawFuncs.drawEndScreen();
      break;
  }  
}




void mouseReleased(){
  clicked = false;
}

void mousePressed(){
  clicked = true;
}


//############################################################
//Helper methods:

private void reset(){
  lifes           = startlifes;
  rating          = 0;
  seconds         = 0;
  startGameTime   = (int) (millis()*0.001f); //scaled time [ms] 
  gameSpeed       = startGameSpeed;
  stars           = new ArrayList<Star>();
  collectedStars  = new ArrayList<Star>();
  powerStars      = new ArrayList<PowerStar>();
  bombs           = new ArrayList<Bomb>();
  avoidedBombs    = new ArrayList<Bomb>();
  clouds          = new ArrayList<Cloud>();
  starSpawnFactor      = startStarSpawnFactor;
  powerStarSpawnFactor = startPowerStarSpawnFactor;
  bombSpawnFactor      = startBombSpawnFactor;
  millisBetweenStars      = starSpawnFactor      + random(starSpawnFactor);
  millisBetweenPowerStars = powerStarSpawnFactor + random(powerStarSpawnFactor);
  millisBetweenBombs      = bombSpawnFactor      + random(bombSpawnFactor);
  progressElements.resetRatingStarsAnimation();  
  thread("startMusicAsync");
}

private void createNewStar(){
  stars.add(new Star("img/img-star.png", 33));
}

private void createNewPowerStar(){
  powerStars.add(new PowerStar("img/img-powerStarTail.png", 33));
}

private void createNewBomb(){
  bombs.add(new Bomb("img/img-bomb.png", 27));
}

private void createNewCloud(){
  clouds.add(new Cloud("img/img-cloud.png", 392, random(500)));
}

private void createMountains(){
  mountains.add(       new Mountain(   0, windowHeight,    0, 400, 
                                     400, windowHeight,  300, 400));
  mountains.add(       new Mountain( 400, windowHeight,  500, 400, 
                                     800, windowHeight,  700, 450));
  mountains.add(       new Mountain( 200, windowHeight,  300, 600, 
                                     700, windowHeight,  600, 600));
  mountains.add(       new Mountain( 100, windowHeight,  100, 500, 
                                     550, windowHeight,  450, 500));
  mountains.add(       new Mountain( 600, windowHeight,  900, 500, 
                                    1500, windowHeight, 1200, 500));
  mountains.add(       new Mountain( 550, windowHeight,  550, 600, 
                                    1000, windowHeight,  950, 550));
}

//############################################################
//COLLISION DETECTION

private void updatePointsAndMissedlifes(){
  for(int i = 0; i < stars.size(); i = i+1){ //all stars
  
    if(stars.get(i).posY + stars.get(i).elementHeight >= basket.posY){  //y-position >= basket
       
       if(stars.get(i).posX + stars.get(i).elementWidth / 2 >= basket.posX &&
          stars.get(i).posX + stars.get(i).elementWidth / 2 <= basket.posX + basket.elementWidth) { //x-range same as basket
         
         if(!stars.get(i).missedCollision){
           
           soundPlayer.soundCollect.play(); //collision (correct x/y)
           collectedStars.add(stars.get(i));
           stars.remove(i);
         }
  
       }else{
         if(!stars.get(i).missedCollision){
           lifes = lifes - 1; //missed (correct y / incorrext x)
           stars.get(i).missedCollision = true;
           if(lifes <= 0){
             gameOver();
             return;
           } 
           soundPlayer.soundMissed.play();
         }
       }
    } else if (stars.get(i).posY > height) {
      // clean up star when out of screen:
      stars.remove(i);
    }
  }
}

private void updateWonlifes(){
  for(int i = 0; i < powerStars.size(); i = i+1){ //all powerStars
  
    if(powerStars.get(i).posY + powerStars.get(i).elementHeight >= basket.posY){  //y-position >= basket
       
       if(powerStars.get(i).posX + powerStars.get(i).elementWidth / 2 >= basket.posX &&
          powerStars.get(i).posX + powerStars.get(i).elementWidth / 2 <= basket.posX + basket.elementWidth){ //x-range same as basket
          
          if(!powerStars.get(i).missedCollision){
             soundPlayer.soundPowerUp.play(); //collision (correct x/y)
             lifes = lifes + 1;
             powerStars.remove(i);
          }
           
       }else{
         if(!powerStars.get(i).missedCollision) {
           soundPlayer.soundMissedPowerUp.play();
         }
         powerStars.get(i).missedCollision = true;  //missed (correct y / incorrext x)
       }
    } else if (powerStars.get(i).posY > height) {
      // clean up star when out of screen:
      powerStars.remove(i);
    }
  }
}

private void checkGameOver(){
  for(int i = 0; i < bombs.size(); i = i+1){ //all bombs
  
    if(bombs.get(i).posY + bombs.get(i).elementHeight >= basket.posY){  //y-position >= basket
       
       if(bombs.get(i).posX + bombs.get(i).elementWidth / 2 >= basket.posX &&
          bombs.get(i).posX + bombs.get(i).elementWidth / 2 <= basket.posX + basket.elementWidth){ //x-range same as basket
         
         if(!bombs.get(i).missedCollision){
           
             soundPlayer.soundBomb.play(); //collision (correct x/y)
             gameOver();
             return;
         }
       }else{
         if(!bombs.get(i).missedCollision){
           avoidedBombs.add(bombs.get(i));
         }
         bombs.get(i).missedCollision = true; //missed (correct y / incorrext x)
       }
    }
  }
}

//############################################################

private void gameOver(){
  currentScreen = Screen.END_SCREEN;
  if (soundPlayer.music != null) soundPlayer.music.stop();
  soundPlayer.soundGameOver.play();
}

private void updateRating(){
  if(     seconds < secondsForOneStar)    { rating = 0; }
  else if(seconds < secondsForTwoStars)   { rating = 1; }
  else if(seconds < secondsForThreeStars) { rating = 2; }
  else                                    { rating = 3; }
}

private void updateGameSpeed() {
  if (inNewSecond && seconds > 2 && seconds % secondsUntilSpeedIncrease == 0) {
    gameSpeed            *= gameSpeedIncreaseFactor;
    starSpawnFactor      /= gameSpeedIncreaseFactor;
    powerStarSpawnFactor /= gameSpeedIncreaseFactor;
    bombSpawnFactor      /= gameSpeedIncreaseFactor;
    //increase music speed with different factor:
    soundPlayer.updateMusicSpeed(soundSpeedIncreaseFactor);
  }
}

//############################################################
//MUSIC AND SOUNDS

private void showIfMusicStillLoading() {
  if (!gameMusicLoaded) {
    push();
    textSize(18);
    textAlign(CENTER);
    text("game-music is still loading...", windowWidth / 2, windowHeight - 20 - 2);
    pop();
  }
}

// Will run on a separate thread -- called by thread("loadMusicAsync");
// PROBLEM:  This works perfectly on different Mac systems, but NOT on 
//           any Windows 10-PCs (tried on 3 different computers)
// SOLUTION: We converted the music from mp3 to wav. Then Processing can load 
//           it very fast and we don't need anymore asynchronious loading.
void loadMusicAsync() {
  //soundPlayer.music = new SoundFile(this, soundPlayer.musicFileName);
}

// will run on a separate thread -- called by thread("startMusicAsync");
void startMusicAsync() {
  while (soundPlayer.music == null) {
    delay(100);
  }
  gameMusicLoaded = true;
  soundPlayer.startMusic();
}

private void loadSounds() {
  soundPlayer.music              = new SoundFile(this, soundPlayer.musicFileName);
  soundPlayer.soundCollect       = new SoundFile(this, soundPlayer.soundCollectName); 
  soundPlayer.soundBomb          = new SoundFile(this, soundPlayer.soundBombName); 
  soundPlayer.soundMissed        = new SoundFile(this, soundPlayer.soundMissedName); 
  soundPlayer.soundPowerUp       = new SoundFile(this, soundPlayer.soundPowerUpName); 
  soundPlayer.soundMissedPowerUp = new SoundFile(this, soundPlayer.soundMissedPowerUpName); 
  soundPlayer.soundGameOver      = new SoundFile(this, soundPlayer.soundGameOverName);
  soundPlayer.soundStar          = new SoundFile(this, soundPlayer.soundStarName);
  soundPlayer.soundMissedPowerUp.amp(0.5);  // otherwise this sound is too loud
}
