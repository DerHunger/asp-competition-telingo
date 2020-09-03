%*
telingo encoding for Ricochet Robots problem from the ASP Competition 2013
( https://www.mat.unical.it/aspcomp2013/OfficialProblemSuite )
*%

#program initial.
step(0).

dir(north, -1,  1).			% direction, sub, column
dir(south,  1,  1).			% direction, add, column
dir(east,   1, -1).			% direction, add, row
dir(west,  -1, -1).			% direction, sub, row
inverseDir(north,south).	% inverse directions
inverseDir(south,north).
inverseDir(east,west).
inverseDir(west,east).
robot(R) :- pos(R,_,_).		% all robots
maxdim(X) :- X=#max{M:dim(M)}.
mindim(X) :- X=#min{M:dim(M)}.

% add missing barriers
% column
barrier(X,Y+Val,IDir) :- barrier(X,Y,Dir), inverseDir(Dir,IDir), dir(Dir, Val,  1), dim(Y+Val).
% row
barrier(X+Val,Y,IDir) :- barrier(X,Y,Dir), inverseDir(Dir,IDir), dir(Dir, Val, -1), dim(X+Val).

% outer barriers
barrier(X,Y,north) :- dim(X), mindim(Y).
barrier(X,Y,south) :- dim(X), maxdim(Y).
barrier(X,Y,east) :- maxdim(X), dim(Y).
barrier(X,Y,west) :- mindim(X), dim(Y).

#program dynamic.
step(S+1) :- 'step(S).

% Select robot
1 {goRobot(R) : _robot(R)} 1.
% select Direction
1 {goDir(Dir,Val,Ori) : _dir(Dir,Val,Ori)} 1.
% prevent non-selectable direction
:- goDir(Dir,Val,Ori), goRobot(R), 'pos(R,X,Y), _barrier(X,Y,Dir).

% robot can't move the same row/column (Ori) as in the move before
:- goRobot(R), 'goRobot(R), goDir(_,_,Ori), 'goDir(_,_,Ori).

% position on all not moving robots
pos(R,X,Y) :- _robot(R), not goRobot(R), 'pos(R,X,Y).

% robot moves north/south
pos(R,Xp,Yn) :- goRobot(R), 'pos(R,Xp,Yp), goDir(Dir,-1,  1), Yn=#max{Y2+1 : 'pos(R2,Xp,Y2), R2!=R, Y2<Yp ; Y2 : _barrier(Xp,Y2,Dir), Y2<Yp}.
pos(R,Xp,Yn) :- goRobot(R), 'pos(R,Xp,Yp), goDir(Dir, 1,  1), Yn=#min{Y2-1 : 'pos(R2,Xp,Y2), R2!=R, Y2>Yp ; Y2 : _barrier(Xp,Y2,Dir), Y2>Yp}.

%robot moves east/west
pos(R,Xn,Yp) :- goRobot(R), 'pos(R,Xp,Yp), goDir(Dir, 1, -1), Xn=#min{X2-1 : 'pos(R2,X2,Yp), R2!=R, X2>Xp ; X2 : _barrier(X2,Yp,Dir), X2>Xp}.
pos(R,Xn,Yp) :- goRobot(R), 'pos(R,Xp,Yp), goDir(Dir,-1, -1), Xn=#max{X2+1 : 'pos(R2,X2,Yp), R2!=R, X2<Xp ; X2 : _barrier(X2,Yp,Dir), X2<Xp}.

% moving robot should not stay in same position
:- goRobot(R), 'pos(R,X,Y), pos(R,X,Y).

#program final.
% target robot has to be on the target field
:- _target(R,X,Y), not pos(R,X,Y).

% ignore all solutions with less steps than provided length
:- step(S), _length(L), S<L.

% final robot has to be the target robot
:- goRobot(R1), _target(R2,_,_), R1 != R2.
% before last step: target robot has to be in line with target
:- 'pos(R,XR,YR), _target(R,XT,YT), XR!=XT, YR!=YT.

%*
% competition output
#program dynamic.
go(R,Dir,S) :- goRobot(R), goDir(Dir,_,_), step(S).
#show go/3.
*%
