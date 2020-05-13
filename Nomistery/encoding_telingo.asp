
#program initial.
state(0).
maxstep(T) :- T = #max{S:step(S)}.
truck(T) :- fuel(T,L).
package(P) :- at(P,_), goal(P,_).

% minimum number of steps:
%   - number of packages to load and unload
%   - number of locations that have a package pickup or destination
minstep(MS) :- MS=2*PC+LC, PC = #count{P:goal(P,_)},
               LC = #count{L:at(P,L), package(P), not at(T,L), truck(T) ; L:goal(_,L)}.

#program dynamic.
state(S+1) :- 'state(S).

% select action
1 {occurs(load;unload;drive)} 1.
% select option for action
1 {load(P,T,L,S) : _truck(T), _package(P), 'at(T,L), 'at(P,L), state(S)} 1 :- occurs(load).
1 {unload(P,T,L,S) : _truck(T), _package(P), 'at(T,L), 'load(P,T), _goal(P,L), state(S)} 1 :- occurs(unload).
1 {drive(T,L1,L2,S) : _truck(T), 'at(T,L1), _fuelcost(C,L1,L2), state(S)} 1 :- occurs(drive).

% keep packages loaded till unload
load(P,T) :- load(P,T,L,S).
load(P,T) :- 'load(P,T), not unload(P,T,_,_).

% update package locations
at(P,L) :- _package(P), unload(P,T,L,S).
at(P,L) :- _package(P), 'at(P,L), not load(P,_).

% update truck location
at(T,L) :- load(P,T,L,S).
at(T,L) :- unload(P,T,L,S).
at(T,L2) :- drive(T,L1,L2,S).

% update fuel consumption
fuel(T,F-C) :- 'fuel(T,F), drive(T,L1,L2,_), _fuelcost(C,L1,L2).
fuel(T,F) :- 'fuel(T,F), load(_,T,_,_).
fuel(T,F) :- 'fuel(T,F), unload(_,T,_,_).
:- fuel(T,F), F<0.

#program final.
% all packages have to be at their goal
:- _goal(P,L), not at(P,L).

% remove path with insufficient steps
:- state(S), minstep(MS), S<MS.
