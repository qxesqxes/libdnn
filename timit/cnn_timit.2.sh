#!/bin/bash -e

dir=/share/Research/2014.1127.timit.libdnn/

# small="| head -n 1"
ctx="--left-context=20 --right-context=33"
noargs="--print-args=false"

# MFCC 13*3 = 39, dimension of fbank = 65
ark1="cat $dir/scp/train.fbank.65.scp $small | splice-feats $noargs $ctx scp:- ark:-"
ark2="cat $dir/scp/dev.fbank.65.scp   $small | splice-feats $noargs $ctx scp:- ark:-"

pdf1="cat $dir/pdf/train.pdf.txt  $small"
pdf2="cat $dir/pdf/dev.pdf.txt    $small"

# model_init=$dir/new-cnn/cnn.init.xml
model_init=$dir/new-cnn/cnn.mature.dropout.xml.5
# model=$dir/new-cnn/timit.cnn.dropout.xml.mature

struct="--struct 30x8x7-2s-10x8x5-4095-4095-4095"
dim="--input-dim 65x54"

# nn-init $struct $dim --output-dim 2425 -o $model_init

opts="$dim --batch-size 251 --cache 1024 --learning-rate 0.01"
nn-train "ark:$ark1,$pdf1" $model_init "ark:$ark2,$pdf2" ${model_init}.mature $opts

# model_mature=$dir/new-cnn/cnn.mature.dropout.xml.3
# nn-predict $dim "ark:$ark1,$pdf1" $model_mature --silent true --output 2
