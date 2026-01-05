#!/bin/bash

#any error -> exit
set -euo pipefail

# paths
analysis_scripts="/Users/B328695/Desktop/RESfinder/analysis/scripts"

# input
INPUT_DATA_FOLDER=$1   # folder with .fasta files
RESfinder_OUTPUT_FOLDER_NAME=$2         # run dir name under runs/ (e.g. "test4_output")

if [ $# -lt 2 ]; then
    echo "Usage: $0 <input_data_folder> <output_NAME>"
    exit 1
fi

# 1) run ResFinder (local version; change to SLURM script if needed)
sbatch "${analysis_scripts}/run_RESfinder_SLURM.sh" "$INPUT_DATA_FOLDER" "$RESfinder_OUTPUT_FOLDER_NAME"

# 2) compile results into runs/<OUTPUT_NAME>/compiled_files
sh "${analysis_scripts}/RESfinder_results_compiler.sh" "$RESfinder_OUTPUT_FOLDER_NAME" "$RESfinder_OUTPUT_FOLDER_NAME"