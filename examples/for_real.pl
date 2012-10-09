
:- ensure_loaded( library(real) ).
:- ensure_loaded( library(lists) ).
:- use_module( library(apply_macros) ).
:- use_module( library(readutil) ).

% for_real.
%
%  Some examples illustrating usage of the r..eal library.

for_real :-
     ( Head = ex(_Ex); Head = tut(_Tut) ),
     clause( Head, Body ),
     write(running:Head), nl, nl,
     portray_clause( (Head:-Body) ), nl, nl,
     write( 'Output: ' ), nl,
     ( catch(Head,Exc,Fex=true) -> 
          ( Fex==true-> 
               write( '! ' ), write( caught(Exc) ), nl, abort
               ;
               write(status:true)
          )
          ;
          write( '! ' ), write( failure ), nl, abort
     ),
     nl, nl, write('-----'), nl, nl,
     fail.
for_real :-
     write( 'All done.' ), nl.


% int.
%
%  Pass the salt please. The most basic example: pass a Prolog list of integers to an R variable 
%  and then back again to a Prolog variable.
%
ex(int) :-
     i <- [1,2,3,4],
     I <- i,
     write( i(I) ), nl.

% float.
%
%  Pass a Prolog list of floats to an R variable and then back again to a Prolog variable.
%
ex(float) :-
     f <- [1.0,2,3,4],
     F <- f,
     write( f(F) ), nl.

% float.
%
%  Pass a mixed Prolog list of integers and floats to an R variable and then back again to a Prolog variable.
%  The returning list is occupied by floats as is the R variable.
%
ex(to_float) :-
     m <- [1,2,3,4.0],
     M1 <- m,
     write( m(M1) ), nl,
     m <- [1,2,3,4.1],
     M2 <- m,
     write( m(M2) ), nl.

% bool.
%
%
ex(bool) :- 
     b <- [true,false,true,true],
     B <- b,
     write( b(B) ), nl.

% at_bool.
%
%  In cases where disambiguation is needed, boolean values can be represented by @Val terms.
%
ex(at_bool) :- 
     b <- [@true,@false,@true,@true],
     B <- b,
     write( at_b(B) ), nl.

%  ex(bool_e).
%
%   This generates an error since there is a non boolean value in a list that looks like 
%   containing boolean values.
%
ex(bool_e) :-    % generates error
     catch(b <- [true,false,true,true,other], Caught, true),
     (\+ var(Caught) -> write( caught_controlled(Caught) ), nl; fail).

%  ex(bool_back).
%
%   Get some boolean values back from applying a vector element equality to an integer
%   vector we just passed to R. Prints the R bools first for comparison.
%
ex(bool_back) :- 
     t <- [1,2,3,4,5,1],
     s <- t==1,
     <- s,
     S <- s,
     write( s(S) ), nl.

% ex(atom_char).
%
%  Pass some atoms to an R vector of characters.
%
ex(atom_char) :- 
     f <- [a,b,c],
     <- f,
     F <- f,
     write( f(F) ), nl.

% ex(matrix_int). 
%
%  Pass a 2-level list of lists of integers to an R matrix (and back again).
%
ex(matrix_int) :-
     a <- [[1,2,3],[4,5,6]],
     <- a,
     A <- a,
     nl, write( a(A) ), nl.

% ex(matrix_char). 
%
%  Pass a 2-level list of lists of charactesrs to an R matrix (and back again).
%
ex(matrix_char) :-
     a <- [[a,b,c],[d,e,f]],
     <- a,
     A <- a,
     write( a(A) ), nl.

% ex(list).
%
%  A Prolog = pairlist to a R list. Shows 2 alternative way to access the list items.
% 
ex(list) :-
     a <- [x=1,y=0,z=3],
     <- a,
     write( 'First element of list :' ), nl,
     <- a^[[1]],
     write( 'Second element of list :' ), nl,
     <- a$y,
     A <- a,
     write( a(A) ), nl.

% ex(list_ea).
%
% Produces error due to name of constructor: -.
%
ex(list_ea) :-  % produces error
     catch( a <- [x=1,y=0,z-3], Caught, true ),
     ( \+ var(Caught) -> write( caught_controlled(Caught) ), nl; fail ),
     <- a,
     A <- a,
     write( a(A) ), nl.

% ex(list_eb).
%
% Produces error due to mismathc of arity of =.
%
ex(list_eb) :- 
     catch( a <- [x=1,y=0,=(z,3,4)], Caught, true ),
     ( \+ var(Caught) -> write( caught_controlled(Caught) ), nl; fail ),
     A <- a,
     write( a(A) ), nl.

% ex(char_list).
%
%  Pass a list which has a char value.
%
ex(char_list) :-
     a <- [x=1,y=0,z=three],
     A <- a,
     <- a,
     memberchk( Z=three, A ),
     write( z(Z):a(A) ), nl.

% ex(mix_list). 
%
%  An R-list of mixed types.
%
ex(mix_list) :-
     a <- [x=1,y=[1,2,3],z=[[a,b,c],[d,e,f]],w=[true,false]],
     A <- a, 
     <- print(a),
     write( a(A) ), nl.

% ex(add_element).
%
%   Adds a third element to a list after creation.
%
ex(add_element) :-
     x <- [a=1,b=2],
     x$c <- [3,4], 
     <- x,    % print   =   $a 3
     X <- x,
     write( 'X'(X) ), nl.   % X = [a=3.0].

% ex(singletons).
%
%  Pass an integer and a singleton number list and get them back.
% Although in R both are passed as vectors of length on, when back in Prolog
% the singleton list constructors are stripped, returing a single integer value in both cases.
%  
ex(singletons) :- 
     s <- 3,
     S <- s,
     <- s,
     t <- [3],
     <- t,
     T <- t,
     write( 'S'(S)-'T'(T) ), nl.

% ex(assign). 
%
% Simple assignment of an R function (+) application on 2 R values originated in Prolog.
% 
ex(assign) :- 
     a <- 3,
     b <- [2],
     C <- a + b,
     write( 'C'(C) ), nl.


% ex(assign_1).
%
%  Assign an R operation on matrices to a Prolog variable.
%
ex(assign_1) :- 
     a <- [[1,2,3],[4,5,6]], B <- a*3, write( 'B'(B) ), nl.

% ex(assign_2).
%
%  Assign an R operation on matrices to a Prolog variable.
%
ex(assign_2) :- 
     a <- [[1,2,3],[4,5,6]], b <- 3, C <- a*b, write( 'C'(C) ), nl.

% ex(assign_r).
%
%  Assign to an R variable and print it. Using c as an R variable is also a good test,
%  as we test against c(...).
%
ex(assign_r) :- 
     a <- [3],
     b <- [2],
     c <- a + b,
     <- c.

% ex(dot_in_function_names).
%
%  Test dots in functions names via the .. mechanism.
%
ex(dot_in_function_names) :-
     a <- [1.1,2,3],
     <- a,
     x <- as..integer(a),
     <- x.

% ex(dot_in_rvars).
%
%  Test dots in R variable names via the .. mechanism. Generates an error on the last goal.
%
ex(dot_in_rvar) :-
     a..b <- [1,2,3],
     <- a..b,
     <- 'a.b',
     ( <- print('a..b') -> % produces an error, as it should
          fail
          ;
          true
     ).

% semi_column.
%
%  A:B in R generates a vector of all integers from A to B.
%
ex(semi_column) :-
     z <- 1:50,
     Z <- z, 
     length( Z, Len ),
     write( len(Len) ), nl.

% c_vectors.
%
%  r.eel also supports c() R function concatenation.
%
ex(c_vectors) :-
     a <- c(1,2,3),  % this goes via the fast route
     b <- c(1,1,2,2) + c(1:4),
     <- a,
     <- b,
     C <- a+b,
     write( 'C'(C) ), nl.

% empty_args.
%
%  Test calling R functions that take no arguments (via foo(.)).
%
ex(empty_args) :-
     <- plot( 1:10, 1:10 ),
     findall( I, (between(1,6,I),write('.'), flush_output, sleep(1)), _ ),
     nl,
     <- dev..off(.).

% binary_op.
%
% Early versions of r..eal were not handling this example properly.  Thanks to Michiel Hildebrand for spotting this.
% The correct resutl is =|[0.0,4.0]|=. First subtract v1 from v2 and then take power 2.
%
ex(binary_op) :-
     v1 <- c(1,1),
     v2 <- c(1,-1),
     P <- (v1-v2)^2,
     write( P ), nl.
     % not !!! : P = [0.0, 0.0].

% utf.
%
% Plots 3 points with the x-axis label showing some Greek letters (alpha/Omega).
%
ex(utf) :-
     <- plot( c(1,2,3), c(3,2,1), xlab=+[945,0'/,937] ),
     findall( I, (between(1,4,I),write('.'), flush_output, sleep(1)), _ ),
     nl,
     <- dev..off(.).

% plot_cpu.
%
%  Create a plot of 4 time points. Each having a push and a pull time component.
%  These are the time it takes to push a list through to R and the time to Pull the same
%  (very long) list back.
%
ex(plot_cpu) :-
     plot_cpu( 1000 ).

% Some tests from r_session, 
%
ex(rtest) :-
     <- set..seed(1),
	y <- rnorm(50),
	<- y,
	x <- rnorm(y),
     <- x11(width=5,height=3.5),
	<- plot(x,y),
     r_wait,
	<- dev..off(.),
	Y <- y,
	write( y(Y) ), nl,
	findall( Zx, between(1,9,Zx), Z ),
	z <- Z,
	<- z,
	cars <- [1, 3, 6, 4, 9],
	% cars <- c(1, 3, 6, 4, 9),
	<- pie(cars),
     r_wait,
	devoff.

% list_times.
%
% Print some timing statistics for operations on a long list of integers.
%
list_times :-
     findall( I, between(1,10000000,I), List ),
     statistics( cputime, Cpu1 ), write( cpu_1(Cpu1) ), nl,
     l <- List,
     a <- median( l ),
     statistics( cputime, Cpu2 ), write( cpu_2(Cpu2) ), nl,
     b <- median( List ),
     statistics( cputime, Cpu3 ), write( cpu_3(Cpu3) ), nl,
     <- a,
     <- b.

% adapted from YapR

% Intrinsic attributes: mode and length
tut(tut1) :-
	z <- 0:9,
	<- z,
	digits <- as..character(z),
	<- digits,
	d <- as..integer(digits),
	<- d.

% changing the length of an object
tut(tut2) :-
	e <- numeric(.),
	(e^[3]) <- 17,
	<- e,
	alpha <- 1:10,
	alpha <- alpha^[2 * 1:5],
     <- alpha,   % = 2, 4, 6, 8 10
	length(alpha) <- 3,
	<- alpha,   % = 2, 4, 6
     nl, write( ' on beta now ' ), nl, nl,
     beta <- 1:10,
     beta <- 2 * beta,
     <- beta,    % 2  4  6  8 10 12 14 16 18 2
     length(beta) <- 3,
     <- beta.    % 2 4 6

% Getting and setting attributes
tut(tut3) :-
	z <- 1:100,
	attr(z, +"dim") <- c(10,10),
	<- z.

% factors and tapply.
tut(tut4) :-
      /*
	 state <- c("tas", "sa",  "qld", "nsw", "nsw", "nt",  "wa",  "wa",
                  "qld", "vic", "nsw", "vic", "qld", "qld", "sa",  "tas",
                  "sa",  "nt",  "wa",  "vic", "qld", "nsw", "nsw", "wa",
                  "sa",  "act", "nsw", "vic", "vic", "act"), */
     state <- [tas,sa,qld,nsw,nsw,nt,wa,wa,qld,vic,nsw,vic,qld,qld,sa,tas,sa,nt,wa,vic,qld,nsw,nsw,wa,sa,act,nsw,vic,vic,act],
	<- state,
     % <- astate,
	statef <- factor(state),
	<- statef,
	<- levels(statef),
	incomes <- c(60, 49, 40, 61, 64, 60, 59, 54, 62, 69, 70, 42, 56,
                    61, 61, 61, 58, 51, 48, 65, 49, 49, 41, 48, 52, 46,
                    59, 46, 58, 43),
	incmeans <- tapply(incomes, statef, mean),
	% notice the function definition.
	stderr <- ( function(x) :-  sqrt(var(x)/length(x)) ),
	incster <- tapply(incomes, statef, stderr),
	<- incster.

tut(tut5) :-
	z <- 1:1500,
	dim(z) <- c(3,5,100),
	a <- 1:24,
	dim(a) <- c(3,4,2),
	<- print(a^[2,*,*]),
	<- print(dim(a)),
	x <- array(1:20, dim=c(4,5)),
	<- x,
	i <- array(c(1:3,3:1), dim=c(3,2)),
	<- i,
	x^[i] <- 0,
	<- x,
	h <- 1:10,
	z <- array(h, dim=c(3,4,2)),
	<- z,
	a <- array(0, dim=c(3,4,2)),
	<- a,
	ab <- z '%o%' a,
	<- ab,
     f <- ( function(x, y) :- cos(y)/(1 + x^2) ),
	w <- outer(z, a, f),
	<- w.

tut(tut6) :-
	d <- outer(0:9, 0:9),
	fr <- table(outer(d, d, +"-")),
	r(plot(as..numeric(names(fr)), fr, type=+"h", xlab=+"Determinant", ylab=+"Frequency")),
     nl, write( '   type query: ``devoff.\'\' to close the plot display ' ), nl, nl.

% auxiliary,
cpu_points( [], [], [] ).
cpu_points( [H|T], [S|Ss], [L|Ls] ) :-
     between_1_and(H,Long),
     statistics( cputime, _) , 
     length( Long, Lengtho ), write( leno(Lengtho) ), nl,
     statistics( cputime, S ), 
     % statistics( cputime, [_,S] ), 
     long <- Long,
     Back <- long,
     Back = [Hb|_],
     Hb =:= 1,
     statistics( cputime, L ), 
     % statistics( cputime, [_,L] ), 
     length( Back, BackLen ),
     write( back_len(BackLen) ), nl,
     % L = 0,
     cpu_points( T, Ss, Ls ).

% auxiliary,
between_1_and(N,X) :-
     ( var(N) -> N is 100; true ),
     IntN is integer(N),
     findall( I, between(1,IntN,I), Is ),
     i <- Is,
     X <- i.
cpu( R ) :-
     ( var(R) -> R is 10000; true ),
     findall( F, between_1_and(R,F), Fs ),
     f <- Fs, 
     statistics( cputime,  Cpu1 ),
     write( cputime_to_push(Cpu1) ), nl,
     X <- f,   % when   F <- f   the predicate fails midway for large Len !!!
     statistics( cputime,  Cpu2 ),
     write( cputime_to_pull(Cpu2) ), nl,
     length( X, Len ),
     write( len(Len) ), nl.
plot_cpu( Factor ) :-
     nl,
     ( Factor > 10 ->
         M='if your set-up fails on this test increase the size of stack.',
         write( M ), nl, nl 
          ;
          true
     ),
     points <- [10,100,500,1000],
     points <- as..integer( points * Factor ),
     <- points,
     Points <- points,
     write( points(Points) ), nl,
     cpu_points( Points, Push, Pull ), 
     push <- Push,
     pull <- Pull,
     write( plotting(Pull,Push) ), nl,
     <- plot( points, pull, ylab ='"pull & push (red) - in seconds"' ),
     r_char( red, Red ),
     <- points( points, push, col=Red ).