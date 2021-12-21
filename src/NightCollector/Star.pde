public class Star{
  
  private PImage   star;
  private float    starWidth;
  private float    starHeight;
  private float    starPosX;
  private float    starPosY;
  private float    starSpeed;
  private boolean  missedStar;
   
  Star(String fileName, int width){
    this.star         = loadImage(fileName);
    this.starWidth    = width;
    this.starPosX     = random(windowWidth-starWidth);
    this.starHeight   = width * (270/33);
    this.starPosY     = -starHeight;
    this.starSpeed    = 4 + random(3);
    this.missedStar   = false;
  }
  
  void moveStar(){
    starPosY = starPosY + starSpeed; //action: vertical movement
    render();
  }
  
  
  //private functions:
  //############################################################

  private void render(){
    
    push();
    scale(1,1);
    image(star, starPosX, starPosY);
    pop();
  }
}
