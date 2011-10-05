
solve(Board) :-
    restrict_board_size(Board) ; (write('Invalid board size.'),nl),
    restrict_contents(Board),
    restrict_lines(Board),
    restrict_collumns(Board),
    restrict_blocks(Board),
    show(Board).

show([]).
show([Line|R]) :-
        show_Line(Line),
        show(R).

show_Line([]) :- nl.
show_Line([Cell|R]) :-
        write(Cell), write(' '),
        show_Line(R).

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
not_in(_,[]).
not_in(Item, [Maybe|R]) :-
    Item \= Maybe,
    not_in(Item, R).

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
         Cell > 0,
         Cell < 10,
        restrict_contents_Line(R).

restrict_lines([]).
restrict_lines([Line|R]) :-
        restrict_line(Line),
        restrict_lines(R).

restrict_line([]).
restrict_line([Cell|R]) :-
        restrict_cell(Cell,R),
        restrict_line(R).

restrict_cell(_,[]).
restrict_cell(Cell,[Other|R]) :-
         Cell \= Other,
        restrict_cell(Cell,R).

restrict_collumns(Board) :-
    restrict_collumns(9, Board).
restrict_collumns(0, _).
restrict_collumns(Col, Board) :-
    restrict_col(Col, Board),
    PrevCol is Col - 1,
    restrict_collumns(PrevCol, Board).

restrict_col(Col, Board) :-
    restrict_col(Col, Board, []).
restrict_col(Col, [Line|R], Forbidden) :-
    get_cell(Col, Line, Cell),
    not_in(Cell, Forbidden),
    restrict_col(Col, R, [Cell|Forbidden]).


restrict_blocks(_).

%%%%% TESTING %%%%%

 % valid_board( -Board ).
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

test_rules :-
    valid_board(Board),
    solve(Board).

test_solving :-
    valid_board_with_holes(Board),
    solve(Board).

test :-
    test_rules.
