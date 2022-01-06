public class Bomb extends CollisionElement{
  
  private PImage  bomb;
  private boolean missedCollision;
   
  Bomb(String fileName, int width){
    
    this.elementWidth    = width;
    this.elementHeight   = width * (270/27);
    
    this.posX            = random(windowWidth-elementWidth);
    this.posY            = - elementHeight;  
    
    this.speed           = 8 + random(3);
    
    this.bomb            = loadImage(fileName);
    this.missedCollision = false;
  }
  
  void moveBomb(){
    posY = posY + speed; //action: vertical movement
    render(posX, posY);
  }
  
  
  //private functions:
  //############################################################

  private void render(float xPos, float yPos){
    
    push();
    image(bomb, xPos, yPos);
    pop();
  }
}
