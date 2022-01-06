public class Star extends CollisionElement{
  
  private PImage   star;
  private boolean missedCollision;
   
  Star(String fileName, int width){
 
    this.elementWidth    = width;
    this.elementHeight   = width * (270/33);
    
    this.posX            = random(windowWidth-elementWidth);
    this.posY            = -elementHeight;

    this.speed           = 4 + random(3);
    
    this.star            = loadImage(fileName);
    this.missedCollision = false;
  }
  
  void moveStar(){
    posY = posY + speed; //action: vertical movement
    render();
  }
  
  
  //private functions:
  //############################################################

  private void render(){
    
    push();
    scale(1,1);
    image(star, posX, posY);
    pop();
  }
}
