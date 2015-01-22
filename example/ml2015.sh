#!/bin/bash -e

# ML2015 final contest
dim="--input-dim 64x64"

# CNN initialization
struct="--struct 20x7x7-2s-20x6x6-2s-20x5x5-2s-1023"
init_model="ml2015.init.xml"
# ../bin/nn-init $dim --output-dim 32 $struct -o $init_model
# printf "Model saved to \33[32m $init_model \33[0m\n"
# init_model=ml2015.init.xml.mature.3

# CNN Training
TRAIN=data/train3.dat
TEST=data/test3.dat
mature_model=${init_model//3/4}

../bin/nn-train $TRAIN $init_model $TEST $mature_model $dim --batch-size 511 --min-acc 0.9 --learning-rate 0.05 --save-model-per-epoch true
../bin/nn-predict $TRAIN $mature_model $TEST $dim --min-acc 0.8
