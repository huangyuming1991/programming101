//game start
PImage titleImg, startNormalImg, startHoveredImg;
//game run
PImage groundhogIdleImg, groundhogDownImg, groundhogRightImg, groundhogLeftImg;
PImage backgroundImg, backgroundFrontImg, lifeImg, cabbageImg, soldierImg;
//game lose
PImage gameoverImg, restartNormalImg, restartHoveredImg;


//game run
int backgroundFrontPosY;
int soldierPosX;
int soldierPosY;
int soldierSpeed = 3;

int cabbagePosX;
int cabbagePosY;
boolean eatCabbage = false;

int lifePoint;
int lifeInitPos = 10;
int lifeMargin = 20;

int grassHeight = 15;
int sunInnerRadious = 60;
int sunOutterRadious = 70;
int sunMargin = 50;

boolean rightPressed = false;
boolean leftPressed = false;
boolean downPressed = false;

float blockWidth;
float blockHeight;

float groundhogPosX;
float groundhogPosY;

boolean isMoving = false;
float moveFrame = 0; //count current frames
float moveFrameLimit = 15; // 1 secend 60 frames, 0.25 second 15 frames 


int gameState = 0;

void setup() {
	size(640, 480, P2D);
  loadAllImages();
	initGameRunScene();
}

void draw() {
  // Switch Game State
  switch (gameState){
    case 0:// Game Start
      showGameStartScene();
      break;
    case 1:// Game Run
      showGameRunScene();
      break;
    case 2:// Game Lose
      showGameLoseScene();
      break;
  }	
}

void keyPressed(){
  // Switch move State
  if(!isMoving){
    switch (keyCode){
      case RIGHT:
        if(groundhogPosX < width-groundhogIdleImg.width){ //limit position
          isMoving = true;
          rightPressed = true;
        }
        break;
      case LEFT:
        if(groundhogPosX > 0){ //limit position
          isMoving = true;
          leftPressed = true;
          break;
        }
      case DOWN: 
        if(groundhogPosY < height-groundhogIdleImg.height){ //limit position
          isMoving = true;
          downPressed = true;
          break;
        }
    }
  }
}

void showGameStartScene(){
  imageMode(CORNER);
  image(titleImg, 0, 0);
  boolean mouseHoverStart = mouseX>248 && mouseX<392 && mouseY>360 && mouseY<420; 
  if(mouseHoverStart){
    image(startHoveredImg, 248, 360);
    if(mousePressed){
      gameState = 1;
    }
  }else{
    image(startNormalImg, 248, 360);
  }
}


void showGameRunScene(){
  //game run background
  imageMode(CORNER);
  image(backgroundImg, 0, 0);
  image(backgroundFrontImg, 0, backgroundFrontPosY);
  
  //grass
  noStroke();
  rectMode(CORNER);
  fill(124, 204, 25);
  rect(0, backgroundFrontPosY-grassHeight, width, grassHeight);
  
  //sun
  strokeWeight(5);
  stroke(255, 255, 0);
  fill(253, 184, 19);
  ellipse(width-sunMargin, sunMargin, sunInnerRadious*2, sunInnerRadious*2);
  
  //life
  int lifeMove = lifeMargin+lifeImg.width;
  for(int i=0; i< lifePoint; i++){
    image(lifeImg, lifeInitPos+lifeMove*i, lifeInitPos);
  }
  
  //soldier
  image(soldierImg, soldierPosX, soldierPosY);
  soldierPosX += soldierSpeed;
  if(soldierPosX>width){
    soldierPosX = -soldierImg.width;
  }
  
  //cabbage
  if(!eatCabbage){
    image(cabbageImg, cabbagePosX, cabbagePosY);
  }
  
  //groundhog
  moveGroundhog();
  //collide soldier
  isTouchItem(0);
  //collide cabbage
  isTouchItem(1);
}

void showGameLoseScene(){
  imageMode(CORNER);
  image(gameoverImg, 0, 0);
  boolean mouseHoverStart = mouseX>248 && mouseX<392 && mouseY>360 && mouseY<420; 
  if(mouseHoverStart){
    image(restartHoveredImg, 248, 360);
    if(mousePressed){
      initGameRunScene();
      gameState = 1;
    }
  }else{
    image(restartNormalImg, 248, 360);
  }
}


void moveGroundhog(){
  if(rightPressed){
    groundhogPosX += blockWidth/moveFrameLimit;
    image(groundhogRightImg, groundhogPosX, groundhogPosY);
  }else if(leftPressed){
    groundhogPosX -= blockWidth/moveFrameLimit;
    image(groundhogLeftImg, groundhogPosX, groundhogPosY);
  }else if(downPressed){
    groundhogPosY += blockHeight/moveFrameLimit;
    image(groundhogDownImg, groundhogPosX, groundhogPosY);
  }else{
    image(groundhogIdleImg, groundhogPosX, groundhogPosY);
  }
   if(groundhogPosX<0){
            groundhogPosX=0;
          }
          if(groundhogPosX>560){
            groundhogPosX=560;
          }
          if(groundhogPosY>400){
            groundhogPosY=400;
          }
  if(isMoving){
    moveFrame++;
    if(moveFrame == 15){
      endMove();
    }
  }
}

void endMove(){
  rightPressed = false;
  leftPressed = false;
  downPressed = false;
  isMoving = false;
  moveFrame = 0;
}

void isTouchItem(int item){
  boolean isTouchX;
  boolean isTouchY;
  if(item == 0){ // soldier
    isTouchX = abs(groundhogPosX - soldierPosX) < groundhogIdleImg.width*0.7;
    isTouchY = abs(groundhogPosY - soldierPosY) < groundhogIdleImg.height*0.7; 
    if(isTouchX && isTouchY){ // touch soldier
      endMove();
      lifePoint--;
      initGroundhog();
      if(lifePoint == 0){
        gameState= 2;
      }
    }
  }else{ //cabbage
    isTouchX = abs(groundhogPosX - cabbagePosX) < groundhogIdleImg.width*0.7;
    isTouchY = abs(groundhogPosY - cabbagePosY) < groundhogIdleImg.height*0.7; 
    if(isTouchX && isTouchY){ // touch cabbage
      if(lifePoint < 3){
        cabbagePosX = 0;
        cabbagePosY = 0;
        eatCabbage = true;
        lifePoint++;
      }
    }
  }
}

void initGameRunScene(){
  //game run init
  eatCabbage = false;
  lifePoint = 2;
  
  //background
  backgroundFrontPosY = height-backgroundFrontImg.height;
  
  //soldier
  soldierPosX = -soldierImg.width;
  soldierPosY = backgroundFrontPosY+ (backgroundFrontImg.height/4)*(floor(random(4)));
  
  //cabbage
  cabbagePosY = backgroundFrontPosY+ (backgroundFrontImg.height/4)*(floor(random(4)));
  cabbagePosX = width/8*(floor(random(8)));
  
  //block size
  blockWidth = backgroundFrontImg.width/8;
  blockHeight = backgroundFrontImg.height/4;
  
  initGroundhog();
}

void initGroundhog(){
  groundhogPosX = blockWidth*4;
  groundhogPosY = backgroundFrontPosY-blockWidth;
}


void loadAllImages(){
  //start
  titleImg = loadImage("img/title.jpg");
  startNormalImg = loadImage("img/startNormal.png");
  startHoveredImg = loadImage("img/startHovered.png");
  
  //run
  backgroundImg = loadImage("img/bg.jpg");
  backgroundFrontImg = loadImage("img/soil.png");
  lifeImg = loadImage("img/life.png");
  cabbageImg = loadImage("img/cabbage.png");
  soldierImg = loadImage("img/soldier.png");
  groundhogIdleImg = loadImage("img/groundhogIdle.png");
  groundhogDownImg = loadImage("img/groundhogDown.png");
  groundhogRightImg = loadImage("img/groundhogRight.png");
  groundhogLeftImg = loadImage("img/groundhogLeft.png");
  
  //lose
  gameoverImg = loadImage("img/gameover.jpg");
  restartNormalImg = loadImage("img/restartNormal.png");
  restartHoveredImg = loadImage("img/restartHovered.png");
}
