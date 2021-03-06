import processing.net.*;

Server myServer;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2, promopiece, id, r1, c1, r2, c2;
boolean itsMyTurn = true; 
boolean promo = false;


char grid[][] = {
  {'R', 'B', 'N', 'Q', 'K', 'N', 'B', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'b', 'n', 'q', 'k', 'n', 'b', 'r'}
};

void setup() {
  size(800, 800);

  myServer = new Server(this, 1234);

  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  drawBoard();
  drawPieces();
  receiveMove();
  promo();
}

void keyPressed() {
  if (itsMyTurn && !(row2 == row1 && col2 == col1) && !(grid[row2][col2] == 'p') && key == 'z' || key == 'Z') {
    grid[row1][col1] = grid[row2][col2];
    grid[row2][col2] = '_';
    id = 2;
    myServer.write(id + "," + row2 + "," + col2 + "," + row1 + "," + col1);
    row2 = row1;
    col2 = col1;
  }
}

void receiveMove() {
  Client myclient = myServer.available();
  if (myclient != null) {
    String incoming = myclient.readString();
    id = int(incoming.substring(0, 1));

    //############## MOVE RECEIVE ##############
    if (id == 0) {
      r1 = int(incoming.substring(2, 3));
      c1 = int(incoming.substring(4, 5));
      r2 = int(incoming.substring(6, 7));
      c2 = int(incoming.substring(8, 9));
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = ' ';
      itsMyTurn = true;
    }

    //############## PROMO RECEIVE ##############
    if (id == 1) {
      c2 = int(incoming.substring(2, 3));
      promopiece = int(incoming.substring(4, 5));
      if (promopiece == 1) {
        grid[0][c2] = 'q';
        promopiece = 0;
      }
      if (promopiece == 2) {
        grid[0][c2] = 'r'; 
        promopiece = 0;
      }
      if (promopiece == 3) {
        grid[0][c2] = 'n'; 
        promopiece = 0;
      }
      if (promopiece == 4) {
        grid[0][c2] = 'b'; 
        promopiece = 0;
      }
    }

    //############## TAKEBACK RECEIVE ############## 
    if (id == 2) {
      r2 = int(incoming.substring(2, 3));
      c2 = int(incoming.substring(4, 5));
      r1 = int(incoming.substring(6, 7));
      c1 = int(incoming.substring(8, 9));
      grid[r1][c1] = grid[r2][c2];
      grid[r2][c2] = '_';
    }
  }
}

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      strokeWeight(0);
      rect(c*100, r*100, 100, 100);
    }
  }
}

void promo() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[7][c] == 'P') {
        promo = true;

        //############## OPTION BOXES ############## 
        strokeWeight(4);
        fill(225);
        rect(width/2 - 300, height/2 - 100, 600, 200);

        fill(255);
        rect(width/2 - 260, height/2 - 40, 100, 100);
        rect(width/2 - 120, height/2 - 40, 100, 100);
        rect(width/2 + 20, height/2 - 40, 100, 100);
        rect(width/2 + 160, height/2 - 40, 100, 100);

        bqueen.resize(100, 100);
        brook.resize(100, 100);
        bknight.resize(100, 100);
        bbishop.resize(100, 100);
        image (bqueen, width/2 - 260, height/2 - 40);
        image (brook, width/2 - 120, height/2 - 40);
        image (bknight, width/2 + 20, height/2 - 40);
        image (bbishop, width/2 + 160, height/2 - 40);

        textSize(25);
        textAlign(CENTER);
        fill(0);
        text("Promote Your Pawn!", width/2, height/2 - 70);
      }
    }
  }
}




void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}


void mouseReleased() {
  if (firstClick) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    firstClick = false;
  } else {
    if (itsMyTurn && !promo) {
      row2 = mouseY/100;
      col2 = mouseX/100;
      if (!(row2 == row1 && col2 == col1)) {  
        id = 0;
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        myServer.write(id + "," + row1 + "," + col1 + "," + row2 + "," + col2);
        itsMyTurn = false;
        firstClick = true;
      }
    }
  }

  //############## SENDING & SELECTING NEW PIECE ##############
  if (promo) {
    id = 1;
    if (mouseX >= width/2 - 260 && mouseX <= width/2 - 160 && mouseY >= height/2 - 40 && mouseY <= height/2 + 60) { 
      grid[7][col2] = 'Q';
      myServer.write(id + "," + col2 + ","  + 1);
      promo = false;
      firstClick = true;
    }
    if (mouseX >= width/2 - 120 && mouseX <= width/2 - 20 && mouseY >= height/2 - 40 && mouseY <= height/2 + 60) { 
      grid[7][col2] = 'R';
      myServer.write(id + "," + col2 + ","  + 2);
      promo = false;
      firstClick = true;
    }
    if (mouseX >= width/2 + 20 && mouseX <= width/2 + 120 && mouseY >= height/2 - 40 && mouseY <= height/2 + 60) {    
      grid[7][col2] = 'N';
      myServer.write(id + "," + col2 + ","  + 3);
      promo = false;
      firstClick = true;
    }
    if (mouseX >= width/2 + 160 && mouseX <= width/2 + 200 && mouseY >= height/2 - 40 && mouseY <= height/2 + 60) { 
      grid[7][col2] = 'B';
      myServer.write(id + "," + col2 + ","  + 4);
      promo = false;
      firstClick = true;
    }
  }
}
