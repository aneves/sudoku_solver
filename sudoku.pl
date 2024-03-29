
:-use_module(library(clpfd)).

solve(Board) :-
    (restrict_board_size(Board); write('invalid board size'), nl),
    !, (restrict_contents(Board); write('invalid numbers'), nl),
    !, (restrict_lines(Board); write('invalid lines'), nl),
    !, (restrict_collumns(Board); write('invalid collumns'), nl),
    !, (restrict_blocks(Board); write('invalid blocks'), nl),
    fill_lines(Board),
    show(Board).

fill_lines([]).
fill_lines([Line|R]) :-
    fill_cells(Line),
    fill_lines(R).

fill_cells([]).
fill_cells([Cell|R]) :-
    (nonvar(Cell) ; between(1, 9, Cell)),
    fill_cells(R).

% between(Low, High, Value) :-
%     Value = Low
%     ; (
%         Low < High,
%         LowInc is Low + 1,
%         between(LowInc, High, Value)
%     ).

show([]).
show([Line|R]) :-
        show_line(Line),
        show(R).

show_line([]) :- nl.
show_line([Cell|R]) :-
        (  nonvar(Cell), write(Cell)
         ; write('_')
        ),
        write(' '),
        show_line(R).

get_line(Index, Board, Line) :-
    get_item(Index, Board, Line).
get_cell(Index, Line, Cell) :-
    get_item(Index, Line, Cell).

get_item(1, [Cell|_], Cell).
get_item(X, [_|R], Cell) :-
    X > 0,
    XDec is X - 1,
    get_item(XDec, R, Cell).

% not_in(?Item, +Bag)
% TODO: this predicate probably already exists.
not_in(_, []).
not_in(Item, [Maybe|R]) :-
    Item #\= Maybe,
    not_in(Item, R).

% TODO: this predicate probably already exists.
all_unique([]).
all_unique([Item|R]) :-
    not_in(Item, R),
    all_unique(R).

restrict_board_size(Board) :-
    restrict_board_size(9, 9, Board).

restrict_board_size(0, _, []).
restrict_board_size(0, _, _) :- fail.
restrict_board_size(Y, X, [Line|R]) :-
    restrict_line_size(X, Line),
    YDec is Y - 1,
    restrict_board_size(YDec, X, R).
restrict_line_size(0, []).
restrict_line_size(0, _) :- fail.
restrict_line_size(X, [_|R]) :-
    XDec is X - 1,
    restrict_line_size(XDec, R).

restrict_contents([]).
restrict_contents([Line|R]) :-
        restrict_contents_Line(Line),!,
        restrict_contents(R).
restrict_contents_Line([]).
restrict_contents_Line([Cell|R]) :-
         Cell #> 0,
         Cell #< 10,
        restrict_contents_Line(R).

restrict_lines([]).
restrict_lines([Line|R]) :-
        all_unique(Line),
        restrict_lines(R).

restrict_collumns(Board) :-
    restrict_collumns(9, Board).
restrict_collumns(0, _).
restrict_collumns(Col, Board) :-
    restrict_col(Col, Board),
    PrevCol is Col - 1,
    restrict_collumns(PrevCol, Board).

restrict_col(Col, Board) :-
    restrict_col(Col, Board, []).
restrict_col(_, [], _).
restrict_col(Col, [Line|R], Forbidden) :-
    get_cell(Col, Line, Cell),
    not_in(Cell, Forbidden),
    restrict_col(Col, R, [Cell|Forbidden]).

restrict_blocks([]).
restrict_blocks([Line1,Line2,Line3|R]) :-
    restrict_block_lines(Line1, Line2, Line3),
    restrict_blocks(R).

restrict_block_lines([], [], []).
restrict_block_lines(Line1, Line2, Line3) :-
    Line1 = [C11, C12, C13|R1],
    Line2 = [C21, C22, C23|R2],
    Line3 = [C31, C32, C33|R3],
    Block = [C11, C12, C13,
             C21, C22, C23,
             C31, C32, C33],
    all_unique(Block),
    restrict_block_lines(R1, R2, R3).

%%%%% TESTING %%%%%


valid_board( [
[1,2,3,4,5,6,7,8,9],
[4,5,6,7,8,9,1,2,3],
[7,8,9,1,2,3,4,5,6],
[2,3,4,5,6,7,8,9,1],
[5,6,7,8,9,1,2,3,4],
[8,9,1,2,3,4,5,6,7],
[3,4,5,6,7,8,9,1,2],
[6,7,8,9,1,2,3,4,5],
[9,1,2,3,4,5,6,7,8]
            ] ).

valid_board_with_holes( [
[1,2,3,4,5,6,7,8,_],
[4,5,6,7,8,9,1,2,3],
[7,8,9,1,2,3,4,5,6],
[2,3,4,5,6,7,8,9,1],
[5,6,7,8,9,1,2,3,4],
[8,9,1,2,3,4,5,6,7],
[3,4,5,6,7,8,9,1,2],
[6,7,8,9,1,2,3,4,5],
[9,1,2,3,4,5,6,7,8]
            ] ).

example( 'easy', [
[_,6,_,_,5,2,4,3,_],
[_,_,_,_,7,_,2,_,_],
[1,_,_,_,8,_,7,6,_],
[4,_,_,_,1,5,_,7,_],
[5,8,7,_,_,_,1,4,6],
[_,9,_,6,4,_,_,_,2],
[_,5,8,_,9,_,_,_,1],
[_,_,3,_,6,_,_,_,_],
[_,1,4,3,2,_,_,5,_]
            ] ).

example( 'hard', [
[_,_,_,_,_,_,6,7,_],
[_,_,6,_,8,_,_,_,4],
[9,5,_,_,4,_,_,3,_],
[3,6,_,_,_,8,2,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,2,1,_,_,_,5,7],
[_,2,_,_,3,_,_,9,8],
[6,_,_,_,5,_,4,_,_],
[_,4,8,_,_,_,_,_,_]
            ] ).

trules :-
    valid_board(Board),
    solve(Board).

tsolving :-
    valid_board_with_holes(Board),
    solve(Board).

trestrict_columns :-
    valid_board(Board),
    restrict_collumns(Board).

test :-
    trules.

test( Difficulty ) :-
    example(Difficulty, Board),
    solve(Board).
