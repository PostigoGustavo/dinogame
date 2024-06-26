class Player{
  float posY = 0;
  float velY = 0;
  float gravity = 1.2;
  float angle = 0;
  int size = 20;
  boolean duck = false;
  boolean dead = false;
  boolean doingFlip = false;
  
  int runCount = -5;
  int lifespan;
  int score;
  
  Player(){
  }
  
  void jump(){
    jumpSound.play();
    if(posY == 0){
      gravity = 1.2;
      velY = 16;
      if(doingFlip){
        angle = 0;
      }
    }
  }
  
  void show(){
    if(doingFlip){
      pushMatrix();
      translate(playerXpos + dinoRun1.width / 2, height - groundHeight - posY);
      rotate(radians(angle));
      image(dinoJump, -dinoJump.width / 2, -dinoJump.height / 2);
      angle += 15; 
      if (angle >= 360) { 
        angle = 0;
      }
      popMatrix();
    } 
    else{
      if(duck && posY == 0){
        if(runCount < 0){
          image(dinoDuck, playerXpos - dinoDuck.width / 2, height - groundHeight - (posY + dinoDuck.height));
      }
      else{
        image(dinoDuck1, playerXpos - dinoDuck1.width / 2, height - groundHeight - (posY + dinoDuck1.height));
      }
    }
    else{
      if(posY == 0){
        if(runCount < 0){
          image(dinoRun1, playerXpos - dinoRun1.width / 2, height - groundHeight - (posY + dinoRun1.height));
        }
        else{
          image(dinoRun2, playerXpos - dinoRun2.width / 2, height - groundHeight - (posY + dinoRun2.height));
        }
      }
      else{
        image(dinoJump, playerXpos - dinoJump.width / 2, height - groundHeight - (posY + dinoJump.height));
      }
    }
    
    if(!dead){
      runCount++;
    }
    
    if(runCount > 5){
      runCount = -5;
    }
  }
}

  void move(){
    posY += velY;
    if(posY > 0){
      velY -= gravity;
    }
    else{
      velY = 0;
      posY = 0;
    }
    
    for(int i = 0; i < obstacles.size(); i++){
      if(dead){
        if(obstacles.get(i).collided(playerXpos, posY + dinoDuck.height / 2, dinoDuck.width * 0.5, dinoDuck.height)){
          dead = true;
          deathSound.play();
        }
      }
      else{
        if(obstacles.get(i).collided(playerXpos, posY + dinoRun1.height / 2, dinoRun1.width * 0.5, dinoRun1.height)){
          dead = true;
          deathSound.play();
        }
      }
    }
    
    for(int i = 0; i < birds.size(); i++){
      if(duck && posY == 0){
        if(birds.get(i).collided(playerXpos, posY + dinoDuck.height / 2, dinoDuck.width * 0.5, dinoDuck.height)){
          dead = true;
          deathSound.play();
        }
      }
      else{
        if(birds.get(i).collided(playerXpos, posY + dinoRun1.height / 2, dinoRun1.width * 0.5, dinoRun1.height)){
          dead = true;
          deathSound.play();
        }
      }
    }
  }
  
  void ducking(boolean isDucking){
    if(posY != 0 && isDucking){
      gravity = 3;
    }
    duck = isDucking;
  }
  
  void update(){
    incrementCounter();
    move();
  }
  
  void incrementCounter(){
    lifespan++;
    if(lifespan % 3 == 0){
      score += 1;
    }
  }
}
