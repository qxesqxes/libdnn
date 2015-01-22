#!/bin/bash -e

# Example 5: CNN-DNN with random initialization
TRAIN=data/train2.dat
struct="--struct 10x5x5-2s-10x3x3-2s-512-512"
model=model/train2.cnn.init.xml
model_mature=model/train2.cnn.mature.xml
dim="--input-dim 32x32"

../bin/nn-init $dim $struct -o $model --output-dim 12
../bin/nn-train $dim $TRAIN $model - $model_mature --base 1 --min-acc 0.8
../bin/nn-predict $dim $TRAIN $model_mature --base 1 
