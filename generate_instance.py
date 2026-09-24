"""
Générateur d'instance LP "grande échelle" pour la démo MiniZinc du TP1.

Scénario : ExedBike étend sa gamme à un configurateur (tailles de cadre x
couleurs x options moteur/batterie), ce qui produit un grand catalogue de
n variantes ("SKUs"). m ressources partagées (postes d'assemblage, stocks
de composants, contrôle qualité...) limitent la production hebdomadaire.

Usage (commandes exactes utilisées pour produire large.dzn / small.dzn --
fournis avec la fiche ; relancez ces commandes pour les régénérer à
l'identique, ou changez seed/n/m pour explorer d'autres tailles) :
    python3 generate_instance.py --n 2000 --m 80          --seed 20260924 --out large
    python3 generate_instance.py --n 15   --m 4  --k_nnz 3 --seed 20260924 --out small

Écrit <out>.dzn (pour MiniZinc) et <out>_data.npz (mêmes données au format
numpy, pour vérification indépendante avec scipy.optimize.linprog / PuLP).
"""
import argparse
import numpy as np

def generate(n, m, k_nnz, seed):
    rng = np.random.default_rng(seed)

    margin = np.round(rng.uniform(50, 300, size=n), 2)

    usage = np.zeros((n, m))
    for i in range(n):
        cols = rng.choice(m, size=min(k_nnz, m), replace=False)
        usage[i, cols] = np.round(rng.uniform(0.5, 12.0, size=cols.size), 2)

    # Dimensionner les capacités pour que le PL soit réellement contraint
    # (plusieurs ressources saturées à l'optimum, pas juste "tout produire")
    # cible : de l'ordre de 12% du volume total qu'utiliserait la gamme
    # complète sur chaque ressource.
    total_usage_per_resource = usage.sum(axis=0)
    capacity = np.round(0.12 * total_usage_per_resource + 1.0, 1)

    return margin, usage, capacity


def write_dzn(path, margin, usage, capacity):
    n, m = usage.shape
    with open(path, "w") as f:
        f.write(f"n = {n};\n")
        f.write(f"m = {m};\n")
        f.write("marge = [" + ", ".join(f"{v:.2f}" for v in margin) + "];\n")
        f.write("capacite = [" + ", ".join(f"{v:.1f}" for v in capacity) + "];\n")
        f.write("usage = [| ")
        rows = []
        for i in range(n):
            rows.append(", ".join(f"{v:.2f}" for v in usage[i]))
        f.write("\n           | ".join(rows))
        f.write(" |];\n")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--n", type=int, required=True)
    ap.add_argument("--m", type=int, required=True)
    ap.add_argument("--k_nnz", type=int, default=6)
    ap.add_argument("--seed", type=int, default=20260924)
    ap.add_argument("--out", type=str, required=True)
    args = ap.parse_args()

    margin, usage, capacity = generate(args.n, args.m, args.k_nnz, args.seed)
    write_dzn(f"{args.out}.dzn", margin, usage, capacity)
    np.savez(f"{args.out}_data.npz", margin=margin, usage=usage, capacity=capacity)
    print(f"Instance écrite : {args.out}.dzn  (n={args.n}, m={args.m}, "
          f"nnz={int((usage>0).sum())}/{args.n*args.m})")
