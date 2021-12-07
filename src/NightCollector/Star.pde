public class Star{
  
  String fileName;
  PImage star;
  float starWidth;
  
  Star(String fileName, int width){
    this.fileName     = fileName;
    this.starWidth    = width;
    
    setUp();
  }
  
  
  void render(float xPos, float yPos){
    
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
