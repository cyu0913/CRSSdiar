#!/bin/bash

# explore => FFQS with Preclustered Seeds
# consolidate => no
# constraint mearge => no
# post correctiom ==> no

log_start(){
  echo "#####################################################################"
  echo "Spawning *** $1 *** on" `date` `hostname`
  echo ---------------------------------------------------------------------
}

log_end(){
  echo ---------------------------------------------------------------------
  echo "Done *** $1 *** on" `date` `hostname`
  echo "#####################################################################"
}

. cmd.sh
. path.sh

set -e # exit on error

apollo_corpus=/home/chengzhu/work/NASA/Apollo11_Diar_Corpus_Longer_Each
eval_data="EECOM" # data for diarization

bottom_up_clustering(){
    log_start "Bottom Up Clustering With Ivector"

    diar/segment_clustering_ivector_constraint_cluster_seed.sh --nj 1 --apply-cmvn-utterance false --apply-cmvn-sliding false \
       --max-explore-pair-percentage 0.1 --merge-constraint false \
	--do-consolidate false --max-consolidate-pair-percentage 0.1 --ivector-dist-stop 0.7 exp/ref/$eval_data/segments exp/extractor_256 data/$eval_data exp/clustering_ivector_constraint/$eval_data

    log_end "Bottom Up Clustering With Ivector"
}
bottom_up_clustering

compute_der(){
	
    diar/compute_DER.sh --sanity_check false data/$eval_data exp/clustering_ivector_constraint/$eval_data/rttms exp/result_DER/$eval_data	
    grep OVERALL exp/result_DER/$eval_data/*.der && grep OVERALL exp/result_DER/$eval_data/*.der | awk '{ sum += $7; n++ } END { if (n > 0) print "Avergage: " sum / n; }'
}
compute_der
