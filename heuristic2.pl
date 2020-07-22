% euristica2 (distanza euclidea)
heuristic(pos(X1, Y1), L) :-
    findall(Distance, (finale(pos(X2, Y2)), Distance is sqrt((X2-X1)^2 + (Y2-Y1)^2)), Distances),
    min_distance(Distances, L).