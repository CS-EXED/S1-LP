% ============================================================================
% Optimisation pour l'IA — Séance 1 — TP1, section BONUS
% MiniZinc : a vous d'ecrire le modele ! Le PL du mix de production ExedBike
% (2 produits, meme probleme qu'a l'Exercice 4 du notebook et qu'en TD1) en
% MiniZinc -- un langage DECLARATIF que vous retrouverez en Seance 2 pour la
% programmation par contraintes (PPC) : on decrit QUOI resoudre (variables,
% contraintes, objectif), pas COMMENT le resoudre (cf. Notes de cours, Sec 1.3).
%
% Contexte : ExedBike fabrique Urban (marge 120 EUR/unite) et Cargo (marge
% 200 EUR/unite). Ressources disponibles CHAQUE SEMAINE :
%
%   Ressource            Urban   Cargo   Disponible
%   Main-d'oeuvre (h)      4       6        480
%   Aluminium (kg)         6      15        900
%   Temps machine (h)      2       2        240
%
% Vous devez retrouver EXACTEMENT le meme resultat qu'en TD1 (a la main),
% en Python (Exercice 4, notebook) et en Excel (feuille 2) :
%   Urban = 75, Cargo = 30, marge = 15 000 EUR/semaine.
%
% Pour executer ce fichier UNE FOIS COMPLETE :
%   minizinc --solver HiGHS Seance1_TP1_minizinc_a_completer.mzn
%   (ou choisissez HiGHS dans le menu deroulant de MiniZinc IDE avant de
%   cliquer sur Run)
%   ATTENTION : n'utilisez PAS Gecode (solveur par defaut) -- ce n'est pas un
%   solveur pour variables continues, il ne convergera pas (cf. le fichier
%   Seance1_TP1_bonus_minizinc.mzn de l'exercice precedent, qui montre
%   exactement ce probleme).
% ============================================================================

% --- ETAPE 1 : variables de decision ----------------------------------------
% Declarez deux variables continues et positives : u (unites Urban produites
% par semaine) et c (unites Cargo produites par semaine).
% Syntaxe MiniZinc :  var <min>..<max> : nom_variable;
% (choisissez des bornes larges, par exemple 0.0 a 1000.0)
%
% A COMPLETER (2 lignes) :


% --- ETAPE 2 : contraintes de ressources ------------------------------------
% Ecrivez les 3 contraintes de ressources (une instruction "constraint" par
% ressource), en reprenant les coefficients de la table ci-dessus.
% Syntaxe MiniZinc :  constraint <expression> <= <valeur>;
%
% A COMPLETER (3 lignes) :


% --- ETAPE 3 : objectif ------------------------------------------------------
% Maximisez la marge totale hebdomadaire = 120*u + 200*c.
% Syntaxe MiniZinc :  solve maximize <expression>;
%
% A COMPLETER (1 ligne) :


% --- affichage (deja ecrit -- rien a modifier ici) --------------------------
output [
  "Urban = ", show(u), "\n",
  "Cargo = ", show(c), "\n",
  "marge = ", show(120.0*u + 200.0*c), " EUR/semaine\n",
  "(attendu : Urban = 75, Cargo = 30, marge = 15000 -- identique a TD1, Excel et Python)\n"
];
