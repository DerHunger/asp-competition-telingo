



#program initial.
%:- not &tel { &initial ;> go(red,east,1) ;> go(red,south,2);> go(blue,north,3) ;> go(blue,east,4) ;> go(red,north,5) }.
%
step(0).
robot(R) :- pos(R,_,_).

inverse(east,west). inverse(west,east).				% reverese directions
inverse(north,south). inverse(south,north).
vertical(north,-1). vertical(south,1).			% vertical directions
horizontal(east,1). horizontal(west,-1).		% horizontal directions

dir(north,-1).
dir(south, 1).
dir(east,  1).
dir(west, -1).


% create missing barriers
barrier(X,Y+V,DI) :- barrier(X,Y,D), vertical(D,V), dim(X), dim(Y), dim(Y+V), inverse(D,DI).
barrier(X+V,Y,DI) :- barrier(X,Y,D), horizontal(D,V), dim(X), dim(Y), dim(X+V), inverse(D,DI).

%#show barrier/3.

%:- not &tel {go(red,north,5) ;> &final}.

#program dynamic.
step(S+1) :- 'step(S).

% Select robot
1 {gor(R) : _robot(R)} 1.
% select direction
1 {god(D,V) : _dir(D,V)} 1.

% output atom
go(R,D,S) :- gor(R), god(D,V), step(S).

% prevent reverse moves
:- gor(R), 'gor(R), _inverse(D,DI), god(D,_), 'god(DI,_).


% prevent out of bounce moves
:- 'pos(R,X,Y), gor(R), god(D,V), _vertical(D,V), not _dim(Y+V).
:- 'pos(R,X,Y), gor(R), god(D,V), _horizontal(D,V), not _dim(X+V).
% moving robot can not end on same pos
:- pos(R,X,Y), 'pos(R,X,Y), gor(R).

%pos(R,X,Y) :- god(D,V),

#show go/3.
%#show pos/3.
%#show god/2.

blocked(X,Y) :- gor(R2), _robot(R), 'pos(R,X,Y), R != R2.
pos(R,X,Y) :- gor(R2), _robot(R), 'pos(R,X,Y), R != R2.
%#show blocked/2.

reach(X,Y) :- 'pos(R,X,Y), gor(R).
%#show reach/2.
reach(X,Y+V) :- reach(X,Y),
				god(D,V),
				_vertical(D,_),
				_dim(Y+V),
				_inverse(D,DI),
				not _barrier(X,Y+V,DI),
				not blocked(X,Y+V),
				#true.
reach(X+V,Y) :- reach(X,Y),
				god(D,V),
				_horizontal(D,_),
				_dim(X+V),
				_inverse(D,DI),
				not _barrier(X+V,Y,DI),
				not blocked(X+V,Y),
				#true.
pos(R,X,Y) :- gor(R),
				reach(X,Y),
				god(D,V),
				_vertical(D,_),
				not reach(X,Y+V),
				%_dim(Y+V),
				#true.
pos(R,X,Y) :- gor(R),
				reach(X,Y),
				god(D,V),
				_horizontal(D,_),
				not reach(X+V,Y),
				%_dim(X+V),
				#true.

%a
%:- 'pos(R,_,_), not pos(R,_,_).


#program final.
% robot pos & target pos have to be the same
% is length/1 the minimum? maximum search depth
:- _target(R,X,Y), not pos(R,X,Y).

% length constraints
:- _length(maxS), 'step(S-1), _target(R,X,Y), pos(R,XR,YR), X!=XR, Y=YR.
:- _length(maxS), 'step(S-1), _target(R,X,Y), pos(R,XR,YR), X=XR, Y!=YR.
:- _length(maxS), 'step(maxS), _target(RT,_,_), gor(RM), RM!=RT.
