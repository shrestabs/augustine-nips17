#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/requirements.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/psl.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/tuffy.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DATA_GEN_SCRIPT="${THIS_DIR}/scripts/generateGraphData.rb"

function run() {
   local outBaseDir="${THIS_DIR}/out"

   local folds=`seq -w -s ' ' 000010000 1000 000020000`
   PSL_METHODS=('psl-admm-postgres' 'psl-2.0' 'psl-1.2.1')
   PSL_METHODS_CLI_OPTIONS=('--postgres psl' '' '')
   PSL_METHODS_JARS=("${PSL_JAR_PATH}" "${PSL2_JAR_PATH}" "${PSL121_JAR_PATH}")

   for fold in $folds; do
      # Generate the data.
      echo "Generating data for ${fold} nodes."
      local dataDir="${THIS_DIR}/data/processed/${fold}"
      ruby $DATA_GEN_SCRIPT $fold "${dataDir}"

      # PSL
      psl::runSuite \
         'party-affiliation' \
         "${THIS_DIR}" \
         "${fold}" \
         '' \
         "${fold}" \
         '' \
         false
   done

   local folds=`seq -w -s ' ' 000020000 5000 000090000`
   PSL_METHODS=('psl-admm-postgres' 'psl-2.0' 'psl-1.2.1')
   PSL_METHODS_CLI_OPTIONS=('--postgres psl' '' '')
   PSL_METHODS_JARS=("${PSL_JAR_PATH}" "${PSL2_JAR_PATH}" "${PSL121_JAR_PATH}")

   for fold in $folds; do
      # Generate the data.
      echo "Generating data for ${fold} nodes."
      local dataDir="${THIS_DIR}/data/processed/${fold}"
      ruby $DATA_GEN_SCRIPT $fold "${dataDir}"

      # PSL
      psl::runSuite \
         'party-affiliation' \
         "${THIS_DIR}" \
         "${fold}" \
         '' \
         "${fold}" \
         '' \
         false
   done

   local folds="$(seq -w -s ' ' 000100000 100000 010000000)"
   PSL_METHODS=('psl-admm-postgres' 'psl-2.0' 'psl-1.2.1')
   PSL_METHODS_CLI_OPTIONS=('--postgres psl' '' '')
   PSL_METHODS_JARS=("${PSL_JAR_PATH}" "${PSL2_JAR_PATH}" "${PSL121_JAR_PATH}")

   for fold in $folds; do
      # Generate the data.
      echo "Generating data for ${fold} nodes."
      local dataDir="${THIS_DIR}/data/processed/${fold}"
      ruby $DATA_GEN_SCRIPT $fold "${dataDir}"

      # PSL
      psl::runSuite \
         'party-affiliation' \
         "${THIS_DIR}" \
         "${fold}" \
         '' \
         "${fold}" \
         '' \
         false
   done

   local folds="002500000 005000000 007500000 010000000 020000000"
   PSL_METHODS=('psl-admm-postgres')
   PSL_METHODS_CLI_OPTIONS=('--postgres psl')
   PSL_METHODS_JARS=("${PSL_JAR_PATH}")

   for fold in $folds; do
      # Generate the data.
      echo "Generating data for ${fold} nodes."
      local dataDir="${THIS_DIR}/data/processed/${fold}"
      ruby $DATA_GEN_SCRIPT $fold "${dataDir}"

      # PSL
      psl::runSuite \
         'party-affiliation' \
         "${THIS_DIR}" \
         "${fold}" \
         '' \
         "${fold}" \
         '' \
         false
   done
}

function main() {
   trap exit SIGINT

   requirements::check_requirements
   requirements::fetch_all_jars
   run
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
