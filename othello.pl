:- ensure_loaded('./game/display.pl').
:- ensure_loaded('./game/prompt.pl').
:- ensure_loaded('./game/representation.pl').
:- ensure_loaded('./game/rules.pl').


:- ensure_loaded('./ai/random.pl').
:- ensure_loaded('./ai/alphabeta.pl').
:- ensure_loaded('./ai/heuristic.pl').
:- ensure_loaded('./ai/minmax.pl').

:- ensure_loaded('./utils/utils_ai.pl').
:- ensure_loaded('./utils/cache.pl').
:- ensure_loaded('./utils/list.pl').
:- ensure_loaded('./utils/stats.pl').

play :-
  current_prolog_flag(argv, Argv),
  % retract(nocolor),
  option_color(color, 0),
  set_cache(time,time, 0),
  delete_cache(heuristic_stats, _, _),
  
  nth0(0, Argv, P1),
  atom_number(P1, T1),
  
  option_player(player, x, T1),
  nth0(1, Argv, P2),
  atom_number(P2, T2),
  option_player(player, o, T2),

  grilleDeDepart(Grid),
  clear(),
  statistics(walltime, [_, _]),
  play(Grid, x, d, 4),!.

play :-
  % retract(nocolor),
  option_color(color),
  set_cache(time,time, 0),
  delete_cache(heuristic_stats, _, _),
  
  option_player(player, x),
  option_player(player, o),

  grilleDeDepart(Grid),
  clear(),
  statistics(walltime, [_, _]),
  play(Grid, x, d, 4),!.

play(Grid, Player, Alpha_last, Index_last):-

  endOfGame(Grid), %?  always Match \w side effect like stop the game
  canMakeAMove(Grid, Player),!, %? Match or not cf second 'play' predicate

  playerInput(Grid, Alpha_last, Index_last, Alpha, Index, Player),
  makeAMove(Grid, Player, Index, Alpha).  %? always Match \w side effect Display
                                          %  stuff, edit the grid, ask for next player to play


      % play.



% User is locked and he can make a validMove.
play(Grid, Player, Alpha_last, Index_last):-
  clear(),
  afficheCellule(Player), alert('--> Blocked, Turn Skiped'),nl,
  opposite(Player, Player2), % Skip his turn
  canMakeAMove(Grid, Player2),!, % Other Player cannot make a move then -> end of game
  play(Grid, Player2, Alpha_last, Index_last).

      % grilleDeDepart([L1|Rest]), Block = ["-", "-", "-", "-", "-", o, o, x],  GrilleBlock= [L1, L1, L1, L1, L1, Block, Block, Block],
      % afficheGrille(GrilleBlock),
      % play(GrilleBlock, o, d, 4),!. %test Trun Blocked

% if no one can play stop the game
play(Grid, _, _, _):-
  endOfGame(Grid, force).



% (test if Valid move)
makeAMove(Grid, Player, Index, Alpha) :-
  validMove(Player, Grid, [Alpha, Index]),
  coupJoueDansGrille(Grid, Player, Index, Alpha, Grid_move),
  editGrid(Player, Grid_move, Index, Alpha, Grid_out),
  clear(),
  opposite(Player, NextPlayer),
  play(Grid_out, NextPlayer, Alpha, Index).


% error not a valid move
makeAMove(Grid, Player, Index, Alpha) :-
  clear(),
  alert(' Not a valid move!'),
  % ask the same player a new coordinate
  play(Grid, Player, Alpha, Index).



% let the system make the play or the user (defined by prompt:option/2)
playerInput(Grid, Alpha_last, Index_last, Alpha, Index, Player) :-
  playerType(Player, [human, _]),
  userInput(Grid, Alpha_last, Index_last, Alpha, Index, Player).

playerInput(Grid, Alpha_last, Index_last, Alpha, Index, Player) :-
  playerType(Player, [random,_]),
  afficheCellule(Player), write('- Random'),nl,
  afficheGrille(Grid, Alpha_last, Index_last),
  inputPickRandomCoord(Grid, Alpha, Index, Player),
  sleep(0.5).

playerInput(Grid, Alpha_last, Index_last, Alpha, Index, Player) :-
  playerType(Player, [minmax, H]),
  Depth = 3,
  afficheCellule(Player), write('- MinMax.. Depth: ') ,write(Depth), nl,
  afficheGrille(Grid, Alpha_last, Index_last),
  nl, displayRunTime(' - Running since: '),
  minmax(Grid, Player, Depth, [Heuristic_value, [Alpha, Index]], H),
  nl, displayHeuristic(Heuristic_value),
  sleep(0.5).

playerInput(Grid, Alpha_last, Index_last, Alpha, Index, Player) :-
  playerType(Player, [alphabeta, H]),
  Depth = 4,
  afficheCellule(Player), write('- AlphaBeta.. Depth: ') ,write(Depth), nl,
  afficheGrille(Grid, Alpha_last, Index_last),
  nl, displayRunTime(' - Running since: '),
  alphabeta(Grid, Player, Depth, [Heuristic_value, [Alpha, Index]], H),
  nl, displayHeuristic(Heuristic_value),
  sleep(0.5).

      % use_module(library(statistics)).
      % profile(play).

:- initialization(play, program).
% vim:set et sw=2 ts=2 ft=prolog:
