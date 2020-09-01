%*
telingo encoding for HanoiTower problem from the clingo guide
( https://github.com/potassco/guide/releases/ )
*%

#program initial.
step(0).
% initial position of all disks
on(D,P) :- init_on(D,P).

% block disks that are already on the goal peg
% and will get disk(s) below (goal)
% and don't have disk below that have to be moved (init)
block(D1) :- init_on(D1,P1), goal_on(D1,P1),
             0 = #count{D2 : goal_on(D2,P1), not block(D2), D2<D1},
             0 = #count{D2 : init_on(D2,P1), not block(D2), D2<D1}.

moveable(D) :- disk(D), not block(D).

#program dynamic.
step(S+1) :- 'step(S).
% generate move
1 { move(D,P) : _moveable(D), _peg(P)} 1.

move(D) :- move(D,_).
to(P) :- move(_,P).

% update the position of the moved disk
on(D,P) :- move(D,P).
% update the position of the not moved disks
on(D,P) :- 'on(D,P), not move(D).

% don't move a disk with a smaller disk (higher value) on it
:- move(D1), 'on(D1,P), 'on(D2,P), D2>D1.
% disk can't be moved to a smaller disk (higher value)
:- move(D1,P), on(D2,P), D1<D2.

% don't move the same disk twice
:- move(D), 'move(D).
% disk can't be moved to current position
:- move(D), 'on(D,P), to(P).

#program final.
% every disk has to be on goal
:- _goal_on(D,P), not on(D,P).
% final step is given with the steps atom
:- step(S), _moves(MS), S<MS.

%*
% competition output
#program dynamic.
% put for compare with asp competition
put(S,TD,BD) :- step(S), move(TD,P), BD = #max{D+4 : 'on(D,P); P}.
#show put/3.

% move/3 for compare with clingo encoding
move(D,P,S) :- move(D,P), step(S).
#show move/3.
*%
