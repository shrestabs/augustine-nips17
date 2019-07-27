#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/requirements.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CLI_MAIN_CLASS='org.linqs.psl.cli.Launcher'
WEIGHT_LEARNING_CLASS='org.linqs.psl.application.learning.weight'
EVALUTION_METRIC_CLASS='org.linqs.psl.evaluation.statistics'

PSL_METHODS_CLI_OPTIONS=('--postgres psl')
PSL_DEFAULT_OPTIONS='-D log4j.threshold=DEBUG'
PSL_DEFAULT_LEARN_OPTIONS=''
PSL_DEFAULT_EVAL_OPTIONS=''


function psl::runSuite() {
   local modelName=$1   # e.g. collective-classification
   local baseDir=$2     # e.g. ./collective-classification
   local runId=$3       #e.g citseer/0 where 0 is split
   local genDataLearnParams=$4 # e.g. ${dataset} ${fold} learn"
   local genDataEvalParams=$5   # sent directly to ruby scripts
   local evalCliOptions=$6  # sent directly to ruby scripts
   local wlMethod=$7    # e.g. bayesian.GaussianProcessPrior
   local evalMethod=$8    # e.g CategoricalEvaluator

   local outBaseDir="${baseDir}/out"
   local cliDir="${baseDir}/psl-cli"
   local scriptsDir="${baseDir}/scripts"

   # just 1 PSL method in this repo
    local methodCliOptions="${PSL_METHODS_CLI_OPTIONS}"     # e.g. --postgres psl
    local outDir="${outBaseDir}/${method}/${runId}"
    local modelPath="${cliDir}/${modelName}.psl"    # e.g. psl-cli/collective-classification.psl

    # evaluate uniform before starting weight learning once i.e the first time
    if [[ ! -f "${outDir}/out-eval-uniform.txt" ]]; then
        psl::runEval \
            "${outDir}" \
            "${modelName}" \
            "${cliDir}" \
            "${scriptsDir}" \
            "${genDataEvalParams}" \
            "${modelPath}" \
            "${methodCliOptions} ${evalCliOptions}" \
            "uniform"   \
            "${evalMethod}"
    fi

    psl::runLearn \
        "${outDir}" \
        "${modelName}" \
        "${cliDir}" \
        "${scriptsDir}" \
        "${genDataLearnParams}" \
        "${modelPath}" \
        "${methodCliOptions}" \
        "${wlMethod}"

    modelPath="${outDir}/${modelName}-${wlMethod}-learned.psl"


    # evaluate the particular weight learning method
    psl::runEval \
        "${outDir}" \
        "${modelName}" \
        "${cliDir}" \
        "${scriptsDir}" \
        "${genDataEvalParams}" \
        "${modelPath}" \
        "${methodCliOptions} ${evalCliOptions}" \
        "${wlMethod}"   \
        "${evalMethod}"
}

function psl::runLearn() {
   local outDir=$1
   local modelName=$2
   local cliDir=$3
   local scriptsDir=$4
   local genDataParams=$5
   local modelPath=$6
   local extraCliOptions=$7
   local wlMethod=$8

   mkdir -p $outDir

   local generateDataScript="${scriptsDir}/generateDataFiles.rb"
   local dataTemplatePath="${cliDir}/${modelName}-template.data"
   local defaultLearnedModelPath="${cliDir}/${modelName}-${wlMethod}-learned.psl"
   local outputLearnPath="${outDir}/out-learn.txt"
   local outputTimePath="${outDir}/time-learn.txt"
   local learnDataFilePath="${outDir}/learn.data"
   local learnedModelPath="${outDir}/${modelName}-${wlMethod}-learned.psl"

   if [ -f "${learnedModelPath}" ]; then
      echo "Target PSL (learn) file exists (${outputLearnPath}), skipping run."
      return
   fi

   echo "Generating PSL (learn) data file to ${learnDataFilePath}."
   ruby $generateDataScript $dataTemplatePath $learnDataFilePath $genDataParams

   # Build the CLI options one at a time for visibility.
   local cliOptions=''
   cliOptions="${cliOptions} --model ${modelPath}"
   cliOptions="${cliOptions} --learn  ${WEIGHT_LEARNING_CLASS}.${wlMethod}"
   cliOptions="${cliOptions} --data ${learnDataFilePath}"
   cliOptions="${cliOptions} ${extraCliOptions}"
   cliOptions="${cliOptions} --output ${outDir}"
   cliOptions="${cliOptions} ${PSL_DEFAULT_OPTIONS}"
   cliOptions="${cliOptions} ${PSL_DEFAULT_LEARN_OPTIONS}"

   echo "Running PSL (learn). Output redirected to ${outputLearnPath}."
   `requirements::time` `requirements::java` -jar "${PSL_JAR_PATH}" $cliOptions > $outputLearnPath 2> $outputTimePath

   mv ${defaultLearnedModelPath} ${learnedModelPath}
}

function psl::runEval() {
   local outDir=$1
   local modelName=$2
   local cliDir=$3
   local scriptsDir=$4
   local genDataParams=$5
   local modelPath=$6
   local extraCliOptions=$7
   local wlMethod=$8
   local evalMethod=$9

   mkdir -p $outDir

   local generateDataScript="${scriptsDir}/generateDataFiles.rb"
   local dataTemplatePath="${cliDir}/${modelName}-template.data"
   local outputEvalPath="${outDir}/out-eval-${wlMethod}.txt"
   local outputTimePath="${outDir}/time-eval-${wlMethod}.txt"
   local evalDataFilePath="${outDir}/eval.data"

   if [ -f "${outputEvalPath}" ]; then
      echo "Target PSL (eval) file exists (${outputEvalPath}), skipping run."
      return
   fi

   echo "Generating PSL (eval) data file to ${evalDataFilePath}."
   ruby $generateDataScript $dataTemplatePath $evalDataFilePath $genDataParams

   # Build the CLI options one at a time for visibility.
   local cliOptions=''
   cliOptions="${cliOptions} --model ${modelPath}"
   cliOptions="${cliOptions} --data ${evalDataFilePath}" # e.g. /shresta/views/augustine-nips17-weightlearning-experiments/collective-classification/out//citeseer/1/eval.data
   cliOptions="${cliOptions} ${extraCliOptions}"
   cliOptions="${cliOptions} --output ${outDir}"
   cliOptions="${cliOptions} ${PSL_DEFAULT_OPTIONS}"
   cliOptions="${cliOptions} --infer"
   cliOptions="${cliOptions} --eval ${EVALUTION_METRIC_CLASS}.${evalMethod}"

   echo "Running PSL (eval). Output redirected to ${outputEvalPath}."
   `requirements::time` `requirements::java` -jar "${PSL_JAR_PATH}" $cliOptions > $outputEvalPath 2> $outputTimePath
}
