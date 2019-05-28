#program initial.
state(0).

tmp(1).
#show tmp/1.

dir(dir_right).
dir(dir_left).
dir(dir_up).
dir(dir_down).

inverseDir(dir_right,dir_left).
inverseDir(dir_left,dir_right).
inverseDir(dir_up,dir_down).
inverseDir(dir_down,dir_up).

% generate dead position
% corners, 2 movedir which do not have inverse directions
deadcorner(Pos) :- isnongoal(Pos), 2 = #count{Dir : movedir(Pos,To,Dir)}, movedir(Pos,_,Dir1), movedir(Pos,_,Dir2), Dir1 != Dir2, not inverseDir(Dir1,Dir2).
% dips, 1 movedir (3 walls)
deaddip(Pos) :- isnongoal(Pos), 1 = #count{Dir : movedir(Pos,To,Dir)}.
% wall between 2 corners and/or dips
deadWall(Pos2,Dir) :- isnongoal(Pos2), deadcorner(Pos1), deadComb(Pos1,Pos2), movedir(Pos1,Pos2,Dir).
deadWall(Pos2,Dir) :- isnongoal(Pos2), deaddip(Pos1), deadComb(Pos1,Pos2), movedir(Pos1,Pos2,Dir).
deadWall(Pos2,Dir) :- isnongoal(Pos2), deadWall(Pos1,Dir), deadComb(Pos1,Pos2), movedir(Pos1,Pos2,Dir).
deadWall(Pos) :- deadWall(Pos,Dir1), deadWall(Pos,Dir2), inverseDir(Dir1,Dir2).

dead(Pos) :- deadcorner(Pos).
dead(Pos) :- deaddip(Pos).
dead(Pos) :- deadWall(Pos).

% generate dead combinations:
% 1:	2:
% |S	|S
% |S	 S|
% in these combinations the stones can not be moved, obviously in all rotations
% if both are goals it has to be allowed

deadComb(P1,P2) :- isnongoal(P1), movedir(P1,P2,Dir1), movedir(P2,P1,Dir2), inverseDir(Dir1,Dir2), dir(Dir3), Dir3!=Dir1, Dir3!=Dir2, not movedir(P1,_,Dir3), not movedir(P2,_,Dir3).

deadComb(P1,P2) :- isnongoal(P1), movedir(P1,P2,Dir1), movedir(P2,P1,Dir2), inverseDir(Dir1,Dir2), dir(Dir3), Dir3!=Dir1, Dir3!=Dir2, inverseDir(Dir3,Dir4), not movedir(P1,_,Dir3), not movedir(P2,_,Dir4).


#program dynamic.
state(S+1) :- 'state(S).

% select a direction for the sokoban to move
1 {move(P,From,To,Dir) : _player(P), 'at(P, From), _movedir(From,To,Dir)} 1.

% testing atom
move(P,Dir) :- move(P,_,_,Dir).

% update player position
at(P,To) :- move(P,From,To,Dir).

% generate push if player moves "on" stone
push(P,Stone,Pos2,Pos3,Dir) :- move(P,Pos1,Pos2,Dir), 'at(Stone,Pos2), _stone(Stone), _movedir(Pos2,Pos3,Dir).

% update pushed stone position
at(Stone,To) :- push(P,Stone,From,To,Dir).

% update not pushed stone position
at(Stone,Pos) :- _stone(Stone), 'at(Stone,Pos), not push(_,Stone,_,_,_).

% 2 objects (player, stone) can not be on the same position
:- at(S1, Pos), at(S2, Pos), S1!=S2.

% no reverse move without push
%:- move(P,Dir), _inverseDir(Dir,IDir), 'move(P,IDir), not 'push(P,_,_,_,IDir).

% stone should not be in a dead position
:- _stone(Stone), at(Stone,Pos), _dead(Pos).

% stones should not be in dead combinations
:- _stone(S1), _stone(S2), S1!=S2, at(S1,Pos1), at(S2,Pos2), _deadComb(Pos1,Pos2).


% output atoms
%*
move(p,from,to,dir,t): at step t, the sokoban p is moved from 'from' to 'to' in direction 'dir'.
	This action is allowed if 'to' is clear, the sokoban was previously at 'from' and 'from' and 'to' are properly connected.
*%
move(P,From,To,Dir,T) :- move(P,From,To,Dir), state(T), not push(P,_,To,_,Dir).
#show move/5.

%*
pushtonongoal(p,s,ppos,from,to,dir,t): at step t, the sokoban p pushes the stone s in direction 'dir', from location 'from' to location 'to'.
	The sokoban itself moves from 'ppos' to 'from'.
	This actions is allowed if: ppos, from and to are either vertically of horizontally consecutive locations; 'to' is not a goal location and is clear; s was previously at 'from' and p was previously at 'ppos'.
*%
pushtonongoal(P,Stone,Pos1,Pos2,Pos3,Dir,T) :- move(P,Pos1,Pos2,Dir), push(P,Stone,Pos2,Pos3,Dir), state(T), _isnongoal(Pos3).
#show pushtonongoal/7.

%*
pushtogoal(p,s,ppos,from,to,dir,t): same as above, but 'to' must be a goal location as a prerequisite.
*%
pushtogoal(P,Stone,Pos1,Pos2,Pos3,Dir,T) :- move(P,Pos1,Pos2,Dir), push(P,Stone,Pos2,Pos3,Dir), state(T), _isgoal(Pos3).
#show pushtogoal/7.


#program final.
%don't finish as long as a goal does not have a stone on its position
:- _goal(Stone), not _isgoal(Pos), at(Stone,Pos).
