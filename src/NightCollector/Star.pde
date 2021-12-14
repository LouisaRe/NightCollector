public class Star{
  
  private PImage   star;
  private float    starWidth;
  private float    starPosX;
  private float    starPosY;
  private float    starSpeed;
   
  Star(String fileName, int width){
    this.star         = loadImage(fileName);
    this.starWidth    = width;
    this.starPosX     = random(windowWidth);
    this.starPosY     = -270;
    this.starSpeed    = 4 + random(3);
  }
  
  void moveStar(){
    starPosY = starPosY + starSpeed; //action: vertical movement
    render(starPosX, starPosY);
  }
  
  
  //private functions:
  //############################################################

  private void render(float xPos, float yPos){
    
    //prevent star from beeing beyond screen on left & right window side
    if(xPos <= starWidth/2){
      xPos = starWidth/2;
    }
    if(xPos >= width-(starWidth/2)){
      xPos = width-(starWidth/2);
    }
    
    push();
    translate(-(starWidth/2),0);
    scale(1,1);
    image(star, xPos, yPos);
    pop();
  }
}
