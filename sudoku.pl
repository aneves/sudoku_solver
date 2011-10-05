
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
