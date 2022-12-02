% Main predicate %
% Encapsulate
alphabeta(Grid, Player, Depth, Result, H) :-
  opposite(Player, Opposite),


  % like in alphabeta but set the default first Coords that will defined the next move
  allnextGrid(Grid, Player, Grids_out),
  NextDepth is Depth - 1,
  init_value_minOrMax(Depth, Init_minOrMax),
  getScoreAlphaBeta(Grids_out, Player, Opposite, NextDepth, Init_minOrMax, Result, -inf, +inf, H),
  !.



% main loop
alphabeta([Grid_in, FirstMinMaxCoords], MaxPlayer, MinPlayer, Depth, Result, Alpha, Beta, H) :-
  Depth \= 0,
  allnextGrid_data(Grid_in, MaxPlayer, Grids_out, FirstMinMaxCoords),
  \+ length(Grids_out, 0),!, % there is still some tree to generate

  NextDepth is Depth - 1,
  init_value_minOrMax(Depth, Init_minOrMax),
  getScoreAlphaBeta(Grids_out, MaxPlayer, MinPlayer, NextDepth, Init_minOrMax, Result, Alpha, Beta, H).


% no more possibility end of tree or Depth = 0
alphabeta([Grid_in, [A,I]], MaxPlayer, MinPlayer, _, [Result, [A,I]], _, _, compoundHeuristic) :-
  compoundHeuristic(Grid_in, MaxPlayer, MinPlayer, Result). /* compute the Heuristic every time */
  % get_or_compute_heuristic(Grid_in, MaxPlayer, MinPlayer, Result) /* less brute force ;) */
  % ,nl,afficheGrille(Grid_in), write(Result), write('  '),write(A), write(','), write(I),nl.

alphabeta([Grid_in, [A,I]], MaxPlayer, MinPlayer, _, [Result, [A,I]], _, _, coinParityHeuristic) :-
  coinParityHeuristic(Grid_in, MaxPlayer, MinPlayer, Result). /* compute the Heuristic every time */

alphabeta([Grid_in, [A,I]], MaxPlayer, MinPlayer, _, [Result, [A,I]], _, _, _) :-
  coinParityHeuristic(Grid_in, MaxPlayer, MinPlayer, Result). /* compute the Heuristic every time */



getScoreAlphaBeta([First_grid]          , MaxPlayer, MinPlayer, Depth, OldRes, Result, Alpha, Beta, H) :-
  even(Depth), !,
  alphabeta(First_grid, MinPlayer, MaxPlayer, Depth, Result_current, Alpha, Beta, H),
  my_min(OldRes, Result_current, Result).
  % Result is max(OldRes, Result_current).

getScoreAlphaBeta([First_grid]          , MaxPlayer, MinPlayer, Depth, OldRes, Result, Alpha, Beta, H) :-
  alphabeta(First_grid, MinPlayer, MaxPlayer, Depth, Result_current, Alpha, Beta, H),
  % Result is min(OldRes, Result_current).
  my_max(OldRes, Result_current, Result).


getScoreAlphaBeta([First_grid|Rest_grid], MaxPlayer, MinPlayer, Depth, OldRes, RETURN, Alpha, Beta, H) :-
  even(Depth),!,
  alphabeta(First_grid, MinPlayer, MaxPlayer, Depth, Result_current, Alpha, Beta, H),
  my_min(OldRes, Result_current, Result_tmp),
  [Val , _] = Result_tmp,
  ( Val >  Alpha ->
     getScoreAlphaBeta(Rest_grid, MaxPlayer, MinPlayer, Depth, Result_tmp, RETURN, Alpha, Val, H)
    ; RETURN = Result_tmp
  ).


getScoreAlphaBeta([First_grid|Rest_grid], MaxPlayer, MinPlayer, Depth, OldRes, RETURN, Alpha, Beta, H) :-
  alphabeta(First_grid, MinPlayer, MaxPlayer, Depth, Result_current, Alpha, Beta, H),
  my_max(OldRes, Result_current, Result_tmp),
  [Val , _] = Result_tmp,
  ( Val <  Beta ->
    getScoreAlphaBeta(Rest_grid, MaxPlayer, MinPlayer, Depth, Result_tmp, RETURN, Val, Beta, H)
    ; RETURN = Result_tmp
  ).


      % grilleDeDepart(Grid),
      % alphabeta(Grid, x, 4, R).

% vim:set et sw=2 ts=2 ft=prolog:
