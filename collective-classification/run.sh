#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/scripts/fetchData.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/requirements.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/psl.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/tuffy.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function run() {
   local outBaseDir="${THIS_DIR}/out"
   # TODO(shrbs): get one dataset working local datasets='citeseer cora'
   local datasets='citeseer cora'
   # TODO(shrbs): get one fold working local folds=`seq -s ' ' 0 19`
   local folds=`seq -s ' ' 0 1`
   # define all weight learning experiments for each dataset
   local wl_methods='bayesian.GaussianProcessPrior maxlikelihood.MaxLikelihoodMPE maxlikelihood.MaxPiecewisePseudoLikelihood search.Hyperband search.InitialWeightHyperband search.grid.ContinuousRandomGridSearch search.grid.GuidedRandomGridSearch search.grid.RandomGridSearch'
   local eval_method='CategoricalEvaluator'
   for dataset in $datasets; do
      for fold in $folds; do
        for wl_method in $wl_methods; do
            # PSL
            echo "<----------- Now running DataSet:${dataset} Fold:${fold} Weight Learning Method:${wl_method} ----------->"
            psl::runSuite \
                'collective-classification' \
                "${THIS_DIR}" \
                "${dataset}/${fold}" \
                "${dataset} ${fold} learn" \
                "${dataset} ${fold} eval" \
                '' \
                "${wl_method}" \
                "${eval_method}"
        done

         # Tuffy
        #  tuffy::runSuite \
        #     "${THIS_DIR}" \
        #     "$THIS_DIR/data/splits" \
        #     "${dataset}/${fold}"

      done

   done
}

function main() {
   trap exit SIGINT

   requirements::check_requirements
   requirements::fetch_all_jars
   fetchData::main
   run
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
