public class Basket{
  
  private PImage basket;
  private float  basketWidth;
  private float  basketHeight;
  private float  heightRatio;
  private float  basketSpeed;
  private float  basketPosX;
  private float  basketPosY;
  
  
  Basket(String fileName, int width){
    this.basket         = loadImage(fileName);
    this.basketWidth    = width;
    this.basketHeight   = basketWidth * heightRatio;
    this.heightRatio    = 0.4;
    this.basketSpeed    = 0.1;
    this.basketPosX     = 0;
    this.basketPosY     = 700;
  }
  
  void moveBasket(){
      basketPosX = basketPosX+(mouseX-basketPosX)*basketSpeed; //action: roll to mouseX-Position
      render(basketPosX, basketPosY);
  }
  
  
  //private functions:
  //############################################################
    
  private void render(float xPos, float yPos){
    
    //prevent basket from running beyond screen
    if(xPos <= basketWidth/2){
      xPos = basketWidth/2;
    }
    if(xPos >= width-(basketWidth/2)){
      xPos = width-(basketWidth/2);
    }
    
    push();
    translate(xPos-(basketWidth/2),yPos);
    scale(1,1);
    image(basket, 0, 0);
    pop();
  }
}
