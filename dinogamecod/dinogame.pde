import controlP5.*;
import java.awt.Font;

ControlP5 cp5;
boolean mostrarMenu = true;

// Variáveis do jogo
int obstacleTimer = 0;
int minTimeBetObs = 60;
int randomAddition = 0;
int groundCounter = 0;
float speed = 10;

int groundHeight = 50;
int playerXpos = 100;
int highScore = 0;
String cor = "yellow"; // Variável de cor inicializada como "yellow"

boolean exibindoCreditos = false;

Player dino;

PImage dinoRun1, dinoRun2, dinoJump, dinoDuck, dinoDuck1, smallCactus, bigCactus, manySmallCactus, bird, bird1;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Ground> grounds = new ArrayList<Ground>();

// Estados do jogo
int estado = 0; // 0 para menu, 1 para jogo

// Dificuldades
int dificuldade = 1; // 0 para fácil, 1 para normal, 2 para difícil

void setup() {
  size(800, 400);
  frameRate(60);
  
  cp5 = new ControlP5(this);
  
  // Carrega as imagens (adaptar o caminho para o seu ambiente)
  dinoRun1 = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinorun0000" + cor + ".png");
  dinoRun2 = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinorun0001" + cor + ".png");
  dinoJump = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinoJump0000" + cor + ".png");
  dinoDuck = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinoduck0000" + cor + ".png");
  dinoDuck1 = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinoduck0001" + cor + ".png");
  smallCactus = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/cactusSmall0000.png");
  bigCactus = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/cactusBig0000.png");
  manySmallCactus = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/cactusSmallMany0000.png");
  bird = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/berd.png");
  bird1 = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/berd2.png");
  
  dino = new Player();
  
  // Adiciona os botões de dificuldade como um seletor
  cp5.addDropdownList("dificuldade")
   .setPosition(10, 10) // Posiciona o seletor no canto superior esquerdo
   .setSize(180, 180) // Aumenta o tamanho do seletor
   .setCaptionLabel("Dificuldade")
   .setItemHeight(20) // Define a altura dos itens (ajuste conforme necessário)
   .setBarHeight(20) // Define a altura da barra (ajuste conforme necessário)
   .setFont(createFont("Arial", 14)) // Define a fonte e o tamanho para o seletor como um todo
   .addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        dificuldade = (int) e.getValue();
      }
   })
   .addItem("Facil", 0)
   .addItem("Normal", 1)
   .addItem("Dificil", 2);
  
  // Adiciona o seletor de cores
  cp5.addDropdownList("seletorDeCor")
   .setPosition(10, 150) // Posição abaixo do seletor de dificuldade
   .setSize(180, 180) // Tamanho do seletor
   .setCaptionLabel("Cor do Dino")
   .setItemHeight(20) // Altura dos itens
   .setBarHeight(20) // Altura da barra
   .setFont(createFont("Arial", 14)) // Fonte e tamanho do seletor
   .addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        cor = cp5.get(DropdownList.class, "seletorDeCor").getItem((int) e.getValue()).get("name").toString();
        atualizarImagensDino(); // Atualiza as imagens do dino com a nova cor
      }
   })
   .addItem("vermelho", 0)
   .addItem("verde", 1)
   .addItem("azul", 2)
   .addItem("amarelo", 3)
   .addItem("roxo", 4)
   .addItem("preto", 5);
  
  // Adiciona os botões do menu
  cp5.addButton("iniciarButton")
     .setPosition(width / 2 - 100, height / 2 - 60)
     .setSize(200, 50)
     .setCaptionLabel("Iniciar Jogo")
     .setFont(createFont("Arial", 20)) // Configura a fonte para tamanho 20
     .onClick(new CallbackListener() {
       public void controlEvent(CallbackEvent e) {
         iniciarJogo();
       }
     });
     
  cp5.addButton("sairButton")
     .setPosition(width / 2 - 100, height / 2 + 20)
     .setSize(200, 50)
     .setCaptionLabel("Sair")
     .setFont(createFont("Arial", 20)) // Configura a fonte para tamanho 20
     .onClick(new CallbackListener() {
       public void controlEvent(CallbackEvent e) {
         sairJogo();
       }
     });

  cp5.addButton("creditosButton")
     .setPosition(10, height - 60) // Posição no canto esquerdo inferior
     .setSize(100, 40)
     .setCaptionLabel("Créditos")
     .setFont(createFont("Arial", 14)) // Escolha da fonte
     .onClick(new CallbackListener() {
       public void controlEvent(CallbackEvent e) {
         exibirCreditos();
       }
     });
}

void draw() {
  if (estado == 0 && mostrarMenu) {
    // Desenha o menu inicial
    desenhaMenu();
    
    // Verifica se os botões e seletor de dificuldade devem ser visíveis
    if (!exibindoCreditos) {
      cp5.getController("iniciarButton").setVisible(true);
      cp5.getController("sairButton").setVisible(true);
      cp5.getController("dificuldade").setVisible(true);
      cp5.getController("seletorDeCor").setVisible(true);
    } else {
      cp5.getController("iniciarButton").setVisible(false);
      cp5.getController("sairButton").setVisible(false);
      cp5.getController("dificuldade").setVisible(false);
      cp5.getController("seletorDeCor").setVisible(false);
    }
  } else if (estado == 1) {
    // Desenha o jogo
    desenhaJogo();
  }
  
  // Verifica se os créditos devem ser exibidos
  if (exibindoCreditos) {
    background(50, 100, 150); // Cor de fundo dos créditos
    fill(255); // Cor do texto
    textSize(20); // Tamanho do texto
    textAlign(CENTER, CENTER); // Alinhamento centralizado
    
    text("Desenvolvido por:", width / 2, height / 2 - 40);
    text("Gustavo Postigo Santos", width / 2, height / 2); 
    text("Gabriel Oliveira Grola", width / 2, height / 2);
    text("João Pedro Aranda Ziemann", width / 2, height / 2);
  }
}

void desenhaMenu() {
  background(50, 100, 150);
  
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Menu Inicial", width / 2, height / 4);
}

void desenhaJogo() {
  background(250);
  stroke(0);
  strokeWeight(2);
  line(0, height - groundHeight - 30, width, height - groundHeight - 30);
  
  updateObstacles();
  
  if (dino.score > highScore) {
    highScore = dino.score;
  }
  
  textSize(20);
  fill(0);
  
  // Score ligeiramente deslocado para a direita
  float scoreX = 40; // Deslocamento de 20 pixels
  text("Score: " + dino.score, scoreX, 20);
  
  // High Score ligeiramente deslocado para a direita
  float highScoreX = width - textWidth("High Score: " + highScore) - 40; // Deslocamento de 20 pixels
  text("High Score: " + highScore, highScoreX, 20);
}

void iniciarJogo() {
  estado = 1;
  mostrarMenu = false; // Oculta os botões do menu após iniciar o jogo
  cp5.getController("iniciarButton").hide(); // Oculta o botão "Iniciar Jogo"
  cp5.getController("sairButton").hide(); // Oculta o botão "Sair"
  cp5.getController("dificuldade").hide(); // Oculta o seletor de dificuldade
  cp5.getController("creditosButton").hide(); // Oculta o botão "Créditos"
  cp5.getController("seletorDeCor").hide(); // Oculta o seletor de cor
}

void sairJogo() {
  exit();
}

void exibirCreditos() {
  exibindoCreditos = true;
  
  cp5.getController("iniciarButton").hide();
  cp5.getController("sairButton").hide();
  cp5.getController("dificuldade").hide();
  cp5.getController("seletorDeCor").hide();
}

void keyPressed() {
  if (estado == 1) {
    switch (key) {
      case ' ': dino.jump();
                break;
      case 's': if (!dino.dead) {
                  dino.ducking(true);
                }
                break;
      case 'r': mostrarMenu = true; // Volta ao menu quando 'r' é pressionado
                estado = 0; // Define o estado como 0 para voltar ao menu
                reset(); // Reseta o jogo
                break;
    }
  }
}

void keyReleased() {
  if (estado == 1) {
    switch (key) {
      case 's': if (!dino.dead) {
                  dino.ducking(false);
                }
                break;
      case 'r': if (dino.dead) {
                  reset();
                }
                break;
    }
  }
}

void updateObstacles() {
  showObstacles();
  dino.show();
  if (!dino.dead) {
    obstacleTimer++;
    speed += 0.002;
    if (obstacleTimer > minTimeBetObs + randomAddition) {
      addObstacle();
    }
    groundCounter++;
    if (groundCounter > 10) {
      groundCounter = 0;
      grounds.add(new Ground());
    }
    moveObstacles();
    dino.update();
  } else {
    textSize(28);
    fill(0);
    textAlign(CENTER, CENTER);
    text("VOCÊ MORREU!", width / 2, height / 2 - 40);
    textSize(14);
    text("(Pressione 'r' para reiniciar e voltar ao menu)", width / 2, height / 2);
  }
}

void showObstacles() {
  for (int i = 0; i < grounds.size(); i++) {
    grounds.get(i).show();
  }
  for (int i = 0; i < obstacles.size(); i++) {
    obstacles.get(i).show();
  }
  for (int i = 0; i < birds.size(); i++) {
    birds.get(i).show();
  }
}

void addObstacle() {
  if (random(1) < 0.15) {
    birds.add(new Bird(floor(random(3))));
  } else {
    obstacles.add(new Obstacle(floor(random(3))));
  }
  randomAddition = floor(random(50));

  obstacleTimer = 0;
}

void moveObstacles() {
  for (int i = 0; i < grounds.size(); i++) {
    grounds.get(i).move(speed);
    if (grounds.get(i).posX < -playerXpos) {
      grounds.remove(i);
      i--;
    }
  }
  for (int i = 0; i < obstacles.size(); i++) {
    obstacles.get(i).move(speed);
    if (obstacles.get(i).posX < -playerXpos) {
      obstacles.remove(i);
      i--;
    }
  }
  for (int i = 0; i < birds.size(); i++) {
    birds.get(i).move(speed);
    if (birds.get(i).posX < -playerXpos) {
      birds.remove(i);
      i--;
    }
  }
}

void reset() {
  dino = new Player();
  obstacles = new ArrayList<Obstacle>();
  birds = new ArrayList<Bird>();
  grounds = new ArrayList<Ground>();
  
  obstacleTimer = 0;
  randomAddition = floor(random(50));
  groundCounter = 0;
  speed = 10;
  
  estado = 0; // Retorna ao menu após a reinicialização
  mostrarMenu = true; // Garante que o menu seja mostrado
  cp5.getController("iniciarButton").show(); // Mostra o botão "Iniciar Jogo"
  cp5.getController("sairButton").show(); // Mostra o botão "Sair"
  cp5.getController("dificuldade").show(); // Mostra o seletor de dificuldade
  cp5.getController("creditosButton").show();
  cp5.getController("seletorDeCor").show(); // Mostra o seletor de cor
}

void mousePressed() {
  if (exibindoCreditos) {
    exibindoCreditos = false; // Fecha os créditos ao clicar na tela
    cp5.getController("iniciarButton").show();
    cp5.getController("sairButton").show();
    cp5.getController("dificuldade").show();
    cp5.getController("seletorDeCor").show(); // Mostra o seletor de cor ao voltar do créditos
  }
}

void atualizarImagensDino() {
  // Atualiza as imagens do Dino com base na cor selecionada
  dinoRun1 = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinorun0000" + cor + ".png");
  dinoRun2 = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinorun0001" + cor + ".png");
  dinoJump = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinoJump0000" + cor + ".png");
  dinoDuck = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinoduck0000" + cor + ".png");
  dinoDuck1 = loadImage("C:/Users/gustavo.santos/Documents/DocumentosGustavo/dinogame/dinoduck0001" + cor + ".png");
}
