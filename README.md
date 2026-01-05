# RESfinder batch pipeline

Small helper scripts to run the `resfinder` command on many FASTA files and collect the results.

---

## 1. Quick install

### 1.1 Get the code

```bash
git clone https://github.com/Jonedrengen/RESfinder.git
cd RESfinder
```

### 1.2 Create the conda environment

```bash
conda env create -f envs/RESfinder_simple_env.yaml
conda activate RESfinder
```

This installs `resfinder`, `pandas`, and `xlsxwriter`.

---

## 2. Prepare the databases (one‑time)

The repo expects the databases in [`dbs`](dbs):

- ResFinder: [`dbs/resfinder_db`](dbs/resfinder_db)  
- PointFinder: [`dbs/pointfinder_db`](dbs/pointfinder_db)  
- DisinFinder: [`dbs/disinfinder_db`](dbs/disinfinder_db)

If needed, clone them (from inside `dbs/`):

```bash
cd dbs
git clone https://bitbucket.org/genomicepidemiology/resfinder_db.git
git clone https://bitbucket.org/genomicepidemiology/pointfinder_db.git
git clone https://bitbucket.org/genomicepidemiology/disinfinder_db.git
cd ..
```

### 2.1 (Recommended) KMA indexing

From the repo root:

```bash
cd dbs/resfinder_db     && python3 INSTALL.py non_interactive && cd ../..
cd dbs/pointfinder_db   && python3 INSTALL.py non_interactive && cd ../..
cd dbs/disinfinder_db   && python3 INSTALL.py non_interactive && cd ../..
```

This creates the KMA index files used by mapping‑based runs.

---

## 3. Run locally (no cluster)

Use [`analysis/scripts/run_RESfinder.sh`](analysis/scripts/run_RESfinder.sh).

Example with the test data in [`data/test`](data/test):

```bash
conda activate RESfinder
cd /path/to/RESfinder

bash analysis/scripts/run_RESfinder.sh \
  data/test \
  test_run_local \
  4 (should be left empty)
```

- `data/test` – folder with `.fasta` files  
- `test_run_local` – name of the run (creates `analysis/runs/test_run_local`)  
- `4` – number of threads

Outputs go under `analysis/runs/<run_name>/`.

---

## 4. Run on a SLURM cluster

Submit via [`analysis/scripts/RESfinder_submitter.sh`](analysis/scripts/RESfinder_submitter.sh):

```bash
cd /path/to/RESfinder

sh analysis/scripts/RESfinder_submitter.sh \
  data/test \
  test_run_slurm
```

This:

1. Runs [`analysis/scripts/run_RESfinder_SLURM.sh`](analysis/scripts/run_RESfinder_SLURM.sh) for all FASTAs.
2. Compiles results with [`analysis/scripts/RESfinder_results_compiler.sh`](analysis/scripts/RESfinder_results_compiler.sh).

Adjust the `#SBATCH` lines and conda activation inside the SLURM scripts to match your cluster.

---

## 5. Where to look

- Scripts: [`analysis/scripts`](analysis/scripts)  
- Test FASTA files: [`data/test`](data/test)  
- Run outputs: [`analysis/runs`](analysis/runs)  
- SLURM logs: [`analysis/logs`](analysis/logs)