#!/bin/bash -e

PATH=$PATH:/home/boton/libdnn/bin/

# dir=/share/Research/2014.1127.timit.libdnn/
dir=exp/new-cnn-7
mkdir -p $dir

# small="| head -n 1"
ctx="--left-context=39 --right-context=24"
noargs="--print-args=false"

# dimension of fbank = 64
GetFeats="cat scp/__SET__.fbank.64.scp $small"
SelectFeats="select-feats $noargs"
SpliceFeats="splice-feats $noargs $ctx scp:- ark:-"
AddDeltas="add-deltas $noargs ark:- ark:-"
Paste="/share/tools/kaldi-trunk/src/featbin/paste-feats $noargs"

band_1="$GetFeats | $SpliceFeats | $AddDeltas"

feats="$band_1"

pdfs="cat pdf/__SET__.pdf.txt $small"

ark1=${feats//__SET__/train}
ark2=${feats//__SET__/dev}

pdf1=${pdfs//__SET__/train}
pdf2=${pdfs//__SET__/dev}

model_init=$dir/cnn.init.xml
# model_out=$dir/cnn.mature.xml.1
# model_init=$dir/cnn.mature.xml.1
model_out=$dir/cnn.mature.xml.1

struct="--struct 40x5x5-40x5x5-2s-40x3x3-40x3x3-2s-40x3x3-40x3x3-2s-4095-4095"
dim="--input-dim 3x64x64"
norm=material/timit.3x64x64.norm
# data-statistics --input-dim 12288 "ark:$ark1" $norm --normalize 2

# ===================
# ===== nn-init =====

# nn-init $struct $dim --output-dim 2425 -o $model_init

# ====================
# ===== nn-train =====

echo "additional args: $@"

opts="$dim --batch-size 256 --cache 1024 --learning-rate 0.1 --normalize 2 --nf $norm"
nn-train "ark:$ark1,$pdf1" $model_init "ark:$ark2,$pdf2" $model_out $opts --save-model-per-epoch true $@

# ======================
# ===== nn-predict =====

# model_mature=$dir/$dir/cnn.mature.dropout.xml.3
# nn-predict $dim "ark:$ark1,$pdf1" $model_mature --silent true --output 2
