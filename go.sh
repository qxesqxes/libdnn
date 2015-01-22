#!/bin/bash
train=example/data/train2.dat2
train_label=example/data/train2.label
# train=example/data/train2.dat
# train_label=train2.label
test=example/data/test2.dat
opts="--input-dim 1024 --min-acc 0.75 --normalize 1 --base 1"
init=example/model/train2.rbm.xml
mature=example/model/train2.mature.xml
bin/nn-train $train,$train_label $init $test $opts
