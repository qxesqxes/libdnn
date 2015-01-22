#!/bin/bash -e

# Example 4
TRAIN=data/train2.dat
opts="--input-dim 32x32 --base 1"
model=/media/boton/HGST-3TB/Data1/Dropbox/libdnn/example/cnn.3.mature.xml
../bin/dnn-train $opts $TRAIN $model --output-dim 12 --learning-rate 0.05 --min-acc 0.93
