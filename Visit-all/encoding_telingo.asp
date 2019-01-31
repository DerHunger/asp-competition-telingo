%*
telingo encoding for Visit-all problem from the ASP Competition 2013 ( https://www.mat.unical.it/aspcomp2013/OfficialProblemSuite )
Arguments:
P - position
PP - previous position
S - state
*%

#program always.
% mark current position as visited
visited(P) :- at(P).

#program initial.
state(0).
% only one position can be visited at a time/state, first place is already visited in state 0
min_state(S-1) :- S=#count{P:visit(P)}.

#program dynamic.
state(S+1) :- 'state(S).

% select new position
1{at(P) : 'at(PP), _connected(PP,P)}1.
% keep all visited positions
visited(P) :- 'visited(P).
% move for compare with asp competition
move(PP,P,S) :- 'at(PP), at(P), state(S).
#show move/3.


#program final.
% every position has to be visited
:- _visit(P), not visited(P).
% no solution if the current state is smaller than minimum required
:- state(S), _min_state(MS), S<MS.
