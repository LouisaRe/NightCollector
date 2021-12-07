//Colors
color  bgColor1    = color(  7,  22,  62);
color  bgColor2    = color(196, 177, 161);
void   night()     {verticalGradient(0, 0, width, height, bgColor1, bgColor2);}

//Elements
Basket basket;
float  basketSpeed = 0.1;
float  basketPosX  = 0;
float  basketPosY  = 700;

Star   star;
float  starSpeed   = 4;
float  starPosX    = 500;
float  starPosY    = -270;


void settings()
{
  size(1000, 800);
  basket           = new Basket("basket.png", 100);
  star             = new Star  ("star.png"  ,  34);
}

void draw(){
  //background
  night();
  
  //basket
  basketPosX = basketPosX+(mouseX-basketPosX)*basketSpeed; //action: roll to mouseX-Position
  basket.render(basketPosX, basketPosY);
  
  //star
  starPosY = starPosY + starSpeed; //action: vertical movement
  star.render(starPosX, starPosY);
}



//Helper functions
//############################################################

void verticalGradient(int x, int y, float width, float height, color color1, color color2){
  for (int i = y; i <= y+height; i++) { //from top row to bottom row
  
      float colMixRatio  = map(i, y, y+height, 0, 1); //increasing values between 0 & 1
      color mixedCol     = lerpColor(color1, color2, colMixRatio);
      stroke(mixedCol);
      line(x, i, x+width, i);
    }
}
