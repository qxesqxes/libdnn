#!/bin/bash -e

dir=/share/Research/2014.1127.timit.libdnn/

# small="| head -n 1"
ctx="--left-context=39 --right-context=25"
noargs="--print-args=false"

# MFCC 13*3 = 39, dimension of fbank = 65
ark1="cat $dir/scp/train.fbank.65.scp $small | splice-feats $noargs $ctx scp:- ark:-"
ark2="cat $dir/scp/dev.fbank.65.scp   $small | splice-feats $noargs $ctx scp:- ark:-"

pdf1="cat $dir/pdf/train.pdf.txt  $small"
pdf2="cat $dir/pdf/dev.pdf.txt    $small"

expdir=new-cnn-3
model_init=$dir/$expdir/cnn.init.xml

struct="--struct 20x8x8-2s-20x6x6-2s-2047-2047"
dim="--input-dim 65x65"
norm="timit.65x65.stat"
# data-statistics --input-dim 4225 "ark:$ark1" $norm --normalize 2

# ===================
# ===== nn-init =====

# nn-init $struct $dim --output-dim 2425 -o $model_init

# ====================
# ===== nn-train =====

opts="$dim --batch-size 251 --cache 1024 --learning-rate 0.01 --normalize 2 --nf $norm"
nn-train "ark:$ark1,$pdf1" $model_init "ark:$ark2,$pdf2" ${model_init}.mature $opts

# ======================
# ===== nn-predict =====

# model_mature=$dir/$expdir/cnn.mature.dropout.xml.3
# nn-predict $dim "ark:$ark1,$pdf1" $model_mature --silent true --output 2
