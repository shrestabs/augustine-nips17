#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && source "${THIS_DIR}/requirements.sh"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CLI_MAIN_CLASS='org.linqs.psl.cli.Launcher'

PSL_METHODS_CLI_OPTIONS=('--postgres psl')
PSL_DEFAULT_OPTIONS='-D log4j.threshold=DEBUG'
PSL_DEFAULT_LEARN_OPTIONS=''
PSL_DEFAULT_EVAL_OPTIONS=''

function psl::runSuite() {
   local modelName=$1   # e.g. collective-classification
   local baseDir=$2     # e.g. 
   local runId=$3
   local genDataLearnParams=$4
   local genDataEvalParams=$5
   local evalCliOptions=$6 #
   local runLearn=$7

   local outBaseDir="${baseDir}/out"
   local cliDir="${baseDir}/psl-cli"
   local scriptsDir="${baseDir}/scripts"

   # just 1 PSL method in this repo
    local methodCliOptions="${PSL_METHODS_CLI_OPTIONS}"     # e.g. --postgres psl
    local methodJar="${PSL_JAR_PATH}"

    local outDir="${outBaseDir}/${method}/${runId}"
    local modelPath="${cliDir}/${modelName}.psl"

#TODO(shrbs): add runEval here

    if [ "${runLearn}" = true ] ; then
        psl::runLearn \
        "${outDir}" \
        "${modelName}" \
        "${cliDir}" \
        "${scriptsDir}" \
        "${genDataLearnParams}" \
        "${modelPath}" \
        "${methodCliOptions}" \
        "${methodJar}"

        modelPath="${outDir}/${modelName}-learned.psl"
    fi

    psl::runEval \
        "${outDir}" \
        "${modelName}" \
        "${cliDir}" \
        "${scriptsDir}" \
        "${genDataEvalParams}" \
        "${modelPath}" \
        "${methodCliOptions} ${evalCliOptions}" \
        "${methodJar}"
}

function psl::runLearn() {
   local outDir=$1
   local modelName=$2
   local cliDir=$3
   local scriptsDir=$4
   local genDataParams=$5
   local modelPath=$6
   local extraCliOptions=$7
   local classpath=$8

   mkdir -p $outDir

   local generateDataScript="${scriptsDir}/generateDataFiles.rb"
   local dataTemplatePath="${cliDir}/${modelName}-template.data"
   local defaultLearnedModelPath="${cliDir}/${modelName}-learned.psl"
   local outputLearnPath="${outDir}/out-learn.txt"
   local outputTimePath="${outDir}/time-learn.txt"
   local learnDataFilePath="${outDir}/learn.data"
   local learnedModelPath="${outDir}/${modelName}-learned.psl"

   if [ -f "${outputLearnPath}" ]; then
      echo "Target PSL (learn) file exists (${outputLearnPath}), skipping run."
      return
   fi

   echo "Generating PSL (learn) data file to ${learnDataFilePath}."
   ruby $generateDataScript $dataTemplatePath $learnDataFilePath $genDataParams

   # Build the CLI options one at a time for visibility.
   local cliOptions=''
   cliOptions="${cliOptions} -learn"
   cliOptions="${cliOptions} -data ${learnDataFilePath}"
   cliOptions="${cliOptions} -model ${modelPath}"
   cliOptions="${cliOptions} ${extraCliOptions}"
   cliOptions="${cliOptions} -output ${outDir}"
   cliOptions="${cliOptions} ${PSL_DEFAULT_OPTIONS}"
   cliOptions="${cliOptions} ${PSL_DEFAULT_LEARN_OPTIONS}"

   echo "Running PSL (learn). Output redirected to ${outputLearnPath}."
   `requirements::time` `requirements::java` -cp "${classpath}" $CLI_MAIN_CLASS $cliOptions > $outputLearnPath 2> $outputTimePath
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
   local classpath=$8

   mkdir -p $outDir

   local generateDataScript="${scriptsDir}/generateDataFiles.rb"
   local dataTemplatePath="${cliDir}/${modelName}-template.data"
   local outputEvalPath="${outDir}/out-eval.txt"
   local outputTimePath="${outDir}/time-eval.txt"
   local evalDataFilePath="${outDir}/eval.data"

   if [ -f "${outputEvalPath}" ]; then
      echo "Target PSL (eval) file exists (${outputEvalPath}), skipping run."
      return
   fi

   echo "Generating PSL (eval) data file to ${evalDataFilePath}."
   ruby $generateDataScript $dataTemplatePath $evalDataFilePath $genDataParams

   # Build the CLI options one at a time for visibility.
   local cliOptions=''
   cliOptions="${cliOptions} -infer"
   cliOptions="${cliOptions} -data ${evalDataFilePath}"
   cliOptions="${cliOptions} -model ${modelPath}"
   cliOptions="${cliOptions} ${extraCliOptions}"
   cliOptions="${cliOptions} -output ${outDir}"
   cliOptions="${cliOptions} ${PSL_DEFAULT_OPTIONS}"
   cliOptions="${cliOptions} ${PSL_DEFAULT_EVAL_OPTIONS}"

   echo "Running PSL (eval). Output redirected to ${outputEvalPath}."
   `requirements::time` `requirements::java` -cp "${classpath}" $CLI_MAIN_CLASS $cliOptions > $outputEvalPath 2> $outputTimePath
}
