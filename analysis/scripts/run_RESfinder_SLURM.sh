#!/bin/bash
#
#SBATCH --partition=project
#SBATCH --job-name=RESfinder_run
#SBATCH --output=/Users/B328695/Desktop/RESfinder/analysis/logs/RESfinder_%j.out
#SBATCH --error=/Users/B328695/Desktop/RESfinder/analysis/logs/RESfinder_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00

#any error -> exit
set -euo pipefail

# activate conda environment 
. /opt/anaconda3/etc/profile.d/conda.sh
conda activate RESfinder

# paths
RESFINDER_DB="/Users/B328695/Desktop/RESfinder/dbs/resfinder_db"
POINTFINDER_DB="/Users/B328695/Desktop/RESfinder/dbs/pointfinder_db"
DISINFINDER_DB="/Users/B328695/Desktop/RESfinder/dbs/disinfinder_db"

SCRIPT_DIR="/Users/B328695/Desktop/RESfinder/analysis/scripts"
OUTPUT_DIR="/Users/B328695/Desktop/RESfinder/analysis/runs"

# Define input parameters
INPUT_DATA_FOLDER=$1
OUTPUT_FOLDER_NAME=$2
THREADS=${3:-${SLURM_CPUS_PER_TASK:-4}}  # Default to 4 threads if not provided

# check input parameters
if [ $# -lt 2 ]; then
    echo "Usage: $0 <input_data_folder> <output_folder_name> [threads]"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR/${OUTPUT_FOLDER_NAME}"
OUTPUT="$OUTPUT_DIR/${OUTPUT_FOLDER_NAME}"

# guard against accidental overwrite
if [ -d "$OUTPUT" ] && [ -n "$(ls -A "$OUTPUT")" ]; then
    echo "ERROR: Output directory '$OUTPUT' already exists and is not empty."
    echo "Choose a new output_folder_name or clean it manually."
    exit 1
fi

# Run ResFinder for each FASTA file in the input folder using GNU parallel processing
run_resfinder () {
    fasta_file_path="$1"
    fasta_file=$(basename "$1")
    output_subdir="$OUTPUT/processing_files/$(basename "${fasta_file%.*}")"

    mkdir -p "$output_subdir"

    python -m resfinder \
        -ifa "$fasta_file_path" \
        -o "$output_subdir" \
        -s "Escherichia coli" \
        -db_res $RESFINDER_DB \
        -l 0.6 \
        -t 0.9 \
        -db_disinf $DISINFINDER_DB \
        -db_point $POINTFINDER_DB \
        --acquired \
        --point
}
export OUTPUT RESFINDER_DB DISINFINDER_DB POINTFINDER_DB
export -f run_resfinder

parallel --jobs $THREADS run_resfinder {} ::: "$INPUT_DATA_FOLDER"/*.fasta

# Deactivate conda environment
conda deactivate