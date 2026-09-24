% ============================================================================
% Optimisation pour l'IA — Séance 1 — TP1, section BONUS
% MiniZinc : mix de production ExedBike à GRANDE ÉCHELLE (catalogue étendu,
% n variantes / m ressources partagées), pour illustrer :
%   (1) qu'un vrai solveur LP (HiGHS) passe à l'échelle sans effort,
%   (2) que le choix du solveur compte : Gecode (PPC par défaut de MiniZinc)
%       n'est PAS un solveur LP et échoue même sur des instances bien plus
%       petites que celle-ci (cf. Seance1_TP1_bonus_minizinc.mzn, ainsi que
%       la comparaison faite en corrigé).
%
% Utilisation :
%   minizinc --solver HiGHS exedbike_large.mzn large.dzn
% (données générées par generate_instance.py — cf. corrigé pour les chiffres)
% ============================================================================

int: n;                          % nombre de variantes produites (SKUs)
int: m;                          % nombre de ressources partagées
array[1..n] of float: marge;     % marge unitaire (EUR) par variante
array[1..m] of float: capacite;  % disponibilité hebdomadaire par ressource
array[1..n, 1..m] of float: usage; % usage[i,j] = conso. de la ressource j par unité de i

array[1..n] of var 0.0..100000.0: x;  % quantité produite de chaque variante

constraint forall(j in 1..m) (
  sum(i in 1..n)(usage[i,j] * x[i]) <= capacite[j]
);

solve maximize sum(i in 1..n)(marge[i] * x[i]);

output [
  "marge totale = ", show(sum(i in 1..n)(marge[i] * x[i])), " EUR/semaine\n",
  "nombre de variantes produites (x > 0.01) = ",
  show(sum(i in 1..n)(bool2int(x[i] > 0.01))), " / ", show(n), "\n"
];
