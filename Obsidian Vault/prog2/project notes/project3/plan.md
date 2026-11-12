three windows to implement:
1. welcome window
2. game window
3. leaderboard window

SFML windows are running over the same loop constantly, and records each event that occurs while the window is open, storing it to an *event* queue. This means my goal is to:
1. Handle events - ask the window what event occurred 
2. Update state - change the data based off of what occurred 
3. Draw - change and draw everything based on the current state, display it 

- This also means that **each of the three windows is a loop with different responses based off the events that can occur** 

As such, it is important to **keep data separate from drawing**.

the *game window* has **three unique elements**: 
1. board
2. mines
3. counter

As such, it would make sense to work from 1->3;

**Welcome Window:** 
![[Pasted image 20261112002046.png]]

- the welcome window has 2 outcomes:
	1. Press the enter key, changes window to the *game window* 
	2. Press the X key, end the program (close the loop)