public class Bomb{
  
  private PImage   bomb;
  private float    bombWidth;
  private float    bombHeight;
  private float    bombPosX;
  private float    bombPosY;
  private float    bombSpeed;
  private boolean  missedBomb;
   
  Bomb(String fileName, int width){
    this.bomb         = loadImage(fileName);
    this.bombWidth    = width;
    this.bombPosX     = random(windowWidth-bombWidth);
    this.bombHeight   = width * (270/27);
    this.bombPosY     = -bombHeight;
    this.bombSpeed    = 8 + random(3);
    this.missedBomb   = false;
  }
  
  void moveBomb(){
    bombPosY = bombPosY + bombSpeed; //action: vertical movement
    render(bombPosX, bombPosY);
  }
  
  
  //private functions:
  //############################################################

  private void render(float xPos, float yPos){
    
    push();
    scale(1,1);
    image(bomb, xPos, yPos);
    pop();
  }
}
