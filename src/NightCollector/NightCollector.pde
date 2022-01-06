import processing.sound.*;

//window
int windowWidth      = 1000;
int windowHeight     =  800;

//screen
Screen        currentScreen = Screen.START_SCREEN;
DrawFunctions drawFuncs     = new DrawFunctions();
boolean       clicked       = false;

//colors
color  bgColor1      = color(  7,  22,  62);
color  bgColor2      = color(196, 177, 161);

//stars
ArrayList<Star>      stars;
ArrayList<Star>      collectedStars;
float                millisBetweenStars;
int                  starTimer;

ArrayList<PowerStar> powerStars;
float                millisBetweenPowerStars;
int                  powerStarTimer;

//bombs
ArrayList<Bomb>      bombs;
float                millisBetweenBombs;
int                  bombTimer;

//clouds
ArrayList<Cloud> clouds;

//basket
Basket basket;

//mountain
ArrayList<Mountain> mountains = new ArrayList<Mountain>();
Mountain mountain;

//ground
Ground ground;

//rating, lives
int lives;
int rating;
ProgressElements progressElements;

//time
int     seconds;
boolean inNewSecond = false;

//sounds
SoundPlayer soundPlayer;
int secondsUntilSpeedIncrease = 5;


void settings()
{
  soundPlayer        = new SoundPlayer();
  thread("loadMusicAsync"); // Execute method 'loadMusic' in a separate thread according to: https://processing.org/reference/thread_.html. Because this takes some seconds
  loadSounds(); // only small files, don't load asynchroniously
  
  reset();
  
  size(windowWidth, windowHeight);  
  progressElements   = new ProgressElements("life.png", 20, "ratingStarUnfilled.png", "ratingStarFilled.png", 150, "stopWatch.png", 16.67);
  basket             = new Basket("basket.png", 100) ;
  ground             = new Ground();
  createNewStar();
  createNewCloud();
  createMountains();
  starTimer          = millis();
  powerStarTimer     = millis();
  bombTimer          = millis();
  millisBetweenStars =  1000 + random( 1000);
  millisBetweenPowerStars = 4000 + random(1000);
  millisBetweenBombs = 10000 + random(10000);
}

private void reset(){
  lives             = 5;
  rating            = 0;
  seconds           = 0;
  soundPlayer.speed = 0.8;
  stars             = new ArrayList<Star>();
  collectedStars    = new ArrayList<Star>();
  powerStars        = new ArrayList<PowerStar>();
  bombs             = new ArrayList<Bomb>();
  clouds            = new ArrayList<Cloud>();
}


void draw(){
  
  switch(currentScreen){
    case START_SCREEN :
      drawFuncs.drawStartScreen();
      break;
    case GAME_SCREEN :
      drawFuncs.drawGameScreen();
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

//helper functions:
//############################################################

private void createNewStar(){
  stars.add(new Star("star.png", 33));
}

private void createNewPowerStar(){
  powerStars.add(new PowerStar("powerStarTail.png", 33));
}

private void createNewBomb(){
  bombs.add(new Bomb("bomb.png", 27));
}

private void createNewCloud(){
  clouds.add(new Cloud("cloud.png", 392, random(500)));
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

private void verticalGradient(int x, int y, float width, float height, color color1, color color2){
  for (int i = y; i <= y+height; i++) { //from top row to bottom row
  
      float colMixRatio  = map(i, y, y+height, 0, 1); //increasing values between 0 & 1
      color mixedCol     = lerpColor(color1, color2, colMixRatio);
      stroke(mixedCol);
      line(x, i, x+width, i);
    }
}

private void updatePointsAndMissedLives(){
  for(int i = 0; i < stars.size(); i = i+1){ //all stars
  
    if(stars.get(i).posY + stars.get(i).elementHeight >= basket.posY &&
       stars.get(i).posY + stars.get(i).elementHeight <= height){  //y-position >= basket
       
       if(stars.get(i).posX                             >= basket.posX &&
          stars.get(i).posX + stars.get(i).elementWidth <= basket.posX + basket.elementWidth){ //same x-position as basket
         
         if(!stars.get(i).missedCollision){
           
           soundPlayer.soundCollect.play(); //collision (correct x/y)
           collectedStars.add(stars.get(i));
           stars.remove(i);
         }
  
       }else{
         if(!stars.get(i).missedCollision){
           
           lives = lives - 1; //missed (correct y / incorrext x)
           stars.get(i).missedCollision = true;
           if(lives <= 0){
             currentScreen = Screen.END_SCREEN; //game over
           }
         }
       }
    }
  }
}

private void updateWonLives(){
  for(int i = 0; i < powerStars.size(); i = i+1){ //all powerStars
  
    if(powerStars.get(i).posY + powerStars.get(i).elementHeight >= basket.posY &&
       powerStars.get(i).posY + powerStars.get(i).elementHeight <= height){  //y-position >= basket
       
       if(powerStars.get(i).posX                                  >= basket.posX &&
          powerStars.get(i).posX + powerStars.get(i).elementWidth <= basket.posX + basket.elementWidth){ //same x-position as basket
          
          if(!powerStars.get(i).missedCollision){
         
             soundPlayer.soundBomb.play(); //collision (correct x/y) //TODO: Change sound
             lives = lives + 1;
             powerStars.remove(i);
          }
           
       }else{
         powerStars.get(i).missedCollision = true;  //missed (correct y / incorrext x)
       }
    }
  }
}

private void checkGameOver(){
  for(int i = 0; i < bombs.size(); i = i+1){ //all bombs
  
    if(bombs.get(i).posY + bombs.get(i).elementHeight >= basket.posY &&
       bombs.get(i).posY + bombs.get(i).elementHeight <= height){  //y-position >= basket
       
       if(bombs.get(i).posX                             >= basket.posX &&
          bombs.get(i).posX + bombs.get(i).elementWidth <= basket.posX + basket.elementWidth){ //same x-position as basket
         
         if(!bombs.get(i).missedCollision){
           
             soundPlayer.soundBomb.play(); //collision (correct x/y)
             currentScreen = Screen.END_SCREEN; //gmae over
         }
       }else{
         bombs.get(i).missedCollision = true; //missed (correct y / incorrext x)
       }
    }
  }
}

private void updateRating(){
  
  if(seconds < 60){
    rating = 0;
  }
  else if(seconds < 120){
    rating = 1;
  }
  else if(seconds < 180){
    rating = 2;
  }
  else{
    rating = 3;
  }
  
}

private void updateMusic() {
  if(soundPlayer.music == null) {
    textSize(18);
    text("game-music is loading (" + seconds + ")...", 20, windowHeight - 20); 
  } else {
    if (inNewSecond 
        && seconds > 11
        && seconds % secondsUntilSpeedIncrease == 0) {
          soundPlayer.increaseMusicSpeed();
        }
  }
}

// will run on a separate thread -- called by thread("loadMusicAsync");
void loadMusicAsync() {
  soundPlayer.music = new SoundFile(this, soundPlayer.musicFileName);
  soundPlayer.music.loop();
  soundPlayer.setMusicSpeed();
  soundPlayer.setMusicVolume();
}

void loadSounds() {
  soundPlayer.soundCollect = new SoundFile(this, soundPlayer.soundCollectName); 
  soundPlayer.soundBomb = new SoundFile(this, soundPlayer.soundBombName); 
}
