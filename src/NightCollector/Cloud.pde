public class Cloud{
  
  private PImage   cloud;
  private float    cloudWidth;
  private float    cloudHeight;
  private float    cloudPosX;
  private float    cloudInitXPos;
  private float    cloudPosY;
  private float    movingDistance;
   
  Cloud(String fileName, int width, float movingDistance){
    this.cloud          = loadImage(fileName);
    this.cloudWidth     = width;
    this.cloudHeight    = width * (108/392);
    this.cloudInitXPos  = random(1000-cloudWidth);
    this.cloudPosX      = cloudInitXPos;
    this.cloudPosY      = random(400);
    this.movingDistance = movingDistance;
  }
  
  void moveCloud(float t, int movement){
    float m;
    if(movement == 1){
      m = sin(t/6 * PI);
    }
    else if(movement == 2){
      m = cos(t/8 * PI);
    }
    else{
      m = 1;
    }
    
    cloudPosX = cloudInitXPos + (movingDistance/2) * m; //action: horizontal movement
    render();
  }
  
  
  //private functions:
  //############################################################

  private void render(){
    
    push();
    image(cloud, cloudPosX, cloudPosY);
    pop();
  }
}
