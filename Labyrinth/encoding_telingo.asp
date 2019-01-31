%*
telingo encoding for Labyrinth problem from the ASP Competition 2013 ( https://www.mat.unical.it/aspcomp2013/OfficialProblemSuite )
Arguments:
D - direction (n - north, s - south, e - east, w - west)
N - number of row/column
S - step
*%

#program initial.
step(0).
dir(n). dir(s). dir(e). dir(w).			% directions
inverse(e,w). inverse(w,e).				% inverse directions
inverse(n,s). inverse(s,n).
vertical(n,1). vertical(s,-1).			% vertical directions
horizontal(e,1). horizontal(w,-1).		% horizontal directions
size(N) :- N = #max{X : field(X,Y)}.	% size of the NxN field
reach(X,Y) :- init_on(X,Y).				% places the actor can reach


#program dynamic.
step(S+1) :- 'step(S).

% select push direction
1 {pdir(D) : _dir(D)} 1.
% select push row/column
1 {pnum(N) : _size(S), N=(1..S)} 1.

% combine push direction & row/column
push(N,D) :- pdir(D), pnum(N).
#show push/2.

% pushed field has same Y/X value, X/Y is changed with direction value
% modulo fieldsize to prevent dropping of the grid (0 or N+1)
% clingo modulo -1\3=-1 => add fieldsize
% -1 & +1 since the field starts at 1, modulo at 0
shift(X,Y,X,YN) :- _field(X,Y),
					push(X,PD),
					_vertical(PD,V),
					_size(N),
					YN=(N+Y-1+V)\N+1.		% new field: (field size + current field + direction -1) modulo (field size +1)
shift(X,Y,XN,Y) :-	_field(X,Y),
					push(Y,PD),
					_horizontal(PD,V),
					_size(N),
					XN=(N+X-1+V)\N+1.


% keep not pushed fields
shift(X,Y,X,Y) :- _field(X,Y),
					pdir(PD),
					_vertical(PD,_),
					not pnum(X).
shift(X,Y,X,Y) :- _field(X,Y),
					pdir(PD),
					_horizontal(PD,_),
					not pnum(Y).


% shift connect, goal & reach
connect(XN,YN,D) :- 'connect(XO,YO,D), shift(XO,YO,XN,YN).
goal_on(XN,YN) :- 'goal_on(XO,YO), shift(XO,YO,XN,YN).
reach(XN,YN) :- 'reach(XO,YO), shift(XO,YO,XN,YN).

% flood the labyrinth
reach(X,Y+V) :- reach(X,Y),
				connect(X,Y,D),
				_vertical(D,V),
				_inverse(D,DI),
				connect(X,Y+V,DI).
reach(X+V,Y) :- reach(X,Y),
				connect(X,Y,D),
				_horizontal(D,V),
				_inverse(D,DI),
				connect(X+V,Y,DI).

%#show reach/2.
%#show goal_on/2.
%#show connect/3.

#program final.
:- goal_on(Yg,Xg), not reach(Yg,Xg), not _testing.
