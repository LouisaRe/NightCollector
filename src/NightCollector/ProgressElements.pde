class ProgressElements{
  
  private PImage live;
  private float  liveWidth;
  private float  liveHeight;
  
  private PImage unfilledStar;
  private PImage filledStar;
  private float  starSize;
  
  private PImage time;
  private float  timeWidth;
  private float  timeHeight;
  
  private int       ratingStarsAnimationState = 0;
  private int       ratingStarsAnimationStartTime;
  private boolean[] starsFilled = {false, false, false};
  
  
  ProgressElements(String liveFileName, float liveWidth, String unfilledStarFileName, String filledStarFileName, float starSize, String timeFileName, float timeWidth){
    this.live          = loadImage(liveFileName);
    this.liveWidth     = liveWidth;
    this.liveHeight    = liveWidth;
    
    this.unfilledStar  = loadImage(unfilledStarFileName);
    this.filledStar    = loadImage(filledStarFileName);
    this.starSize     = starSize;
    
    this.time = loadImage(timeFileName);
    this.timeWidth     = timeWidth;
    this.timeHeight    = timeWidth * (20/16.67);
  }
  
  void showLives(){
    renderLives();
  }
  
  void showRatingStars(){
    renderRatingStars();
  }
  
  void showTime(){
    renderTime();
  }
  
  void showEndStats() {
    // show stats for end screen
    renderEndStats();
  }
    
  void showStar(int position, boolean filled) {
    renderStar(position, filled);
  }
  
  void resetRatingStarsAnimation() {
    ratingStarsAnimationState = 0;
    ratingStarsAnimationStartTime = 0;
    for (int i = 0; i < 3; i++) {
      starsFilled[i] = false;
    }
  }
  
  
  //private functions:
  //############################################################

  private void renderLives(){
    float spaceBetween = 10;
    
    push();
    for(int i = 0; i < lives; i = i+1){
      image(live, 100 + (i*liveWidth) + (i*spaceBetween), height-20-liveHeight);
    }
    pop();
  }

  private void renderRatingStars(){
    // start statemachine for "animation" of the stars
    if (rating > 0) {
      int playTime = millis(); //scaled time [ms]    
      
      switch (ratingStarsAnimationState) {
        case 0: // Animation has not yet started
          if (rating > 0) {
            ratingStarsAnimationState = 1;
            ratingStarsAnimationStartTime = playTime;
          }
          break;
        case 1: // Rating is at least one - waiting before "drawing" 1st star and playing 1st sound
          if (playTime > ratingStarsAnimationStartTime + 1000) {
            starsFilled[0] = true;
            // TODO play sound;
            if (rating > 1) ratingStarsAnimationState = 2;
            else ratingStarsAnimationState = 4;
          }
          break;
        case 2: // Rating is at least two - waiting before "drawing" 2nd star and playing 2nd sound
          if (playTime > ratingStarsAnimationStartTime + 2000) {
            starsFilled[1] = true;
            // TODO play sound;
            if (rating > 2) ratingStarsAnimationState = 3;
            else ratingStarsAnimationState = 4;
          }
          break;
        case 3: // Rating is three - waiting before "drawing" 3rd star and playing 3rd sound
          if (playTime > ratingStarsAnimationStartTime + 3000) {
            starsFilled[2] = true;
            // TODO play sound;
            ratingStarsAnimationState = 4;
          }
          break;
        case 4: // End of "animation"
          break;
      }
    }    
    
    // actually render the stars
    for(int i = 1; i <= 3; i = i+1){
      renderStar(i, starsFilled[i-1]);
    }
  }
  
  private void renderStar(int position, boolean filled) {
    float spaceBetween = 10;
    PImage image = filled ? filledStar : unfilledStar;
    image(image, (width/2) - (2.5 * starSize) - (2*spaceBetween) + (position*starSize) + (position*spaceBetween), 80);
  }
  
  private void renderTime(){
    float spaceBetween = 10;
    String text = seconds + " s";
    
    push();
    textSize(18);
    image(time, width - textWidth(text) - 100 - spaceBetween - timeWidth, height-20-timeHeight);
    text (text, width - textWidth(text) - 100                           , height-20-2);
    pop();
  }
  
  private void renderEndStats(){
    String timeText     = "Your time: ";
    String secondsText  = seconds + " s.";
    String starsText    = "Collected stars: " + collectedStars.size();
    String bombsText    = "Avoided bombs: "   + avoidedBombs.size();
    String text;
    if      (seconds < secondsForOneStar)    text = "You can do better next time!";
    else if (seconds < secondsForTwoStars)   text = "Not bad, not bad. But try harder!";
    else if (seconds < secondsForThreeStars) text = "Great score! But can you reach 3 stars?";
    else                                     text = "Awesome score, you're a master!!";
    
    push();
    
    //time
    textFont(titleFont);
    textSize(40);
    text (timeText   , width/2 - (textWidth(timeText)/2), 265);
    textSize(60);
    text (secondsText, width/2 - (textWidth(secondsText)/2), 320);
     
    //text, stars & bombs
    textFont(standardFont);
    text (text       , width/2 - (textWidth(text)/2), height - 20);
    textSize(18);
    text(starsText , 20                                 , height - 20);
    text(bombsText , width - 20 - (textWidth(bombsText)), height - 20);
    
    pop();
  }
  
}
