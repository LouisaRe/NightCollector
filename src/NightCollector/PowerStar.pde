public class PowerStar extends CollisionElement {
  
  private PImage  tail;
  private float   tailHeight;
  private boolean missedCollision;
   
  PowerStar(String fileName, int width){ 
    
    this.elementWidth     = width;
    this.elementHeight    = width * (270/33);
    
    this.posX             = random(windowWidth-elementWidth);
    this.posY             = -elementHeight;
    
    this.speed            = 8 + random(2);
    
    this.tail             = loadImage(fileName);
    this.tailHeight       = width * (253.05/33);
    this.missedCollision  = false;
  }
  
  void movePowerStar(){
    posY = posY + speed; //action: vertical movement
    render();
  }
  
  
  //private functions:
  //############################################################

  private void render(){
    
    push();
    scale(1,1);
    image(tail, posX, posY);
    randomColoredCircle(int(posX - 0.5 + (elementWidth/2)), 
                        int(posY + tailHeight), 
                        elementWidth);
    pop();
  }
}

private void randomColoredCircle(int x, int y, float width){
  colorMode(HSB, 360, 100, 100);
  noStroke();
  float hue = random(0, 360);
  fill(hue, 90, 80); // Hue, Saturation, Brightness
  circle(x, y, width);
}
