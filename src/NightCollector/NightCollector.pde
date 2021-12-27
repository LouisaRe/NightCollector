import processing.sound.*;

//window
int windowWidth    = 1000;
int windowHeight   =  800;

//colors
color  bgColor1    = color(  7,  22,  62);
color  bgColor2    = color(196, 177, 161);
void   night()     {verticalGradient(0, 0, width, height, bgColor1, bgColor2);}

//stars
ArrayList<Star>  stars          = new ArrayList<Star>();
ArrayList<Star>  collectedStars = new ArrayList<Star>();
float            millisBetweenStars;
int              starTimer;

//bombs
ArrayList<Bomb>  bombs          = new ArrayList<Bomb>();
ArrayList<Bomb>  collectedBombs = new ArrayList<Bomb>();
float            millisBetweenBombs;
int              bombTimer;

//clouds
ArrayList<Cloud> clouds = new ArrayList<Cloud>();

//basket
Basket basket;

//mountain
ArrayList<Mountain> mountains = new ArrayList<Mountain>();
Mountain mountain;

//ground
Ground ground;

//points, lives
int points   = 0;
int lives;

// time
int seconds = 0;
boolean inNewSecond = false;

//sounds
SoundPlayer soundPlayer;
int secondsUntilSpeedIncrease = 5;


void settings()
{
  size(windowWidth, windowHeight);  
  lives              = 5;
  basket             = new Basket("basket.png", 100) ;
  ground             = new Ground();
  createNewStar();
  createNewCloud();
  createMountains();
  starTimer          = millis();
  bombTimer          = millis();
  millisBetweenStars =  1000 + random( 1000);
  millisBetweenBombs = 10000 + random(10000);
  
  soundPlayer = new SoundPlayer();
  // Execute method 'loadMusic' in a separate thread
  // according to: https://processing.org/reference/thread_.html
  // Because this takes some seconds
  thread("loadMusicAsync");
}



void draw(){
  float playTime = millis()*0.001f; //scaled time [ms]
  
  // TODO: maybe replace playTime completely by seconds:
  // Update seconds ONLY once per second:
  if ((int) playTime > seconds) {
      seconds++;
      inNewSecond = true;
  }

  
  //background
  night();
  
  
  //mountains
  for(int i = 0; i < mountains.size(); i = i+1){
    
    float deltaXleft  =  0.5 * sin(millis()/((i+1)*1000)); //TODO: Connect movement to Audio
    float deltaYleft  = -0.2 * sin(millis()/((i+1)*1000));
    float deltaXright = -0.5 * sin(millis()/((i+1)*1000));
    float deltaYright = -0.2 * sin(millis()/((i+1)*1000));
    
    mountains.get(i).moveMountain(deltaXleft, deltaYleft, deltaXright, deltaYright);
  }
  
  //stars
  if (millis() - starTimer >= millisBetweenStars) { //create a new star after a certain time
    createNewStar();
    millisBetweenStars = 1000 + random(1000);
    starTimer = millis();
  }
  for(int i = 0; i < stars.size(); i = i+1){ //existing stars
    stars.get(i).moveStar();
  }
  
  //bombs
  if (millis() - bombTimer >= millisBetweenBombs) { //create a new bomb after a certain time
    createNewBomb();
    millisBetweenBombs = 10000 + random(10000);
    bombTimer = millis();
  }
  for(int i = 0; i < bombs.size(); i = i+1){ //existing stars
    bombs.get(i).moveBomb();
  }
  
  //ground
  ground.render();
  
  //basket
  basket.moveBasket();
  
  //clouds
  if (playTime % 5 <= 0.01) { //create a new cloud after a certain time
    createNewCloud();
  }
  for(int i = 0; i < clouds.size(); i = i+1){ //existing clouds
    clouds.get(i).moveCloud(playTime, i%3);
  }

  //points & lives
  updatePoints();
  updateLives();
  text("Zeit: " + seconds + " s" + "\n" + "Sternenstand: " + str(points) + "\n" + "Leben: " + str(lives) , width-200, 100);
  
  //
  updateMusic();  
  
  // cleanup at end of draw:
  inNewSecond = false;
}


//helper functions:
//############################################################

private void createNewStar(){
  stars.add(new Star("star.png", 33));
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

private void updatePoints(){
  for(int i = 0; i < stars.size(); i = i+1){ //all stars
  
    if(stars.get(i).starPosY + stars.get(i).starHeight >= basket.basketPosY &&
       stars.get(i).starPosY + stars.get(i).starHeight <= height){  //y-position >= basket
       
       if(stars.get(i).starPosX                          >= basket.basketPosX &&
          stars.get(i).starPosX + stars.get(i).starWidth <= basket.basketPosX + basket.basketWidth){ //same x-position as basket
         
           if(!stars.get(i).missedStar){ //star was not rated yet
             points = points + 1;
             collectedStars.add(stars.get(i));
             stars.remove(i);
           }
           
       }else{
         stars.get(i).missedStar = true;
       }
    }
    
  }
}

private void updateLives(){
  for(int i = 0; i < bombs.size(); i = i+1){ //all stars
  
    if(bombs.get(i).bombPosY + bombs.get(i).bombHeight >= basket.basketPosY &&
       bombs.get(i).bombPosY + bombs.get(i).bombHeight <= height){  //y-position >= basket
       
       if(bombs.get(i).bombPosX                          >= basket.basketPosX &&
          bombs.get(i).bombPosX + bombs.get(i).bombWidth <= basket.basketPosX + basket.basketWidth){ //same x-position as basket
         
           if(!bombs.get(i).missedBomb){ //bomb was not rated yet
             lives = lives - 1;
             collectedBombs.add(bombs.get(i));
             bombs.remove(i);
             
             if(lives == 0){
               // todo stop all and show game over text
             }
           }
           
       }else{
         bombs.get(i).missedBomb = true;
       }
    }
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
