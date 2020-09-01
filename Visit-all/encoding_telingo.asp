%*
telingo encoding for Visit-all problem from the ASP Competition 2013
( https://www.mat.unical.it/aspcomp2013/OfficialProblemSuite )
*%

#program initial.
state(0).
% minimum number of places to be visited, starting places is already visited
min_state(S-1) :- S=#count{P:visit(P)}.

#program always.
% mark current position as visited
visited(P) :- at(P).

#program dynamic.
state(S+1) :- 'state(S).

% select a new position from connected previous position
1{at(P) : 'at(PP), _connected(PP,P)}1.
% keep all visited positions
visited(P) :- 'visited(P).

#program final.
% every position has to be visited
:- _visit(P), not visited(P).
% no solution if the current state is smaller than minimum required
:- state(S), _min_state(MS), S<MS.

%*
% competition output
#program dynamic.
move(PP,P,S) :- 'at(PP), at(P), state(S).
#show move/3.
*%
