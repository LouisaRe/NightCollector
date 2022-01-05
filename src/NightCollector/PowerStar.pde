public class PowerStar{
  
  private PImage   powerStarTail;
  private float    powerStarTailHeight;
  private float    powerStarWidth;
  private float    powerStarHeight;
  private float    powerStarPosX;
  private float    powerStarPosY;
  private float    powerStarSpeed;
   
  PowerStar(String fileName, int width){
    this.powerStarTail       = loadImage(fileName);
    this.powerStarTailHeight = width * (253.05/33);
    this.powerStarWidth      = width;
    this.powerStarPosX       = random(windowWidth-powerStarWidth);
    this.powerStarHeight     = width * (270/33);
    this.powerStarPosY       = -powerStarHeight;
    this.powerStarSpeed      = 8 + random(2);
  }
  
  void movePowerStar(){
    powerStarPosY = powerStarPosY + powerStarSpeed; //action: vertical movement
    render();
  }
  
  
  //private functions:
  //############################################################

  private void render(){
    
    push();
    scale(1,1);
    image(powerStarTail, powerStarPosX, powerStarPosY);
    randomColoredCircle(int(powerStarPosX - 0.5 + (powerStarWidth/2)), 
                        int(powerStarPosY + powerStarTailHeight), 
                        powerStarWidth);
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
