
% Azioni del labirinto
% applicabile(Az,Stato)

applicabile(ovest,pos(Riga,Colonna)):-
    Colonna>1,
    ColonnaAdiacente is Colonna-1,
    \+occupata(pos(Riga,ColonnaAdiacente)).

applicabile(sud,pos(Riga,Colonna)):-
    num_righe(NR),
    Riga<NR,
    RigaSotto is Riga+1,
    \+occupata(pos(RigaSotto,Colonna)).

applicabile(est,pos(Riga,Colonna)):-
    num_colonne(NC),
    Colonna<NC,
    ColonnaAdiacente is Colonna+1,
    \+occupata(pos(Riga,ColonnaAdiacente)).

applicabile(nord,pos(Riga,Colonna)):-
    Riga>1,
    RigaSopra is Riga-1,
    \+occupata(pos(RigaSopra,Colonna)).


% trasforma(Az,Stato,NuovoStato)
trasforma(est,pos(Riga,Colonna),pos(Riga,ColonnaADestra)):-ColonnaADestra is Colonna+1.
trasforma(ovest,pos(Riga,Colonna),pos(Riga,ColonnaASinistra)):-ColonnaASinistra is Colonna-1.
trasforma(nord,pos(Riga,Colonna),pos(RigaSopra,Colonna)):-RigaSopra is Riga-1.
trasforma(sud,pos(Riga,Colonna),pos(RigaSotto,Colonna)):-RigaSotto is Riga+1.


%###################################################
% massimaProfondita/1 fornisce un limite massimo di profondità
% entro il quale la ricerca ID deve fermarsi
%###################################################
massimaProfondita(D) :-
  num_righe(R),
  num_colonne(L),
  D is R * L.


%###################################################
% costo/3 restituisce il costo di ogni azione di dominio fattibile
% ognuno di esse ha un costo unitario.
%###################################################
costo(pos(_,_), pos(_, _), Costo) :-
  Costo is 1.


min_distance([L|Ls], Min) :-
    min_distance(Ls, L, Min).
   
min_distance([], Min, Min).
min_distance([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    min_distance(Ls, Min1, Min).

excludeEuristics([],[],_).
excludeEuristics([Head|Tail],OverEuristicaLista,Euristica):-
    Head >= Euristica,
    !,
    excludeEuristics(Tail,[Head|OverEuristicaLista],Euristica).

excludeEuristics([_|Tail],OverEuristicaLista,Euristica):-
    excludeEuristics(Tail,OverEuristicaLista,Euristica).

