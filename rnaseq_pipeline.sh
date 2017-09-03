#!/bin/bash 

REFDIR=$1
SPECIES=$2 ## e.g. genprime_vM12
CPUS=$3

if [[ -d fastqs && "$(ls -A fastqs)" ]]; then
  echo "Found non-empty directory named fastqs! Continuing.."
else
  echo "ERROR: directory fastqs does not exist and is empty!"
  exit 1
fi

if [[ ! -d bams || ! -d tr_bams || ! -d stats || ! -d tdfs || ! -d RSEM || ! -d kallisto || ! -d FastQC || ! -d STAR_logs ]]
then
  echo "One of the required directories is missing, I will try to create them..."
  mkdir bams tr_bams stats tdfs RSEM kallisto FastQC STAR_logs
else 
  echo "All the necessary directories found, continuing..." 
fi 

cp ~/Dropbox/scripts/rnaseq_pipeline/*sh .

if [[ $SPECIES == "" || $REFDIR == "" ]]
then
  echo "ERROR: You have to specify REFDIR and SPECIES!"
  exit 1
fi

if [[ $CPUS == "" ]]
then 
  echo "Parallel jobs have been set to default - running on 4 cores."
  CPUS=4
else 
  echo "Parallel jobs will be ran on $CPUS cores."
fi

echo "Step 1: Running FastQC.."
./prun_fastqc.sh
echo "Step 2: Running STAR.."
./prun_star.sh $REFDIR $SPECIES $CPUS
echo "Step 3: Making TDF files.." 
./pmake_tdf.sh $SPECIES
echo "Step 4: Collecting RNA-seq stats.."
./prun_starstat.sh $REFDIR $SPECIES 

cd stats 
FLAG=`strand | tr "%" " " | awk '{sum+=$2} END {x=sum/NR; if (x<3) {print "RF"} else if (x>97) {print "FR"} else if (x>47 && x<53) {print "NONE"} else {print "ERROR"}}'`
if [[ $FLAG == "ERROR" ]]
then
  echo "ERROR: something is very much off with the strand-specificity of your RNA-seq!"
  exit 1
else 
  echo "The strandedness of your experiment was determined to be $FLAG"
fi
cd .. 

echo "Step 5: Running kallisto.." 
./prun_kallisto.sh $REFDIR $SPECIES $FLAG $CPUS
echo "Step 6: Running RSEM.."
./prun_rsem.sh $REFDIR $SPECIES $FLAG $CPUS

echo "All processing is now complete!"
