:- consult('aturan.pl').

:- dynamic triple/3.
:- multifile aturan/3.
:- dynamic aturan/3.

:- set_prolog_flag(unknown, warning).

classify(Individu, Kelas) :-
    nonvar(Individu), nonvar(Kelas),
    Goal =.. [Kelas, Individu],
    once(prove(Goal, 0, _)).

explain(Individu, Kelas) :-
    nonvar(Individu), nonvar(Kelas),
    Goal =.. [Kelas, Individu],
    (once(prove(Goal, 0, Evidence)) -> 
        portray_clause(Evidence); 
        format('Tidak ada bukti untuk ~q.~n', [Goal]), fail).

why_not(Individu, Kelas) :-
    why_not(Individu, Kelas, DaftarGagal),
    portray_clause(DaftarGagal).

why_not(Individu, Kelas, DaftarGagal) :-
    nonvar(Individu), nonvar(Kelas),
    Goal =.. [Kelas, Individu],
    findall(gagal(Id, FailedGoal), (
        aturan(Id, Head, Body),
        copy_term((Head,Body), (HeadCopy,BodyCopy)),
        HeadCopy = Goal,
        first_failure(BodyCopy, FailedGoal)
    ), Raw),
    sort(Raw, DaftarGagal).

prove(Goal, Depth, Evidence) :-
    Depth < 64,
    prove_goal(Goal, Depth, Evidence).

prove_goal(Goal, _, fakta(Goal)) :-
    Goal =.. [Class, Individual],
    triple(Individual, rdf:type, Class), !.
prove_goal(triple(S,P,O), _, fakta(triple(S,P,O))) :-
    triple(S,P,O), !.

prove_goal((A,B), Depth, and(EA,EB)) :-
    D1 is Depth + 1,
    prove(A, D1, EA),
    prove(B, D1, EB), !.

prove_goal(\+ Goal, _, tidak(Goal)) :-
    \+ prove(Goal, 1, _), !.

prove_goal(Goal, Depth, bukti(Id, Head, [BodyEvidence])) :-
    aturan(Id, Head, Body),
    copy_term((Head,Body), (HeadCopy,BodyCopy)),
    Goal = HeadCopy,
    D1 is Depth + 1,
    prove(BodyCopy, D1, BodyEvidence), !.

prove_goal(Goal, _, fakta(Goal)) :-
    callable(Goal),
    builtin_goal(Goal),
    call(Goal), !.
prove_goal(Goal, _, fakta(Goal)) :-
    callable(Goal),
    functor(Goal, Name, Arity),
    current_predicate(Name/Arity),
    call(Goal), !.

builtin_goal(Goal) :-
    functor(Goal, Name, Arity),
    memberchk(Name-Arity,
      [ is-2, '>'-2, '>='-2, '<'-2, '=<' -2, '=:='-2, '=\='-2,
        '='-2, '=='-2, '\=='-2, dif-2,
        member-2, memberchk-2, between-3,
        length-2, sort-2, msort-2, sum_list-2,
        aggregate_all-3, aggregate_all-4,
        date_time_stamp-2
      ]).

first_failure((A,B), Failed) :-
    ( prove(A, 0, _) -> first_failure(B, Failed)
    ; Failed = A
    ), !.
first_failure(\+ A, Failed) :-
    ( prove(A, 0, _) -> Failed = \+ A ; fail ), !.
first_failure(Goal, Goal) :-
    \+ prove(Goal, 0, _).
