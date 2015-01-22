#!/bin/bash -e

dir=/share/Research/2014.1127.timit.libdnn/

# small="| head -n 1"
ctx="--left-context=20 --right-context=11"
noargs="--print-args=false"

# MFCC 13*3 = 39, dimension of fbank = 32
ark1="cat $dir/scp/train.fbank.32.scp $small | splice-feats $noargs $ctx scp:- ark:-"
ark2="cat $dir/scp/dev.fbank.32.scp   $small | splice-feats $noargs $ctx scp:- ark:-"

pdf1="cat $dir/pdf/train.pdf.txt  $small"
pdf2="cat $dir/pdf/dev.pdf.txt    $small"

model_init=$dir/new-cnn-2/cnn.init.xml
# model_init=$dir/new-cnn/cnn.mature.dropout.xml.3
# model=$dir/new-cnn/timit.cnn.dropout.xml.mature

struct="--struct 10x5x5-2s-20x3x3-2s-4095-4095-4095"
dim="--input-dim 32x32"

# nn-init $struct $dim --output-dim 2425 -o $model_init

opts="$dim --batch-size 251 --cache 1024 --learning-rate 0.1"
nn-train "ark:$ark1,$pdf1" $model_init "ark:$ark2,$pdf2" ${model_init}.mature $opts

# model_mature=$dir/new-cnn/cnn.mature.dropout.xml.3
# nn-predict $dim "ark:$ark1,$pdf1" $model_mature --silent true --output 2
