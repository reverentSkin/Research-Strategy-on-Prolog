% Profondità con una profondità limitata

%predicato dinamico
%l'1 rappresenta il numero di argomenti
%rappresenta una variabile globale che aggiungo al database
%durante l'esecuzione del programma
:-dynamic(limite/1).
limite(1).

playid:-
   statistics(walltime, [_ | [_]]),
   iterativeDeepening(Sol),write(Sol),length(Sol,L),write(L),
   statistics(walltime, [_ | [ExecutionTime]]),
   write('Execution took '), write(ExecutionTime), write(' ms.'), nl.


%Inizialmente l'interprete prolog prende in considerazione
%la prima clausola a cui si da il parametro di output "Soluzione"
%poi considera e cerca di dimostrare il predicato ricercaPath.
%dopo c'è un cut in modo tale da rendere le scelte definitive, 
%cioè, se restituisce una soluzione per ricercaPath allora 
%ignora tutte l'altra possibile scelte in cui aumenta di 1 il limite
iterativeDeepening(Soluzione):-
    ricercaPath(Soluzione),
    !,
    retract(limite(_)),
    assert(limite(1)).
 
%effettua una normalissima ricerca in profondità limitata dal
%limite corrente
ricercaPath(Soluzione):-
    limite(N),
    Limite is N,
    write(Limite),nl,
    iniziale(S), 
    ricerca_depth_limitata(S,[],Limite,Soluzione).

%se la ricercaPath di sopra non è andata a buonafine,
%cioè l'interprete prolog non è riuscito a trovare uno stato finale
%in base al limite corrente
%viene presa in considerazione questa seconda scelta e aumentato il limite
%di 1
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