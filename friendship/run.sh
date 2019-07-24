#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/requirements.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/psl.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/../scripts/tuffy.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DATA_GEN_SCRIPT="${THIS_DIR}/scripts/generateFriendshipData.rb"

# Redefine for experiment specifics.
PSL_METHODS=('psl-admm-postgres' 'psl-2.0' 'psl-1.2.1')
PSL_METHODS_CLI_OPTIONS=('--postgres psl' '' '')
PSL_METHODS_JARS=("${PSL_JAR_PATH}" "${PSL2_JAR_PATH}" "${PSL121_JAR_PATH}")

function run() {
   local outBaseDir="${THIS_DIR}/out"
   local folds="$(seq -w -s ' ' 30 10 0100)"
   local folds="$(seq -w -s ' ' 30 10 0100) $(seq -w -s ' ' 100 100 1000)"

   for fold in $folds; do
      # Generate the data.
      if [ ! -e "${THIS_DIR}/data/friendship/${fold}" ]; then
         ruby $DATA_GEN_SCRIPT -p $fold -l 10 -fh 0.85 -fl 0.15 -n friendship
         mkdir -p "${THIS_DIR}/data/friendship"
         mv "${THIS_DIR}/data/friendship_${fold}_0010" "${THIS_DIR}/data/friendship/${fold}"
      fi

      # PSL
      psl::runSuite \
         'friendship' \
         "${THIS_DIR}" \
         "${fold}" \
         '' \
         "${fold}" \
         '-ec -ed 0.5' \
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
