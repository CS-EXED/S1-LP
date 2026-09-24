% ============================================================================
% Optimisation pour l'IA — Séance 1 — TP1, section BONUS
% MiniZinc : le mix de production ExedBike (version simplifiee, cf. TD1 et
% TP1 Exercice 4) en programmation par contraintes declarative.
%
% MiniZinc n'est pas seulement un solveur d'optimisation combinatoire (voir
% Seance 2) : le langage supporte aussi des variables continues (var float),
% et peut donc resoudre un programme lineaire exactement comme PuLP ou
% scipy.optimize.linprog -- mais avec la MEME syntaxe declarative que vous
% utiliserez en Seance 2 pour la PPC (cf. Notes de cours, Sec. 1.3).
%
% Pour executer ce fichier :
%   1) installez le bundle officiel MiniZinc (https://www.minizinc.org/software.html)
%      -- il embarque plusieurs solveurs prets a l'emploi, dont HiGHS et
%      COIN-BC, capables de resoudre des programmes lineaires continus.
%   2) en ligne de commande :  minizinc --solver HiGHS Seance1_TP1_bonus_minizinc.mzn
%      ou, dans MiniZinc IDE, choisissez "HiGHS" (ou "COIN-BC") dans le menu
%      deroulant du solveur avant de cliquer sur Run.
%   ATTENTION : le solveur par defaut "Gecode" est un solveur de programmation
%   par contraintes (recherche par intervalles) -- il n'est PAS concu pour
%   l'optimisation lineaire continue et peut rester bloque indefiniment sur
%   ce modele. Choisissez explicitement un solveur MIP/LP (HiGHS, COIN-BC,
%   CPLEX, Gurobi...) pour les variables continues.
% ============================================================================

% --- Variables de decision (continues, comme un PL classique) -------------
var 0.0..1000.0: u;  % unites Urban produites par semaine
var 0.0..1000.0: c;  % unites Cargo produites par semaine

% --- Contraintes de ressources ---------------------------------------------
constraint 4.0*u + 6.0*c  <= 480.0;   % main-d'oeuvre (h)
constraint 6.0*u + 15.0*c <= 900.0;   % aluminium (kg)
constraint 2.0*u + 2.0*c  <= 240.0;   % temps machine (h)

% --- Objectif ----------------------------------------------------------
solve maximize 120.0*u + 200.0*c;

output [
  "Urban = ", show(u), "\n",
  "Cargo = ", show(c), "\n",
  "marge = ", show(120.0*u + 200.0*c), " EUR/semaine\n",
  "(attendu : Urban = 75, Cargo = 30, marge = 15000 -- identique a TD1, Excel et Python)\n"
];
