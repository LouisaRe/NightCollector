public class Star{
  
  String   fileName;
  PImage   star;
  float    starWidth;
  float    starPosX;
  float    starPosY;
  
  Star(String fileName, int width){
    this.fileName     = fileName;
    this.starWidth    = width;
    this.starPosX     = random(windowWidth);
    this.starPosY     = -270;
    
    setUp();
  }
  
  
  void render(float xPos, float yPos){
    
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
  
  
  //Private Functions:
  //############################################################
  
  private void setUp(){
    star = loadImage(fileName);
  }
}
