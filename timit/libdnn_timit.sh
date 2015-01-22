#!/bin/bash -e

dir=/share/Research/2014.1127.timit.libdnn/
model=$dir/baseline-dnn/dnn.dropout.epoch.40.xml.mature
#model=$dir/baseline-dnn/dnn.xml

# small="| head -n 100"
# ctx="--left-context=500 --right-context=500"
noargs="--print-args=false"

ark1="cat $dir/scp/train.mfcc.scp $small | add-deltas $noargs scp:- ark:- | splice-feats $noargs $ctx ark:- ark:-"
ark2="cat $dir/scp/dev.mfcc.scp   $small | add-deltas $noargs scp:- ark:- | splice-feats $noargs $ctx ark:- ark:-"

pdf1="cat $dir/pdf/train.pdf.txt  $small"
pdf2="cat $dir/pdf/dev.pdf.txt    $small"

dnn-train --input-dim 351 "ark:$ark1,$pdf1" $model "ark:$ark2,$pdf2" ${model}.mature --normalize 2 --max-epoch 20
# "ark:$ark2,$pdf2" 
# dnn-init --input-dim 351 --type 1 --nodes 1024-1024 --output-dim 3445 "ark:$ark1,$pdf1" timit.rbm.init --normalize 2 --max-epoch 20
