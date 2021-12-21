public class Basket{
  
  private PImage basket;
  private float  basketWidth;
  private float  basketHeight;
  private float  heightRatio;
  private float  basketSpeed;
  private float  mousePosX;
  private float  basketPosX;
  private float  basketPosY;
  
  
  Basket(String fileName, int width){
    this.basket         = loadImage(fileName);
    this.basketWidth    = width;
    this.basketHeight   = basketWidth * heightRatio;
    this.heightRatio    = 0.4;
    this.basketSpeed    = 0.1;
    this.mousePosX      = 0;
    this.basketPosX     = mousePosX - (basketWidth/2);
    this.basketPosY     = 700;
  }
  
  void moveBasket(){
      mousePosX = mousePosX+(mouseX-mousePosX)*basketSpeed; //action: roll to mouseX-Position
      
      render();
  }
  
  
  //private functions:
  //############################################################
    
  private void render(){
       
    basketPosX = mousePosX-(basketWidth/2);
    
    //prevent basket from running beyond screen
    if(mousePosX <= basketWidth/2){
      basketPosX = 0;
    }
    if(mousePosX >= width-(basketWidth/2)){
      basketPosX = width-basketWidth;
    }
    
    push();
    translate(basketPosX, basketPosY);
    scale(1,1);
    image(basket, 0, 0);
    pop();
  }
}
