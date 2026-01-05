#!/bin/bash

#any error -> exit
set -euo pipefail

#paths
analysis_scripts="/Users/B328695/Desktop/RESfinder/analysis/scripts"
OUTPUT_DIR="/Users/B328695/Desktop/RESfinder/analysis/runs"

#conda
. /opt/anaconda3/etc/profile.d/conda.sh
conda activate RESfinder

# args
# $1 = run dir name under runs/ (e.g. "test_output")
# $2 = output name prefix (e.g. "test_output")
if [ $# -lt 2 ]; then
    echo "Usage: $0 <run_dir_name> <output_prefix>"
    exit 1
fi

#input
resfinder_output_name=$1
output_name=$2

input_dir=$OUTPUT_DIR/$resfinder_output_name/processing_files
compiled_dir=$OUTPUT_DIR/$resfinder_output_name/compiled_files
mkdir -p $compiled_dir

# Compile ResFinder results
python "${analysis_scripts}/resfinder_results_Processor.py" \
                        $input_dir \
                        $compiled_dir/${output_name}

# Compile ResFinder phenotype predictions
python "${analysis_scripts}/resfinder_pheno_Processor.py" \
                    $input_dir \
                    $compiled_dir/${output_name}