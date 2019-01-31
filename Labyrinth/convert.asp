#program initial.
modus(1).

#program final.
:- not convert(1).

#program dynamic.
convert(1).

% field
field(X,Y) :- 'field(Y,X).
#show field/2.

% init_on
init_on(X,Y) :- 'init_on(Y,X).
#show init_on/2.

% goal_on
goal_on(X,Y) :- 'goal_on(Y,X).
#show goal_on/2.

% connect
connect(X,Y,N,S,E,W) :- 'field(Y,X), N={'connect(Y,X,n)}, S={'connect(Y,X,s)}, E={'connect(Y,X,e)}, W={'connect(Y,X,w)}, _modus(2).
#show connect/6.

% alternative connect
connect(X,Y,D) :- 'connect(Y,X,D), _modus(1).
#show connect/3.

% max_steps
max_steps(S) :- 'max_steps(S).
#show max_steps/1.
