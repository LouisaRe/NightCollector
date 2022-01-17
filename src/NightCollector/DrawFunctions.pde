class DrawFunctions{
  
  void drawStartScreen(){
    
    cursor(ARROW);
    
    //background
    night();
    
    //mountains
    drawMountains();
    
    //ground
    ground.render();
    
    //title
    textFont(titleFont);
    text("Night-"   , width/2 - (textWidth("Night-")   /2), 220 - (textAscent()/2));
    text("Collector", width/2 - (textWidth("Collector")/2), 220 + (textAscent()/2) + 10);
    textFont(standardFont);
    
    //button
    drawButton("Start collecting", Screen.GAME_SCREEN);
  }
  
  //############################################################
  
  void drawGameScreen(){
    
    if (mouseY<50 || mouseY>height-50){ //mouse almost out of window
      cursor(CROSS);
    }else{
     noCursor();
    }
  
    float playTime = millis()*0.001f; //scaled time
    // Update seconds ONLY once per second:
    if ((int) playTime - startGameTime > seconds) {
        seconds++;
        inNewSecond = true;
    }
  
    //background
    night();
    
    //mountains
    drawMountains();
    
    //stars
    if (millis() - starTimer >= millisBetweenStars) { //create a new star after a certain time
      createNewStar();
      millisBetweenStars = starSpawnFactor + random(starSpawnFactor);
      starTimer = millis();
    }
    for(int i = 0; i < stars.size(); i = i+1){ //existing stars
      stars.get(i).moveStar();
    }
    
    //power stars
    if (millis() - powerStarTimer >= millisBetweenPowerStars) { //create a new power star after a certain time
      createNewPowerStar();
      millisBetweenPowerStars = powerStarSpawnFactor + random(powerStarSpawnFactor);
      powerStarTimer = millis();
    }
    for(int i = 0; i < powerStars.size(); i = i+1){ //existing stars
      powerStars.get(i).movePowerStar();
    }
    
    //bombs
    if (millis() - bombTimer >= millisBetweenBombs) { //create a new bomb after a certain time
      createNewBomb();
      millisBetweenBombs = bombSpawnFactor + random(bombSpawnFactor);
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
    updateWonLives();             // PowerStars
    updatePointsAndMissedLives(); // Stars
    checkGameOver();              // Bombs
    progressElements.showLives();
    progressElements.showTime();
    
    //game speed (increases over time)
    updateGameSpeed();  
    
    // cleanup at end of draw:
    inNewSecond = false;
  }
 
  //############################################################
  
  void drawEndScreen(){
    
    cursor(ARROW);
    
    //background
    night();
    
    //mountains
    drawMountains();
    
    //ground
    ground.render();
    
    //rating
    updateRating();
    progressElements.showRatingStars();
    
    //button
    drawButton("Try again", Screen.GAME_SCREEN);
    
    //stats
    progressElements.showEndStats();
  }
}


private void night(){
  //sky
  verticalGradient(0, 0, width, height, bgColor1, bgColor2);
  
  //moon
  int moonWidth = 150;
  fill(#ffffff);
  circle(width-moonWidth, moonWidth, moonWidth);
}

private void drawButton(String text, Screen nextScreen){
 
  int bWidth  = 400;
  int bHeight = 100;
  
  int x = width/2 - (bWidth/2);
  int y = height/2 - (bHeight/2);
  
  
  //rect  
  //idea from https://stackoverflow.com/questions/21608367/processing-a-simple-button
  if (mouseX>x && mouseY>y && mouseX<x+bWidth && mouseY<y+bHeight) { //hover
    if(clicked){
      if(nextScreen == Screen.GAME_SCREEN){
        reset();
      }
      currentScreen = nextScreen;
    }
    fill(#BE7EA2);
  }else{ //no hover
    noFill();
  }
  stroke(#ffffff);
  rect(x,y,bWidth,bHeight, 8);
  
  //text
  fill(#ffffff);
  textSize(24);
  text(text, x + (bWidth/2) - (textWidth(text)/2), y + (bHeight/2) + (textAscent()/2));
  textSize(18);
}

private void drawMountains(){
  for(int i = 0; i < mountains.size(); i = i+1){
      
      float deltaXleft  =  0.5 * sin(millis()/((i+1)*1000));
      float deltaYleft  = -0.2 * sin(millis()/((i+1)*1000));
      float deltaXright = -0.5 * sin(millis()/((i+1)*1000));
      float deltaYright = -0.2 * sin(millis()/((i+1)*1000));
      
      mountains.get(i).moveMountain(deltaXleft, deltaYleft, deltaXright, deltaYright);
    }
}

// adopted from https://processing.org/examples/lineargradient.html
private void verticalGradient(int x, int y, float width, float height, color color1, color color2){
  for (int i = y; i <= y+height; i++) { //from top row to bottom row
  
      float colMixRatio  = map(i, y, y+height, 0, 1); //increasing values between 0 & 1
      color mixedCol     = lerpColor(color1, color2, colMixRatio);
      stroke(mixedCol);
      line(x, i, x+width, i);
    }
}
