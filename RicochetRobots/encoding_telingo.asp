#program initial.

% target robot has to move at least once if target is not in the same row/column
%:- not &tel { &initial ;>: goRobot(Color) ;>: goRobot(Color) }, _target(Color,XT,YT), _pos(Color,XR,YR), (XT!=XR;YT!=YR).
% target robot has to move at least twice if target is not in the same row and column
:- not &tel { &initial ;>: goRobot(Color) ;>: goRobot(Color) }, _target(Color,XT,YT), _pos(Color,XR,YR), XT!=XR, YT!=YR.

step(0).

dir(north, -1,  1).			% direction, sub, column/orientation
dir(south,  1,  1).			% direction, add, column
dir(east,   1, -1).			% direction, add, row
dir(west,  -1, -1).			% direction, sub, row
inverseDir(north,south).	% inverse directions
inverseDir(south,north).
inverseDir(east,west).
inverseDir(west,east).
robot(R) :- pos(R,_,_).		% all robots

% add missing barriers
barrier(X,Y+Val,IDir) :- barrier(X,Y,Dir), inverseDir(Dir,IDir), dir(Dir, Val,  1). % column
barrier(X+Val,Y,IDir) :- barrier(X,Y,Dir), inverseDir(Dir,IDir), dir(Dir, Val, -1). % row
%#show barrier/3.

% possible ways a robot can go from the field
connect(X,Y,Dir) :- dim(X), dim(Y), dir(Dir, Val, 1), dim(Y+Val), not barrier(X,Y,Dir).
connect(X,Y,Dir) :- dim(X), dim(Y), dir(Dir, Val,-1), dim(X+Val), not barrier(X,Y,Dir).
%#show connect/3.


#program dynamic.
step(S+1) :- 'step(S).

% Select robot
1 {goRobot(R) : _robot(R)} 1.
% select direction
1 {goDir(Dir,Val,Ori) : _dir(Dir,Val,Ori), goRobot(R), 'pos(R,X,Y), _connect(X,Y,Dir)} 1.
% output atom
go(R,Dir,S) :- goRobot(R), goDir(Dir,_,_), step(S).
#show go/3.

% robot can't move the same row/column (Ori) as in the move before
:- goRobot(R), 'goRobot(R), goDir(_,_,Ori), 'goDir(_,_,Ori).
% für initial gibt es diese möglichkeit?
%:- &tel {goRobot(Color) & goDir(Dir1,Val1,Ori) ;> goRobot(Color) & goDir(Dir2,Val2,Ori)}, _robot(Color), _dir(Dir1,Val1,Ori), _dir(Dir2,Val2,Ori).


% same orientation move - increases choices?
% prevent the same orientation move of the same robots in a row
%blockOri(R,Ori) :- 'goDir(_,_,Ori), 'goRobot(R), goDir(_,_,Ori).
%:- blockOri(R,Ori), goDir(_,_,Ori), goRobot(R).
%blockOri(R1,Ori) :- 'blockOri(R1,Ori), blockOri(R2,Ori), R1!=R2.
%#show blockOri/2.

% block line - increases choices?
% block the line the robot has moved until another robot moves to this line
% TODO: for release: check if other robot moved to the same segment (no barrier between)
%blocked(R,Ori,X) :- 'goRobot(R), 'goDir(_,_,Ori), 'pos(R,X,Y), Ori=1.
%blocked(R,Ori,Y) :- 'goRobot(R), 'goDir(_,_,Ori), 'pos(R,X,Y), Ori=-1.
%blocked(R1,Ori,I) :- 'blocked(R1,Ori,I), 'goRobot(R2), 'pos(R2,X,Y), Ori= 1, Y!=I.
%blocked(R1,Ori,I) :- 'blocked(R1,Ori,I), 'goRobot(R2), 'pos(R2,X,Y), Ori=-1, X!=I.
%:- blocked(R,Ori,_), goRobot(R), goDir(_,_,Ori).


%blocked fields by other robots
blocked(X,Y) :- _robot(R), not goRobot(R), 'pos(R,X,Y).

% all fields the robot passes when moving
reach(X,Y) :- 'pos(R,X,Y), goRobot(R).
reach(X,Y+Val) :- reach(X,Y), goDir(Dir,Val, 1), _dim(Y+Val), not _barrier(X,Y,Dir), not blocked(X,Y+Val).
reach(X+Val,Y) :- reach(X,Y), goDir(Dir,Val,-1), _dim(X+Val), not _barrier(X,Y,Dir), not blocked(X+Val,Y).

%position on all not moving robots
pos(R,X,Y) :- _robot(R), not goRobot(R), 'pos(R,X,Y).
% final field the robot reaches when moving
pos(R,X,Y) :- goRobot(R), reach(X,Y), goDir(Dir,Val, 1), not reach(X,Y+Val).
pos(R,X,Y) :- goRobot(R), reach(X,Y), goDir(Dir,Val,-1), not reach(X+Val,Y).
%#show pos/3.


#program final.
% target robot has to be on the target field
:- _target(R,X,Y), not pos(R,X,Y).

% ignore all solutions with less steps than provided length, might ignore better solution
% speedup for less than length, since it can just ignore those
:- step(S), _length(L), S<L.

% final robot has to be the target robot
:- goRobot(R1), _target(R2,_,_), R1 != R2.
% before last step: target robot has to be in line with target
:- 'pos(R,XR,YR), _target(R,XT,YT), XR!=XT, YR!=YT.

% test - step
%:- step(0).
%:- step(1).
%:- step(2).
%:- step(3).
%:- step(4).
%:- step(5).
%:- step(6).
%:- step(7).
