bin=nnet-train-frmshuff
dir=/share/Research/20140609.timit.revision/
ft="--feature-transform=$dir/exp/mlp.mfcc/norm.nnet"
feature="add-deltas scp:/share/libdnns/libdnn_example/timit//train.mfcc.scp ark:- | splice-feats ark:- ark:- |"
label="$dir/nnet/train.label.txt"
$bin $ft --minibatch-size=256 ark:"$feature" ark,t:"$label" $dir/exp/mlp.mfcc/final.nnet b.nnet
