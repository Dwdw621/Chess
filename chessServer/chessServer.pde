import processing.net.*;

Server myServer;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2;
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

  println(promo);

  if (!itsMyTurn && !promo) {
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    textAlign(CENTER);
    fill(200);
    textSize(50);
    text("Waiting For Response", width/2, height/2);
  } else {
    fill(0, 0, 0, 0);
  }
}

void receiveMove() {
  Client myclient = myServer.available();
  if (myclient != null) {
    String incoming = myclient.readString();
    int r1 = int(incoming.substring(0, 1));
    int c1 = int(incoming.substring(2, 3));
    int r2 = int(incoming.substring(4, 5));
    int c2 = int(incoming.substring(6, 7));
    grid[r2][c2] = grid[r1][c1];
    grid[r1][c1] = ' ';
    itsMyTurn = true;
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

      if (grid[7][c] == 'P') {
        strokeWeight(4);
        fill(225);
        rect(width/2 - 300, height/2 - 100, 600, 200);

        //OPTION BOXES
        fill(255);
        rect(width/2 - 260, height/2 - 40, 100, 100);
        rect(width/2 - 120, height/2 - 40, 100, 100);
        rect(width/2 + 20, height/2 - 40, 100, 100);
        rect(width/2 + 160, height/2 - 40, 100, 100);

        image (bqueen, width/2 - 260, height/2 - 40);
        image (brook, width/2 - 120, height/2 - 40);
        image (bknight, width/2 + 20, height/2 - 40);
        image (bbishop, width/2 + 160, height/2 - 40);

        textSize(25);
        textAlign(CENTER);
        fill(0);
        text("Promote Your Pawn!", width/2, height/2 - 70);



        promo = true;

        //grid[7][c] = 'Q';
      }
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
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        myServer.write(row1 + "," + col1 + "," + row2 + "," + col2);
        firstClick = true;
        itsMyTurn = false;
      }
    }
  }
}
