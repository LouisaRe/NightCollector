//window
int windowWidth    = 1000;
int windowHeight   =  800;

//colors
color  bgColor1    = color(  7,  22,  62);
color  bgColor2    = color(196, 177, 161);
void   night()     {verticalGradient(0, 0, width, height, bgColor1, bgColor2);}

//stars
ArrayList<Star>  stars = new ArrayList<Star>();
float            millisBetweenStars;
int              starTimer;

//basket
Basket basket;

//mountain
Mountain mountain;



void settings()
{
  size(windowWidth, windowHeight);  
  stars.add(           new Star  ("star.png"  ,  34));
  basket             = new Basket("basket.png", 100) ;
  mountain           = new Mountain(  0, windowHeight,   0, 400, 
                                    400, windowHeight, 300, 400);
  millisBetweenStars = 1000 + random(1000);
  starTimer          = millis();
}

void draw(){
  //background
  night();
  
  //mountain
  mountain.moveMountain(sin(millis()/1000), -2 * sin(millis()/1000),0,0); //TODO: Connect movement to Audio
  
  //stars
  if (millis() - starTimer >= millisBetweenStars) { //create a new star after a certain time
    createNewStar();
    millisBetweenStars = 1000 + random(1000);
    starTimer = millis();
  }
  for(int i = 0; i < stars.size(); i = i+1){ //existing stars
    stars.get(i).moveStar();
  }
  
  //basket
  basket.moveBasket();
}


//helper functions:
//############################################################

private void createNewStar(){
  stars.add(new Star("star.png", 34));
}

private void verticalGradient(int x, int y, float width, float height, color color1, color color2){
  for (int i = y; i <= y+height; i++) { //from top row to bottom row
  
      float colMixRatio  = map(i, y, y+height, 0, 1); //increasing values between 0 & 1
      color mixedCol     = lerpColor(color1, color2, colMixRatio);
      stroke(mixedCol);
      line(x, i, x+width, i);
    }
}
