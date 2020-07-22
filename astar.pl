

a_star_comparator(R, nodo(_, _, CostoG1, CostoH1), nodo(_, _, CostoG2, CostoH2)) :-
  F1 is CostoG1 + CostoH1,
  F2 is CostoG2 + CostoH2,
  F1 >= F2 -> R = > ; R = < .


playa:-
    statistics(walltime, [_ | [_]]),
    astar(Sol),write(Sol),length(Sol,L),write(L),
    statistics(walltime, [_ | [ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.

/*
come nella ricerca in ampiezza abbiamo la necessità di tener traccia
delle azioni per arrivare ad uno stato S, del suo costo per arrivarci,
e dell'euristica rispetto allo stato finale
*/
astar(Soluzione):-
    iniziale(S),
    heuristic(S,HeuristicS),
    astarRicerca([nodo(S,[],0,HeuristicS)],[],Soluzione),
    !.

/*Se ci troviamo nello stato finale, le azioni da restituire
come parametro di output
sono proprio le azioni per S*/
astarRicerca([nodo(S,AzioniPerS,_,_)|_],_,AzioniPerS):-
    finale(S),!.

/*avviene una ricerca in ampiezza, solo che a differenza di quella
standard dove alla chiamata ricorsiva si passerebbe NuovaCoda
qui viene passata CodaOrdinata secondo le F(S) degli stati
dai nodi che ce l'hanno più piccola a quelli che ce l'hanno
più grande*/
astarRicerca([nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale)|CodaStati],Visitati,Soluzione):-
    findall(Az,applicabile(Az,S),ListaAzioniApplicabili),
    generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale),[S|Visitati],ListaAzioniApplicabili,StatiFigli),
    append(CodaStati,StatiFigli,NuovaCoda),
    predsort(a_star_comparator,NuovaCoda,CodaOrdinata),
    astarRicerca(CodaOrdinata,[S|Visitati],Soluzione).

/*Caso base: la lista azioni applicabili è vuota
allora la lista di stati figli è vuota*/
generaStatiFigli(_,_,[],[]).

/*Nel caso induttivo, ad ogni chiamata viene messo in testa
alla lista dei figli il nodo rappresentato dal costo del suo percorso
e dal valore dell'euristica*/
generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale),Visitati,[Az|AltreAzioni],
                [nodo(SNuovo,[Az|AzioniPerS],NuovoCostoPerS,NuovaEuristicaPerS)|AltriFigli]):-
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    !,
    costo(S, SNuovo, Costo),
    NuovoCostoPerS is CostoAttuale + Costo,
    heuristic(SNuovo,NuovaEuristicaPerS),
    generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale),[SNuovo|Visitati],AltreAzioni,AltriFigli).

%fa riferimento al caso in cui SNuovo è gia stato visitato
%ma dobbiamo proseguire
generaStatiFigli(Nodo,Visitati,[_|AltreAzioni],AltriFigli):-
    generaStatiFigli(Nodo,Visitati,AltreAzioni,AltriFigli).
