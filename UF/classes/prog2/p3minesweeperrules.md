| CONTENTS  |     |     |     |     | CONTENTS  |     |
| --------- | --- | --- | --- | --- | --------- | --- |

Welcome to the third and final project of the course: Minesweeper. Minesweeper is a classic game, around
since the 1960s. In this project, you will recreate Minesweeper from scratch, using only the c++ standard library
and SFML.
Contents
| 1.  Overview             |     |     |     |     |     | 3   |
| ------------------------ | --- | --- | --- | --- | --- | --- |
| 2.  About: Minesweeper   |     |     |     |     |     | 3   |

2

1 Overview
Minesweeper starts with a rectangular grid of tiles, of two types: mines and non-mines. Initially, all tiles are
hidden from you, so you do not know which tiles are mines and which are not. The goal of Minesweeper is to
reveal all non-mine tiles without revealing any mine tiles. To help you avoid the mines, when a non-mine tile is
revealed, shows the number of mined tiles which neighbor it. You then use this information to deduce the
location of the mines so that you can avoid them.
If you’ve never played the game before, you can find several playable versions of this online:
• http://minesweeperonline.com/
• http://www.freeminesweeper.org/minecore.html Your final version will look
something like this:
Figure 1.1: An example of what your final version will look like.
2 About: Minesweeper
The rules of the game are as follows:
• There exists a board, which contains a grid of spaces. A space could be a mine, or not. The player clicks
on a space, and it gets revealed. The goal of the game is to reveal all the spaces that are not mines, while
avoiding the spaces that are.
• When a space is revealed:
– If it’s a mine, the game ends
– If it’s not a mine, it shows the number of mines adjacent to that space (anywhere from 0 to 8, with
0 just showing as an empty space)
• If a space has no adjacent mines, all non-mine spaces adjacent to it are also revealed. The player uses the
numbers as clues to figure out where other mines may be located. When all of the non-mine spaces have
been revealed, the player wins!
3