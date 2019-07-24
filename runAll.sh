#!/bin/bash

#EXPERIMENTS='collective-classification epinions jester nell-kgi party-affiliation-scaling friendship'
EXPERIMENTS='collective-classification'

trap exit SIGINT

for experiment in $EXPERIMENTS; do
   pushd . > /dev/null
   cd "${experiment}"
   ./run.sh
   popd > /dev/null
done
