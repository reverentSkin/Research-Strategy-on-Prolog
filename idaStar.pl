:-dynamic(ida_nodo/2).


playida:-
    statistics(walltime, [_ | [_]]),
    idaStar(Sol),
    write(Sol),length(Sol,L),write(L),
    statistics(walltime, [_ | [ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.


% Al primo passo la soglia è data dall'euristica iniziale
% che utilizza la distanza di Manatthan tra il nodo iniziale
% e il nodo finale
idaStar(Sol):-
    iniziale(S),
    heuristic(S,EuristicaIniziale),
    ida(S, Sol, [S], 0, EuristicaIniziale),
    !.

% Ad ogni iterazione viene effettuata la ricerca in profondità
% secondo la soglia determinata dall'euristica.
% All'inizio corrisponde all'euristica iniziale, successivamente
% corrisponderà al minimo f(S) = g(S) + h(S) di tutti i nodi 
% che superano la soglia al passo precendente (backtracking)
%Se la ricerca in profondità fallisce allora vengono presi in
%considerazione i predicati successivi, altrimenti 
%viene correttamente istanzianziato il parametro di output

% funzionamento per il ricalcolo della soglia:
% vengono prese le F(S) per tutti gli stati
% da queste vengono prese quelle che superano la soglia precedente
% e messe in OverEuristicaLista
% viene presa la soglia che corrisponde alla minima euristica trovata
% si chiama ricorsivamente ida sulla nuova soglia
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


% Viene implementata una ricerca in profondità, con limite dettato
% dall'euristica.
% Viene scelta un'azione applicabile nello stato S
% si trova uno stato nuovo che verifichi il predicato trasforma
% si verifica che non appartiene agli stati visitati
% si calcola il costo per passare al nuovo stato
% per questo tipo di esperimento il costo è sempre unitario
% il costo del percorso per il nuovo stato è dato dal costo del percorso
% per lo stato precedente + il costo unitario di transizione
% viene calcolata l'euristica per il nuovo stato
% la F(SNuovo) = costo percorso + costo euristica
% viene asserito un predicato che mi permette di tracciare ogni
% nodo con la sua F(S)
% se la profondità del nuovo stato è minore del'euristica si
% chiama ricorsivamente ida_search sul nuovo stato
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
