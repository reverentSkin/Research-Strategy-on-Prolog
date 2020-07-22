
% euristica1 (distanza di manatthan)
heuristic(pos(X1, Y1), L) :-
 findall(Distance, (finale(pos(X2, Y2)), Distance is abs(X1-X2) + abs(Y1-Y2)), Distances),
 min_distance(Distances, L).
