#program initial.
state(0).

dir(dir_right).
dir(dir_left).
dir(dir_up).
dir(dir_down).

inverseDir(dir_right,dir_left).
inverseDir(dir_left,dir_right).
inverseDir(dir_up,dir_down).
inverseDir(dir_down,dir_up).

% dead combinations:
% two adjacent stones with walls in the same or inverse direction
% neither stone can be pushed out of this combination
deadComb(Pos1,Pos2) :- isnongoal(Pos1), movedir(Pos1,Pos2,Dir1), movedir(Pos2,Pos1,Dir2),
                   inverseDir(Dir1,Dir2), dir(Dir3), Dir3!=Dir1, Dir3!=Dir2,
                   not movedir(Pos1,_,Dir3), not movedir(Pos2,_,Dir3).

deadComb(Pos1,Pos2) :- isnongoal(Pos1), movedir(Pos1,Pos2,Dir1), movedir(Pos2,Pos1,Dir2),
                   inverseDir(Dir1,Dir2), dir(Dir3), Dir3!=Dir1, Dir3!=Dir2,
                   inverseDir(Dir3,Dir4), not movedir(Pos1,_,Dir3), not movedir(Pos2,_,Dir4).

% dead position:
% a stone is stuck and can't be moved away
% corner, 2 movedir which are not inverse directions
deadcorner(Pos1) :- isnongoal(Pos1), 2 = #count{Dir : movedir(Pos1,Pos2,Dir)},
                    movedir(Pos1,_,Dir1), movedir(Pos1,_,Dir2), Dir1 != Dir2, not inverseDir(Dir1,Dir2).
% dip, 1 movedir (3 walls)
deaddip(Pos1) :- isnongoal(Pos1), 1 = #count{Dir : movedir(Pos1,Pos2,Dir)}.

% dead places between dead positions connected by dead combinations
deadWall(Pos2,Dir) :- isnongoal(Pos2), deadcorner(Pos1), deadComb(Pos1,Pos2), movedir(Pos1,Pos2,Dir).
deadWall(Pos2,Dir) :- isnongoal(Pos2), deaddip(Pos1), deadComb(Pos1,Pos2), movedir(Pos1,Pos2,Dir).
deadWall(Pos2,Dir) :- isnongoal(Pos2), deadWall(Pos1,Dir), deadComb(Pos1,Pos2), movedir(Pos1,Pos2,Dir).
deadWall(Pos) :- deadWall(Pos,Dir1), deadWall(Pos,Dir2), inverseDir(Dir1,Dir2).

dead(Pos) :- deadcorner(Pos).
dead(Pos) :- deaddip(Pos).
dead(Pos) :- deadWall(Pos).

#program dynamic.
state(S+1) :- 'state(S).

% select a direction for the player to move
1 {move(P,Pos1,Pos2,Dir) : _player(P), 'at(P, Pos1), _movedir(Pos1,Pos2,Dir)} 1.

% update player position
at(P,Pos2) :- move(P,Pos1,Pos2,Dir).

% push if player moves "on" stone
push(P,Stone,Pos2,Pos3,Dir) :- move(P,Pos1,Pos2,Dir), 'at(Stone,Pos2), _stone(Stone), _movedir(Pos2,Pos3,Dir).

% update pushed stone position
at(Stone,Pos2) :- push(P,Stone,Pos1,Pos2,Dir).

% update not pushed stone position
at(Stone,Pos) :- _stone(Stone), 'at(Stone,Pos), not push(_,Stone,_,_,_).

% 2 objects (player, stone) can not be on the same position
:- at(S1, Pos), at(S2, Pos), S1!=S2.

% stone should not be in a dead position
:- _stone(Stone), at(Stone,Pos), _dead(Pos).
% stones should not be in dead combinations
:- _stone(S1), _stone(S2), S1!=S2, at(S1,Pos1), at(S2,Pos2), _deadComb(Pos1,Pos2).

% player should not move back unless he pushed a stone
:- 'move(P,Pos1,Pos2,Dir1), move(P,Pos2,Pos1,Dir2), inverseDir(Dir1,Dir2), not 'push(P,_,_,_,_).

% output atoms for compare with asp competition
%*
move(P,Pos1,Pos2,Dir,T) :- move(P,Pos1,Pos2,Dir), state(T), not push(P,_,Pos2,_,Dir).
pushtonongoal(P,Stone,Pos1,Pos2,Pos3,Dir,T) :- move(P,Pos1,Pos2,Dir), push(P,Stone,Pos2,Pos3,Dir), state(T), _isnongoal(Pos3).
pushtogoal(P,Stone,Pos1,Pos2,Pos3,Dir,T) :- move(P,Pos1,Pos2,Dir), push(P,Stone,Pos2,Pos3,Dir), state(T), _isgoal(Pos3).
#show move/5.
#show pushtonongoal/7.
#show pushtogoal/7.
*%

#program final.
% don't finish as long as a goal does not have a stone on its position
:- _goal(Stone), not _isgoal(Pos), at(Stone,Pos).
