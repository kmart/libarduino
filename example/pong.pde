#ifndef WProgram_h
#include <WProgram.h>
#endif

// Arduino Tv framebuffer
// Alastair Parker
// 2007

// Video out voltage levels
#define _SYNC 0x00
#define _BLACK 0x01
#define _GRAY 0x02
#define _WHITE 0x03

// dimensions of the screen
#define WIDTH 38
#define HEIGHT 14

// number of lines to display
#define DISPLAY_LINES 240

// update speed for the main loop of the game
#define UPDATE_INTERVAL 1

// positions of the player paddles
#define PLAYER_RIGHT_X 35
#define PLAYER_LEFT_X 2

// maximum velocity of the ball
#define MAX_VEL 10

// locations of the top and bottom virtual bars
#define SCORE_BAR 3
#define BASE_BAR 13

// time to wait while paused
#define DONE_WAITING 30
#define SCORE_WAITING 30

// max player life
#define MAX_LIFE 6

// positions of player life bars
#define PLAYER_LEFT_LIFE 2
#define PLAYER_RIGHT_LIFE 23

// input pins for the player pots
#define PLAYER_LEFT_PIN 2                       \
// currently the same pin
#define PLAYER_RIGHT_PIN 3

// video pins
#define DATA_PIN 9
#define SYNC_PIN 8

// the video frameBuffer
byte frameBuffer[WIDTH][HEIGHT];

// loop indices
byte index, index2;

// pal video line loop
byte line;
// current drawing line in framebuffer
byte newLine;

// flag used in wait loop to indicate that player just scored
boolean justScored = false;

// positions for the left paddle
byte playerLeft;
byte playerLeftOld = -1;
// life for the left player
byte playerLeftLife = MAX_LIFE;

// positions of the right paddle
byte playerRight;
byte playerRightOld = -1;
// life for the right player
byte playerRightLife = MAX_LIFE;

// positions and velocity of the ball
int ballXVel = -1;
int ballYVel = -5;
byte ballXPos = 14;
byte ballYPos = 7;

// loop counters to control the velocity of the ball
byte ballXLoop = MAX_VEL;
byte ballYLoop = MAX_VEL;

// loop counter to for the main loop delay
int waitingCount = 0;

// start postion of the loading bar
byte loadingBar = 2;

// if the left player should be updated or the right
boolean playerLeftTurn = true;

// if we should be waiting for something to happen
boolean waiting = true;
// if displaying the title
boolean showingTitle = true;

// value of the counter controlling the freq of updates
byte updateCounter = 0;

// init the variables
void initGame()
{
   playerLeftOld = -1;
   playerLeftLife = MAX_LIFE;
   playerRightOld = -1;
   playerRightLife = MAX_LIFE;
   ballXVel = -1;
   ballYVel = -5;
   ballXPos = 14;
   ballYPos = 7;
   ballXLoop = MAX_VEL;
   ballYLoop = MAX_VEL;
   waitingCount = 0;
   loadingBar = 2;
   playerLeftTurn = true;
   waiting = true;
   showingTitle = true;
   justScored = false;
   updateCounter = 0;
}

// draw a pixel to the buffer
void setPixel(byte x, byte y)
{
   frameBuffer[x][y] = _WHITE;
}

void grayPixel(byte x, byte y)
{
   frameBuffer[x][y] = _GRAY;
}

// draw a black pixel to the buffer
void clearPixel(byte x,byte y)
{
   frameBuffer[x][y] = _BLACK;
}

// draw a paddle
void drawPaddle(byte x,byte y,byte col)
{
   frameBuffer[x][y] = col;
   frameBuffer[x][y+1] = col;
}

// draw the title message
void drawArduinoPong()
{
// arduino
   setPixel(7,3);
   setPixel(8,3);
   setPixel(15,3);
   setPixel(21,3);
   setPixel(6,4);
   setPixel(8,4);
   setPixel(14,4);
   setPixel(15,4);
   setPixel(28,4);
   setPixel(6,5);
   setPixel(7,5);
   setPixel(8,5);
   setPixel(10,5);
   setPixel(11,5);
   setPixel(13,5);
   setPixel(15,5);
   setPixel(17,5);
   setPixel(19,5);
   setPixel(21,5);
   setPixel(23,5);
   setPixel(24,5);
   setPixel(27,5);
   setPixel(29,5);
   setPixel(6,6);
   setPixel(8,6);
   setPixel(10,6);
   setPixel(14,6);
   setPixel(15,6);
   setPixel(18,6);
   setPixel(19,6);
   setPixel(21,6);
   setPixel(23,6);
   setPixel(25,6);
   setPixel(28,6);

// pong
   setPixel(10,8);
   setPixel(11,8);
   setPixel(15,8);
   setPixel(16,8);
   setPixel(19,8);
   setPixel(22,8);
   setPixel(24,8);
   setPixel(25,8);
   setPixel(26,8);
   setPixel(10,9);
   setPixel(12,9);
   setPixel(14,9);
   setPixel(17,9);
   setPixel(19,9);
   setPixel(20,9);
   setPixel(22,9);
   setPixel(24,9);
   setPixel(10,10);
   setPixel(11,10);
   setPixel(14,10);
   setPixel(17,10);
   setPixel(19,10);
   setPixel(21,10);
   setPixel(22,10);
   setPixel(24,10);
   setPixel(26,10);
   setPixel(10,11);
   setPixel(15,11);
   setPixel(16,11);
   setPixel(19,11);
   setPixel(22,11);
   setPixel(24,11);
   setPixel(25,11);
   setPixel(26,11);
}

// do the main game logic regarding the ball and collisions
void updateBall(boolean xEvent)
{
// if checking the x coords of the ball
   if (xEvent)
   {
/*
  TODO

  have the yvel start 1t 1

*/

// check for collision with left player
      if ((ballXPos < PLAYER_LEFT_X + 2) & (playerLeft == ballYPos or playerLeft + 1 == ballYPos))
      {
         ballXVel = -1 * ballXVel;
         ballXPos = PLAYER_LEFT_X + 1;
      }
// check for collision with right player
      if ((ballXPos > PLAYER_RIGHT_X - 2) & (playerRight == ballYPos or playerRight + 1 == ballYPos))
      {
         ballXVel = -1 * ballXVel;
         ballXPos = PLAYER_RIGHT_X - 1;
      }

// move the ball in the x direction
      if (ballXVel < 1)
      {
         ballXPos--;
      }
      else
      {
         ballXPos++;
      }
   }

// if checking the y coords
   if (!xEvent)
   {
// check for top of screen hit
      if ( ballYPos <= SCORE_BAR )
      {
         ballYVel = -1 * ballYVel;
         ballYPos = SCORE_BAR;
      }
// check for bottom of screen hit
      if ( ballYPos>BASE_BAR )
      {
         ballYVel = -1 * ballYVel;
         ballYPos = BASE_BAR + 1;
      }

// move the ball in the y direction
      if (ballYVel < 1)
      {
         ballYPos--;
      }
      else
      {
         ballYPos++;
      }
   }

// always check for scoring of points

// right player scores
   if (ballXPos == PLAYER_LEFT_X)  // 0
   {
// reset the position of the ball
      ballXPos = PLAYER_RIGHT_X - 5;
      ballYPos = 7;

// change the other players life
      clearPixel(PLAYER_LEFT_LIFE + 2 * playerLeftLife - 2, SCORE_BAR - 1);
      playerLeftLife--;

// indicate that someone scored so the wait doesn't start a new game
      justScored = true;
// indicate that we should wait next loop
      waiting = true;

// check if game is over
      if (playerLeftLife == 0)
         justScored = false;
   }

// left player scores
   if (ballXPos == PLAYER_RIGHT_X)  // 38
   {
// reset position of ball
      ballXPos = PLAYER_LEFT_X + 5;
      ballYPos = 7;

// update other players score
      clearPixel(PLAYER_RIGHT_LIFE + 2 * (MAX_LIFE - playerRightLife) + 2, SCORE_BAR - 1);
      playerRightLife--;

// indicate that someone scored so the wain doesn't start a new game
      justScored = true;
// indicate that we should wait next loop
      waiting = true;

// check for game over
      if (playerRightLife == 0)
         justScored = false;
   }
}

// draw the player life bars
void initScreen()
{
   for (index = 1; index <= MAX_LIFE; ++index)
   {
      grayPixel(index * 2, SCORE_BAR - 1);
      grayPixel(index * 2 + PLAYER_RIGHT_LIFE, SCORE_BAR - 1);
   }
}

// draw the ball
void drawBall(byte col)
{
   frameBuffer[ballXPos][ballYPos] = col;
}

// clear the screen
void clearScreen()
{
   for (index = 0; index < WIDTH; index++)
      for (index2 = 0; index2 <= HEIGHT; ++index2)
      {
         frameBuffer[index][index2] = _BLACK;
      }
}

// the setup routine
void setup()
{
   cli();
   pinMode (SYNC_PIN, OUTPUT);
   pinMode (DATA_PIN, OUTPUT);
   digitalWrite (SYNC_PIN, HIGH);
   digitalWrite (DATA_PIN, HIGH);
   clearScreen();
   drawArduinoPong();
}

void loop()
{
// iterate over the lines on the tv
   for (line = 0; line < DISPLAY_LINES; ++line)
   {
// HSync
// front porch (1.5 us)
      PORTB = _BLACK;
      delayMicroseconds(1.5);
// sync (4.7 us)
      PORTB = _SYNC;
      delayMicroseconds(4.7);
// breezeway (.6us) + burst (2.5us) + colour back borch (1.6 us)
      PORTB = _BLACK;
      delayMicroseconds(0.6+2.5+1.6);

// calculate which line to draw to
      newLine = line >> 4;
      delayMicroseconds(1);

// display the array for this line
// a loop would have been smaller, but it messes the timing up
      PORTB = frameBuffer[ 0][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 1][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 2][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 3][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 4][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 5][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 6][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 7][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 8][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[ 9][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[10][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[11][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[12][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[13][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[14][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[15][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[16][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[17][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[18][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[19][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[20][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[21][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[22][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[23][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[24][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[25][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[26][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[27][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[28][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[29][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[30][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[31][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[32][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[33][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[34][newLine];
      delayMicroseconds(1);
      PORTB = frameBuffer[35][newLine];
      delayMicroseconds(1);

// klugdge to correct timings
      PORTB = frameBuffer[36][newLine];
      PORTB = PORTB;
      PORTB = PORTB;
      PORTB = PORTB;
      delayMicroseconds(3);
   }

// vsync
   PORTB = _SYNC;

// if delaying for some reason
   if (waiting)
   {
// increment the waiting counter
      waitingCount++;

// if waiting is over for a new game
      if ((waitingCount == DONE_WAITING) & !justScored)
      {
         waitingCount = 0;
// if on title screen
         if (showingTitle)
         {
// draw the loading bar
            grayPixel(loadingBar, BASE_BAR);
            loadingBar += 2;

// done loading
            if (loadingBar > 37)
            {
               showingTitle = false;
               clearScreen();
               initGame();
               initScreen();
               waiting = false;
            }
         }
      }

// waiting because someone scored
      if ((waitingCount == SCORE_WAITING) & justScored)
      {
         justScored = false;
         waitingCount = 0;
         waiting = false;
      }
// wait for the remainder of the sync period
      delayMicroseconds(305);
   }
// not waiting
   else
   {
// increment the update delay counter
      updateCounter++;
      if ( updateCounter >= UPDATE_INTERVAL)
      {
// player movement
         if (playerLeftTurn)
         {
            drawPaddle(PLAYER_LEFT_X, playerLeftOld, _BLACK);
            playerLeft = analogRead(PLAYER_LEFT_PIN) >> 6;
            if (playerLeft < SCORE_BAR)
               playerLeft = SCORE_BAR;
            if (playerLeft > BASE_BAR)
               playerLeft = BASE_BAR;
            drawPaddle(PLAYER_LEFT_X, playerLeft, _WHITE);
            playerLeftOld = playerLeft;
            playerLeftTurn = false;
         }
         else
         {
            drawPaddle(PLAYER_RIGHT_X, playerRightOld, _BLACK);
            playerRight = analogRead(PLAYER_RIGHT_PIN) >> 6;
            if (playerRight < SCORE_BAR)
               playerRight = SCORE_BAR;
            if (playerRight > BASE_BAR)
               playerRight = BASE_BAR;
            drawPaddle(PLAYER_RIGHT_X, playerRight, _WHITE);
            playerRightOld = playerRight;
            playerLeftTurn = true;
         }
// remainder of sync period
         delayMicroseconds(10);
         updateCounter = 0;
      }
      else
// remainder of sync period
         delayMicroseconds(250);

// perform ball x velocity delay
      ballXLoop--;
      if (ballXLoop <= abs(ballXVel) and ballXVel != 0)
      {
// ball movement;
         drawBall(_BLACK);
         updateBall(true);
         ballXLoop = MAX_VEL;
      }

// perform ball y velocity delay
      ballYLoop--;
      if (ballYLoop <= abs(ballYVel) and ballYVel != 0)
      {
// ball movement;
         drawBall(_BLACK);
         updateBall(false);
         ballYLoop = MAX_VEL;
      }
// draw new ball
      drawBall(_GRAY);
   }
}
