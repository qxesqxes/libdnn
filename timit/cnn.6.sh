#!/bin/bash -e

PATH=$PATH:/home/boton/libdnn/bin/

# dir=/share/Research/2014.1127.timit.libdnn/
dir=exp/new-cnn-6
mkdir -p $dir

# small="| head -n 1"
ctx="--left-context=10 --right-context=5"
noargs="--print-args=false"

# dimension of fbank = 64
GetFeats="cat scp/__SET__.fbank.64.scp $small"
SelectFeats="select-feats $noargs"
SpliceFeats="splice-feats $noargs $ctx ark:- ark:-"
AddDeltas="add-deltas $noargs ark:- ark:-"
Paste="/share/tools/kaldi-trunk/src/featbin/paste-feats"

band_1="$GetFeats | $SelectFeats  0-15 scp:- ark:- | $SpliceFeats | $AddDeltas"
band_2="$GetFeats | $SelectFeats 16-31 scp:- ark:- | $SpliceFeats | $AddDeltas"
band_3="$GetFeats | $SelectFeats 32-47 scp:- ark:- | $SpliceFeats | $AddDeltas"
band_4="$GetFeats | $SelectFeats 48-63 scp:- ark:- | $SpliceFeats | $AddDeltas"

feats="exec bash -c '$Paste $noargs ark:<($band_1) ark:<($band_2) ark:<($band_3) ark:<($band_4) ark:-'"

pdfs="cat pdf/__SET__.pdf.txt $small"

ark1=${feats//__SET__/train}
ark2=${feats//__SET__/dev}

pdf1=${pdfs//__SET__/train}
pdf2=${pdfs//__SET__/dev}

model_init=$dir/cnn.init.xml
# model_out=$dir/cnn.mature.xml.1
# model_init=$dir/cnn.mature.xml.1
model_out=$dir/cnn.mature.xml.1

struct="--struct 30x3x3-30x3x3-30x3x3-2s-2047-2047"
dim="--input-dim 12x16x16"
norm=material/timit.12x16x16.norm
# data-statistics --input-dim 3072 "ark:$ark1" $norm --normalize 2

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
