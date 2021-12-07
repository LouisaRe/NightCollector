public class Basket{
  
  String fileName;
  PImage basket;
  float  basketWidth;
  float  basketHeight;
  float  heightRatio = 0.4;
  
  
  Basket(String fileName, int width){
    this.fileName       = fileName;
    this.basketWidth    = width;
    this.basketHeight   = basketWidth * heightRatio;
    
    setUp();
  }
  
  void render(float xPos, float yPos){
    
    // Prevent basket from running beyond screen
    if(xPos <= basketWidth/2){
      xPos = basketWidth/2;
    }
    if(xPos >= width-(basketWidth/2)){
      xPos = width-(basketWidth/2);
    }
    
    push();
    translate(xPos-(basketWidth/2),yPos);
    scale(1,1);
    image(basket, 0,0);
    pop();
  }
  
  //Private Functions:
  //############################################################
  
  private void setUp(){
    basket = loadImage(fileName);
  }
}
