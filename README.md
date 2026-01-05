SETUP

## create conda env:
conda create -n RESfinder
conda activate RESfinder

## install RESfinder (make sure env is activated)
conda install resfinder

## clone dbs (place somewhere you know the location of)
git clone https://bitbucket.org/genomicepidemiology/resfinder_db/
git clone https://bitbucket.org/genomicepidemiology/pointfinder_db/
git clone https://bitbucket.org/genomicepidemiology/disinfinder_db/

## configure /path/to/analysis_scripts

## run it