//Window
int windowWidth    = 1000;
int windowHeight   =  800;

//Colors
color  bgColor1    = color(  7,  22,  62);
color  bgColor2    = color(196, 177, 161);
void   night()     {verticalGradient(0, 0, width, height, bgColor1, bgColor2);}

//Elements
Basket basket;
float  basketSpeed = 0.1;
float  basketPosX  = 0;
float  basketPosY  = 700;

ArrayList<Star> stars = new ArrayList<Star>();
float  starSpeed   = 4 + random(2);
int    timer;


void settings()
{
  size(windowWidth, windowHeight);
  timer            = millis();
  basket           = new Basket("basket.png", 100);
  stars.add(new Star  ("star.png"  ,  34));
}

void draw(){
  //background
  night();
  
  //all create a new star all 2 sec.
  if (millis() - timer >= 2000) {
    createNewStar();
    timer = millis();
  }
  
  //stars
  for(int i = 0; i < stars.size(); i = i+1){
    
    starSpeed   = 4 + random(2);
    starPosX    = random(windowWidth);
    
    //star
    starPosY = starPosY + starSpeed; //action: vertical movement
    stars.get(i).render(stars.get(i).starPosX, starPosY);
  }
  
  //basket
  basketPosX = basketPosX+(mouseX-basketPosX)*basketSpeed; //action: roll to mouseX-Position
  basket.render(basketPosX, basketPosY);
  
  
}

private void createNewStar(){
  stars.add(new Star  ("star.png"  ,  34));
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
