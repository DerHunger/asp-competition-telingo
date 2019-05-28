
#program initial.
state(0).
maxstep(T) :- T=#max{S:step(S)}.
truck(T) :- fuel(T,L).
package(P) :- at(P,_), goal(P,_).

% every package has to be loaded and unloaded (2*PC) and the truck has to drive at least the number of location with packages where he does not start and locations with goals
minstep(MS) :- PC=#count{P:goal(P,_)}, LC=#count{L:at(P,L), package(P), not at(T,L), truck(T) ; L:goal(_,L)}, MS=2*PC+LC.

#show minstep/1.

#program dynamic.
state(S+1) :- 'state(S).

% select action
%1 {move(P,From,To,Dir) : _player(P), 'at(P, From), _movedir(From,To,Dir)} 1.
%1 {load : tmp(1) ; unload : tmp(2) ; drive : tmp(3)} 1
% drive : , 'fuel(T,F), C<=F
1 {
	load(P,T,L,S) 	: _truck(T), _package(P), 'at(T,L), 'at(P,L), state(S);
	unload(P,T,L,S)	: _truck(T), _package(P), 'at(T,L), 'load(P,T), _goal(P,L), state(S);
	drive(T,L1,L2,S) : _truck(T), 'at(T,L1), _fuelcost(C,L1,L2), state(S)

} 1.
%#show load/4.
%#show unload/4.
%#show drive/4.

% keep packages loaded till unload
load(P,T) :- load(P,T,L,S).
load(P,T) :- 'load(P,T), not unload(P,T,_,_).

at(P,L) :- _package(P), unload(P,T,L,S).
at(P,L) :- _package(P), 'at(P,L), not load(P,_).


at(T,L) :- load(P,T,L,S).
at(T,L) :- unload(P,T,L,S).
at(T,L2) :- drive(T,L1,L2,S).
%#show at/2.

fuel(T,F-C) :- 'fuel(T,F), drive(T,L1,L2,_), _fuelcost(C,L1,L2).
fuel(T,F) :- 'fuel(T,F), load(_,T,_,_).
fuel(T,F) :- 'fuel(T,F), unload(_,T,_,_).
:- fuel(T,F), F<0.

:- drive(T,L1,L2,S), drive(T,L2,L1,S-1).


#program final.
% package has to be at goal
:- _goal(P,L), not at(P,L).

% out3
%:- load(P,T,L,S).
%:- drive(T,L1,L2,S).

% out4
:- state(S), minstep(MS), S<MS.

% don't allow models with more steps that given
%:- state(S), _maxstep(T), S>T.
