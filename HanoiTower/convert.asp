%*
converts the hanoi tower problem of the ASP Competition ( https://www.mat.unical.it/aspcomp2013/HanoiTower ) to a more easy to understanding problem. The converted problem will be like the hanoi tower problem from the clingo guide ( https://github.com/potassco/guide/releases/ )

Given (State 0):
steps(S) - number of steps to solve the problem
time(T) - time steps T=(1..S)
disk(D) - the first 4 disks are the pegs, everything above are the real disks
on0(D1, D2) - initial position of disk D1, it is on disk D2
ongoal(D1, D2) - final position of disk D1 is on disk D2
put(T, D1, D2) - put disk D1 on D2 in step T, solution atoms to be determined


Converted (State 1):
moves(S) - number of steps to solve the problem
time(T) - time steps T=(1..S)
peg(P) - all pegs
disk(D) - all disks
init_on(D,P) - initial position of disk D on peg P
goal_on(D,P) - final position of disk D on peg P
move(D,P,T) - move disk D to peg P in step T

*%

#program final.
:- not convert(1).

#program dynamic.
convert(1).

% the first 4 disks are pegs
peg(A) :- 'disk(A), A=(1..4).
#show peg/1.

% every disk above 4 is a disk, decrease disk number by 4
disk(A) :- 'disk(D), A=D-4, D>4.
#show disk/1.

% steps is moves
moves(S) :- 'steps(S).
#show moves/1.

% time is time, not needed
% time(T) :- 'time(T).

% on0 to init_on
% first disk on each peg can be taken over, decrease disk number by 4
init_on(D-4,P) :- 'on0(D,P), P=(1..4), D>4.
% every disk that was on another disk gets put on a peg, decrease disk number by 4
init_on(D1-4,P) :- 'on0(D1,D2), init_on(D2-4,P), D1>4.
#show init_on/2.

% ongoal is goal_on
% first disk on each peg can be taken over, decrease disk number by 4
goal_on(D-4,P) :- 'ongoal(D,P), P=(1..4), D>4.
% every disk that was on another disk gets put on a peg, decrease disk number by 4
goal_on(D1-4,P) :- 'ongoal(D1,D2), goal_on(D2-4,P), D1>4.
#show goal_on/2.
