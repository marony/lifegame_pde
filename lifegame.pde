final int canvas_width = 600;
final int canvas_height = 400;
final int life_width = 8;
final int life_height = 8;

// for processing.js
// move member variables to global
int wc;
int hc;
boolean[][] board;

class Board {
 
  public Board() {
    wc = canvas_width / life_width;
    hc = canvas_height / life_height;
    board = initializeBoard();
    
    board[10][0] = true;
    board[10][1] = true;
    board[10][2] = true;
    board[11][0] = true;
    board[12][1] = true;
    //board[2][5] = true;
    //board[2][6] = true;
    //board[2][7] = true;
  }
  
  public boolean[][] initializeBoard() {
    boolean[][] b = new boolean[hc][];
    for (int y = 0; y < hc; ++y)
      b[y] = new boolean[wc];
    return b;
  }
  
  public void draw() {
    stroke(64, 64, 64);
    for (int x = 0; x < canvas_width; x += life_width) {
      line(x, 0, x, canvas_height);
    }
    for (int y = 0; y < canvas_height; y += life_height) {
      line(0, y, canvas_width, y);
    }
    noStroke();
    for (int x = 0; x < wc; ++x) {
      for (int y = 0; y < hc; ++y) {
        if (board[y][x])
          fill(255, 255, 255);
        else
          fill(0, 0, 0);
        rect(x * life_width + 1, y * life_height + 1, life_width - 1, life_height - 1);
      }
    }
  }
  
  public int getLives(int x, int y) {
    final int m[] = { -1, -1,  0, -1, +1, -1,
                      -1,  0,         +1,  0,
                      -1, +1,  0, +1, +1, +1 };
                      
    int c = 0;
    for (int i = 0; i < m.length; i += 2) {
      int dx = x + m[i];
      if (dx < 0)
        dx += wc;
      dx = dx % wc;
      int dy = y + m[i + 1];
      if (dy < 0)
        dy += hc;
      dy = dy % hc;
      if (board[dy][dx])
        c += 1;
    }
    return c;
  }
  
  public void next() {
    boolean[][] nextBoard = initializeBoard();
    for (int x = 0; x < wc; ++x) {
      for (int y = 0; y < hc; ++y) {
        int c = getLives(x, y);
        if (board[y][x])
          nextBoard[y][x] = (c == 2 || c == 3);
        else
          nextBoard[y][x] = (c == 3);
      }
    }
    board = nextBoard;
  }
  
  public void flip(int x, int y) {
    int dx = x / life_width;
    if (dx < 0)
      dx += wc;
    dx = dx % wc;
    int dy = y / life_height;
    if (dy < 0)
      dy += hc;
    dy = dy % hc;
    board[dy][dx] = !board[dy][dx];
  }
}

Board board = new Board();
PFont font = null;
boolean paused = false;

void settings() {
  // for processing
  //size(canvas_width, canvas_height);
}

void setup() {
  // for processing.js
  size(canvas_width, canvas_height);
  font = createFont("", 24);
  frameRate(10);
  background(0, 0, 0);
}

void draw() {
  board.draw();
  
  textFont(font);
  fill(255, 0, 0);
  if (!paused) {
    board.next();
    text("Playing", 0, canvas_height);
  } else
    text("Paused", 0, canvas_height);
}

void mousePressed() {
  if (mouseButton == LEFT)
    paused = !paused;
  else if (mouseButton == RIGHT)
    board.flip(mouseX, mouseY);
}
