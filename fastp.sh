#!/bin/bash
set -xe
set -o pipefail

# Argument Checking
# '$# -ne 3' means 'if the number of arguments is not 3'

if [ $# -ne 3 ]; then
    echo "Usage: fastp.sh <SRR csv file> <SE or PE> <threads>"
    exit 1
fi


# Get Arguments
# 'mode' means 'Single-End or Pair-End'

text_file=$1
mode=$2
threads=$3

# Read from text file one row at a time

while IFS= read -r line; do
    echo "Processing $line"

#Separate process for SE and PE

 if [ "$mode" = "SE" ]; then

 # if SE...
    fastp -i "${line}.fastq.gz" -o "${line}_trim.fastq.gz" -h "${line}.html" -j "${line}.json" -w $threads 
    # If fastp command is successful, remove the original fastq file
    rm "${line}.fastq.gz"

elif [ "$mode" = "PE" ]; then
 # if PE...
    fastp -i "${line}_1.fastq.gz" -I "${line}_2.fastq.gz" -o "${line}_1_trim.fastq.gz" -O "${line}_2_trim.fastq.gz" -h "${line}.html" -j "${line}.json" -w $threads --detect_adapter_for_pe
    # If fastp command is successful, remove the original fastq files
    rm "${line}_1.fastq.gz"
    rm "${line}_2.fastq.gz"
else
    echo "Invalid mode: $mode"
    echo "See fastp --help"
    exit 1
fi 

done < "$text_file"

cat << EOS
RUN : success!
EOS



