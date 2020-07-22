

a_star_comparator(R, nodo(_, _, CostoG1, CostoH1), nodo(_, _, CostoG2, CostoH2)) :-
  F1 is CostoG1 + CostoH1,
  F2 is CostoG2 + CostoH2,
  F1 >= F2 -> R = > ; R = < .


playa:-
    statistics(walltime, [_ | [_]]),
    astar(Sol),write(Sol),length(Sol,L),write(L),
    statistics(walltime, [_ | [ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.


astar(Soluzione):-
    iniziale(S),
    heuristic(S,HeuristicS),
    astarRicerca([nodo(S,[],0,HeuristicS)],[],Soluzione),
    !.


astarRicerca([nodo(S,AzioniPerS,_,_)|_],_,AzioniPerS):-
    finale(S),!.


astarRicerca([nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale)|CodaStati],Visitati,Soluzione):-
    findall(Az,applicabile(Az,S),ListaAzioniApplicabili),
    generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale),[S|Visitati],ListaAzioniApplicabili,StatiFigli),
    append(CodaStati,StatiFigli,NuovaCoda),
    predsort(a_star_comparator,NuovaCoda,CodaOrdinata),
    astarRicerca(CodaOrdinata,[S|Visitati],Soluzione).


generaStatiFigli(_,_,[],[]).


generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale),Visitati,[Az|AltreAzioni],
                [nodo(SNuovo,[Az|AzioniPerS],NuovoCostoPerS,NuovaEuristicaPerS)|AltriFigli]):-
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    !,
    costo(S, SNuovo, Costo),
    NuovoCostoPerS is CostoAttuale + Costo,
    heuristic(SNuovo,NuovaEuristicaPerS),
    generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale),[SNuovo|Visitati],AltreAzioni,AltriFigli).


generaStatiFigli(Nodo,Visitati,[_|AltreAzioni],AltriFigli):-
    generaStatiFigli(Nodo,Visitati,AltreAzioni,AltriFigli).
