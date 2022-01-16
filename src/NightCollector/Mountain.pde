public class Mountain{
  
  float leftX0, leftY0;
  float leftX1, leftY1;
 
  float rightX0, rightY0;
  float rightX1, rightY1;

  
  Mountain(float leftX0, float leftY0, float leftX1, float leftY1, float rightX0, float rightY0, float rightX1, float rightY1){
    this.leftX0 = leftX0;
    this.leftY0 = leftY0;
    this.leftX1 = leftX1;
    this.leftY1 = leftY1;
    this.rightX1 = rightX1;
    this.rightY1 = rightY1;
    this.rightX0 = rightX0;
    this.rightY0 = rightY0;
  }
  
  void moveMountain(float deltaXleft, float deltaYleft, float deltaXright, float deltaYright){
      leftX1  += deltaXleft;
      leftY1  += deltaYleft;
      rightX1 += deltaXright;
      rightY1 += deltaYright;
    
    render();
  }
  
  //private functions:
  //############################################################
    
  private void render(){
    push();
    myBezier(leftX0, leftY0, leftX1, leftY1, rightX1, rightY1, rightX0, rightY0);
    pop();
  }
  
  // adopted from code from meco-course
  private void myBezier(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3){
    int steps = 40; // Increase value to increase discretization 
    int drawSteps = steps;
    //drawSteps = (int)((sin(millis()/100.0f)*0.5f+0.5f)*steps); //for animation
    for (int it=0; it<drawSteps; it++){
      float t=it/(float)steps;
  
      //bezier-spline
      float b0 =   -(t * t * t) + 3*(t * t) - 3*t + 1;
      float b1 =  3*(t * t * t) - 6*(t * t) + 3*t;
      float b2 = -3*(t * t * t) + 3*(t * t); 
      float b3 =     t * t * t;
      
      //linear interpolation  
      float x = b0*x0 + b1*x1 + b2*x2 + b3*x3;
      float y = b0*y0 + b1*y1 + b2*y2 + b3*y3;
      
      // render points
      circle(x,y,2);
      
      //vertical colored lines
      line(x,800, x, y);
      stroke(102, 66, 77);
     }
  }
}
