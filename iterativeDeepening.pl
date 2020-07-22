
:-dynamic(limite/1).
limite(1).

playid:-
   statistics(walltime, [_ | [_]]),
   iterativeDeepening(Sol),write(Sol),length(Sol,L),write(L),
   statistics(walltime, [_ | [ExecutionTime]]),
   write('Execution took '), write(ExecutionTime), write(' ms.'), nl.


iterativeDeepening(Soluzione):-
    ricercaPath(Soluzione),
    !,
    retract(limite(_)),
    assert(limite(1)).
 

ricercaPath(Soluzione):-
    limite(N),
    Limite is N,
    write(Limite),nl,
    iniziale(S), 
    ricerca_depth_limitata(S,[],Limite,Soluzione).


ricercaPath(Soluzione):-
    limite(N),
    N1 is N+1,
    massimaProfondita(D),
    N1 =< D,
    retract(limite(_)),
    assert(limite(N1)),
    ricercaPath(Soluzione).
 
ricerca_depth_limitata(S,_,_,[]):-finale(S),!.
ricerca_depth_limitata(S,Visitati,Limite,[Az|SequenzaAzioni]):-
    Limite>0,
    applicabile(Az,S),
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovoLimite is Limite-1,
    ricerca_depth_limitata(SNuovo,[S|Visitati],NuovoLimite,SequenzaAzioni).
