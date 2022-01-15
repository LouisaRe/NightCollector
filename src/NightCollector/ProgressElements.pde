class ProgressElements{
  
  private PImage live;
  private float  liveWidth;
  private float  liveHeight;
  
  private PImage unfilledStar;
  private PImage filledStar;
  private float  starWidth;
  private float  starHeight;
  
  private PImage time;
  private float  timeWidth;
  private float  timeHeight;
  
  ProgressElements(String liveFileName, float liveWidth, String unfilledStarFileName, String filledStarFileName, float starWidth, String timeFileName, float timeWidth){
    this.live          = loadImage(liveFileName);
    this.liveWidth     = liveWidth;
    this.liveHeight    = liveWidth;
    
    this.unfilledStar  = loadImage(unfilledStarFileName);
    this.filledStar    = loadImage(filledStarFileName);
    this.starWidth     = starWidth;
    this.starHeight    = starWidth;
    
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
    float spaceBetween = 10;
    
    push();
    for(int i = 1; i <= 3; i = i+1){
      PImage image;
      if(rating >= i){
        image = filledStar;
        
      }else{
        image = unfilledStar;
      }
      
      image(image, (width/2) - (2.5 * starWidth) - (2*spaceBetween) + (i*starWidth) + (i*spaceBetween), height/2-(starHeight/2) - 200);
    }
    pop();
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
    String text = "Your time: " + seconds + " s.  ";
    if      (seconds < secondsForOneStar)    text += "You can do better next time!";
    else if (seconds < secondsForTwoStars)   text += "Not bad, not bad. But try harder!";
    else if (seconds < secondsForThreeStars) text += "Great score! But can you reach 3 stars?";
    else                                     text += "Awesome score, you're a master!!";
    
    push();
    textSize(18);
    textAlign(CENTER);
    text (text, width/2, 310);
    pop();
  }
  
}
