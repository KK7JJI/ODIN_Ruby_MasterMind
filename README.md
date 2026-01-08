# ODIN_Ruby_MasterMind
TOP Ruby Project - Mastermind

## Setup Notes

NOTE: This project is a ruby script.  It was written using ruby version 3.4.6.  Not other dependancies exist.

First clone this repository. To run the application navigate to the /bin directory of the project and make the run.sh script found there executible:

chmod +x run.sh

Once this file is executible the game is initiated by:

./run.sh [args]

(@Windows users, sorry, no help is offered. run.sh is a bash script which should run on most linux and macos systems.)

## Instructions

### Rules
Rules for MasterMind gameplay can be found in various locations on the web.\
[Mastermind on Wikipedia](https://en.wikipedia.org/wiki/Mastermind_(board_game))

In general the game involves 2 players: a code maker and a code guessor.
During a match the code maker creates a secret code consisting of 4 letters
in the range A-F.  The code guesser has 12 chances to guess the secret code.
After each guess the code maker provides the following feedback;

-the number of characters which are both correct and in the correct position.
-the number of characters which are in the solution but are not in the correct position.

Feedback is given one and only one time for __each__ character in the secret code.

Example:

`Secret code = AACC`\
`      Guess = ABAA`

The code maker will report:\

`1 - character correct and in correct position`\
`    (solution and guess A's in the number 1 position)`\
`1 - character correct but in the wrong position`\
`    (solution A in the number 2 position, guess A in the number 3 position)`

The remaining 3rd A in the number 4 position in the guess remains unmatched in
the solution as the 2 A's in the secret code have already been paired with previous
A's in the guess.  No feedback is given.

It's up to the code guesser to use feedback obtained with each guess to deduce
the secret code with the allowed number of guesses.

### Application Instructions
The application is initiated from the command line in a Bash (or similar Bash compatible) shell.
Running the script without parameters will initiate a game where the secret code is 4 characters
long, each position may have one of 6 characters A-F, and the code guesser has 12 guesses.

` ./run.sh`

The game runs through a brief setup process to collect player names and determine the number of sets to be played (1 set = 2 matches with players switching roles).

The optionally the computer can be selected by omitting the player name.  The computer can be made to play itself by omitting names for both player 1 and player 2.  Player 1 will initially act as code maker, Player 2 the code breaker.  Roles are switched between matches.

Player setup Paul (human) and Player 2 (computer)\
Paul (Player 1) will initially act act Code Maker.

```
---------------------------------------------------------
Enter player 1 name: (press enter for computer play)
---------------------------------------------------------
NAME:Paul

NOTE: Paul is a human player.

---------------------------------------------------------
Enter player 2 name: (press enter for computer play)
---------------------------------------------------------
NAME:

NOTE: Player 2 is a computer player.
```

Code Maker's turn (human player):
```
=========================================================================
Player roles are assigned as follows:

  CODEMAKER: Paul (score: 0)
CODEBREAKER: Player 2 (score: 0)
=========================================================================

CODEMAKER: (Paul): Select a code:
---------------------------------------------------------
The secret code contains exactly 4 positions/characters.
There are 6 tokens per position from which to choose
Valid values for each token range from "A" to "F".

The code is not case sensitive, "A" is equivalent to "a".
The code guesser will have 12 guesses to guess the code.
---------------------------------------------------------

  Set Code:
Possible Solutions: 1296

```
The secret code remains hidden while typing.

The Code Breaker's turn (human player)
```
=========================================================================
Guess: 1 of 12
CODEBREAKER: (Paul)
=========================================================================

---------------------------------------------------------
The secret code contains exactly 4 positions/characters.
There are 6 tokens per position from which to choose
Valid values for each token range from "A" to "F".

The code is not case sensitive, "A" is equivalent to "a".
The code guesser will have 12 guesses to guess the code.
---------------------------------------------------------

Your guess: AABB
Possible Solutions: 1296
---------------------------------------------------------
Feedback:
Guess = AABB
1 tokens correct and in correct position
1 tokens correct but in wrong position
```
NOTE: The secret code for this example was "BDBD".

### Game Parameters
Gameplay may be modified using optional command line parameters:

` ./run.sh [positions:n] [choices:n] [guesses:n]`
```
positions:n (default 4) will set the number of positions to n in the secret code.
  choices:n (default 6, A-F) will set the number of valid characters to n.
            Valid chars always start at A and proceed alphabetically.
            Codes are **not** case sensitive.
    guess:n (default 12) will set the number of guesses a code breaker may make to n.
```

Help is available at the command line:

` ./run.sh --help`

## Notes
The computer player in this application generates secret codes by random selection.
Guesses, however, are made according to the minmax algorithm where solution feedback is
compared against the entire space of possible solutions.  Solutions which would not result
in the same feedback as the current feedback are rejected prior to making another guess.

The default game include 4 positions each occupied by 1 of 6 possibile characters which
combined give 4<sup>6 = 1296 unique combinations.  With a small number like this the
computer player rapidly computes solutions.  Selecting larger numbers, however, requires
searching exponentially larger sets of solutions which in turn will require significant time to
solve.

[Mastermind on Wikipedia](https://en.wikipedia.org/wiki/Mastermind_(board_game)#Genetic_algorithm)\
[D.Knuth, "The Computer as Mastermind", J Rec Math Vol 9(1) 1976-77](https://www.cs.uni.edu/~wallingf/teaching/cs3530/resources/knuth-mastermind.pdf)
