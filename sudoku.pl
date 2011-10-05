
solve(Board) :-
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

restrict_contents([]).
restrict_contents([Line|R]) :-
        restrict_contents_Line(Line),!,
        restrict_contents(R).
restrict_contents_Line([]).
restrict_contents_Line([Cell|R]) :-
         Cell >0,
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

restrict_collumns(_).
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
    test_solving.
