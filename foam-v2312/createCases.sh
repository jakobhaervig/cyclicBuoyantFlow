#!/bin/bash

templateCase=verticalChannel_template
# Name of file containing list of parameters to change and values
parmScanFile=parameterMatrix
# Prefix name of created numbered test cases
scanName=verticalChannel
# Script to execute in each created case
execScript=

# Reading list of parameters to change
parmNames=($(sed -n '1p' $parmScanFile))
# For each parameter, which case file is it found in?
parmFiles=($(sed -n '2p' $parmScanFile))
# Length of list of new cases to be generated
nCases=$(($(wc -l < $parmScanFile) - 2))
# Number of digits for padding numbers in new case names
# nDigits=$(( ${#nCases} + 2 ))
# Note: The above did not work as intended. If starting with 6 cases and then
# later expanding to 11, 6 first will be recreated with an extra 0 in name.
# Using instead four digits hardcoded assuming never more than 10000 cases:
nDigits=4

#Running through cases and generating or running them
for ((i=0; i<nCases; i++)); do
    caseNumber=$(printf "%0${nDigits}d" "$i")
    #Which line in parmScanFile specifies parameter values of current case 
    parmLineNumber=$((i + 3))
    #Current case parameter values
    caseParms=($(sed -n ${parmLineNumber}p $parmScanFile))
    #Name of current case directory
    caseName=${scanName}_${caseNumber}
    if [ -d "$caseName" ];
    then
        if [ -z "$execScript" ]; then
            echo Case $caseName already exists - doing nothing.
        else
            cd ${caseName}
            echo Running script $caseScript in case $caseName
            ./$execScript
            cd -
        fi
    else
        echo Creating case $caseName
        cp -r $templateCase $caseName
        caseParmFile=$caseName/${caseName}_parms
        echo -n "$caseName: " >> $caseParmFile
        for m in ${!parmNames[*]}
        do
            parmName=${parmNames[$m]}
            parmFile=${parmFiles[$m]}
            parmValue=${caseParms[$m]}
            echo -n "    $parmName: $parmValue" >> $caseParmFile
            foamDictionary -disableFunctionEntries -entry "${parmName}" -set "${parmValue}" ${caseName}/${parmFile} > /dev/null 2>&1
        done
        echo >> $caseParmFile
        cat $caseParmFile
    fi
done
