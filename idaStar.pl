:-dynamic(ida_nodo/2).


playida:-
    statistics(walltime, [_ | [_]]),
    idaStar(Sol),
    write(Sol),length(Sol,L),write(L),
    statistics(walltime, [_ | [ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.



idaStar(Sol):-
    iniziale(S),
    heuristic(S,EuristicaIniziale),
    ida(S, Sol, [S], 0, EuristicaIniziale),
    !.



ida(S, Sol, Visitati, CostoPercorsoS, Euristica):-
    ida_search(S, Sol, Visitati, CostoPercorsoS, Euristica);
    findall(FS, ida_nodo(_, FS), EuristicaLista),
    exclude(>=(Euristica), EuristicaLista, OverEuristicaLista),
    sort(OverEuristicaLista, ListaOrdinata),
    nth0(0, ListaOrdinata, NuovaEuristica),
    retractall(ida_nodo(_, _)),
    ida(S, Sol, Visitati, 0, NuovaEuristica).


ida_search(S, [], _, _, _):-
    finale(S),!.


ida_search(S, [Az|AltreAzioni], Visitati, CostoPercorsoS, Euristica):-
    applicabile(Az, S),
    trasforma(Az, S, NuovoS), 
    \+member(NuovoS, Visitati),
    costo(S, NuovoS, Costo),
    CostoPercorsoNuovaS is CostoPercorsoS + Costo,
    heuristic(NuovoS,CostoHeuristicNuovaS),
    FNuovoS is CostoPercorsoNuovaS + CostoHeuristicNuovaS,
    assert(ida_nodo(NuovoS, FNuovoS)),
	FNuovoS =< Euristica,
    ida_search(NuovoS, AltreAzioni, [NuovoS|Visitati], CostoPercorsoNuovaS, Euristica).
