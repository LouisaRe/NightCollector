public class Basket extends CollisionElement{
  
  private PImage basket;
  private float  heightRatio;
  private float  mousePosX;
  
  
  Basket(String fileName, int width){
    
    this.elementWidth  = width;
    this.elementHeight = elementWidth * heightRatio;
    
    this.posX          = mousePosX - (elementWidth/2);
    this.posY          = 700;
    
    this.speed         = 0.1;
    
    this.basket        = loadImage(fileName);
    this.heightRatio   = 0.4;
    this.mousePosX     = 0;

  }
  
  void moveBasket(){
      mousePosX = mousePosX+(mouseX-mousePosX)*speed; //action: roll to mouseX-Position
      
      render();
  }
  
  
  //private functions:
  //############################################################
    
  private void render(){
       
    posX = mousePosX-(elementWidth/2);
    
    //prevent basket from running beyond screen
    if(mousePosX <= elementWidth/2){
      posX = 0;
    }
    if(mousePosX >= width-(elementWidth/2)){
      posX = width-elementWidth;
    }
    
    push();
    translate(posX, posY);
    scale(1,1);
    image(basket, 0, 0);
    pop();
  }
}
