class DrawFunctions{
  
  void drawStartScreen(){
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
    
    //ground
    ground.render();
    
    //button
    drawButton("Start collecting", Screen.GAME_SCREEN);
  }
  
  //############################################################
  
  void drawGameScreen(){
    
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
    
    //power stars
    if (millis() - powerStarTimer >= millisBetweenPowerStars) { //create a new power star after a certain time
      createNewPowerStar();
      millisBetweenPowerStars = 8000 + random(2000);
      powerStarTimer = millis();
    }
    for(int i = 0; i < powerStars.size(); i = i+1){ //existing stars
      powerStars.get(i).movePowerStar();
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
    updateWonLives();             // PowerStars
    updatePointsAndMissedLives(); //Stars
    checkGameOver();              //Bombs
    text("Zeit: " + seconds + " s" + "\n" + "Sternenstand: " + str(points) + "\n" + "Leben: " + str(lives) , width-200, 100);
    
    //
    updateMusic();  
    
    // cleanup at end of draw:
    inNewSecond = false;
  }
 
  //############################################################
  
  void drawEndScreen(){
    //background
    night();
    
    //mountains
    
    
    //ground
    ground.render();
  }
}




private void drawButton(String text, Screen nextScreen){
 
  int bWidth  = 400;
  int bHeight = 100;
  
  int x = width/2 - (bWidth/2);
  int y = height/2 - (bHeight/2);
  
  
  //rect
  if (mouseX>x && mouseY>y && mouseX<x+bWidth && mouseY<y+bHeight) { //hover
    if(clicked){
      currentScreen = nextScreen;
    }
    fill(#BE7EA2);
  }else{
    noFill();
  }
  stroke(#ffffff);
  rect(x,y,bWidth,bHeight, 8);
  
  //text
  fill(#ffffff);
  textSize(24);
  text(text, x + (bWidth/2) - (textWidth(text)/2), y + (bHeight/2) + (textAscent()/2));
}

private void drawMountains(){
  for(int i = 0; i < mountains.size(); i = i+1){
      
      float deltaXleft  =  0.5 * sin(millis()/((i+1)*1000)); //TODO: Connect movement to Audio
      float deltaYleft  = -0.2 * sin(millis()/((i+1)*1000));
      float deltaXright = -0.5 * sin(millis()/((i+1)*1000));
      float deltaYright = -0.2 * sin(millis()/((i+1)*1000));
      
      mountains.get(i).moveMountain(deltaXleft, deltaYleft, deltaXright, deltaYright);
    }
}
