#!/bin/bash
mySeed=0

#for dir in ./!(tmp)/; do mkdir $dir/exp; done
#rm -rf ./!(tmp)/exp/*
#rm -rf ./!(tmp)/summaries/*

copy_and_execute() { ## $1:directory, $2: seed
    echo -e "Executing synth+pnr for $1 ($2)\n\n"
    rm -f tmp/*.v
    # copy files from $1 into root dir
    cp -r $1/rtl/*.v tmp/
    make -C tmp clean
    # run and log into directory $1
    make -C tmp all_hx8k rngSeed=$2
    # copy all results into $1/exp 
    if [ ! -d $1/exp/$2 ]; then
        mkdir $1/exp/$2
    fi
    cp -r tmp/* $1/exp/$2
    # cp -r tmp/ecp5 $1/exp/$2
    echo -e "Done synth+pnr for $1 ($2)\n\n"
}

make_csv_for_run() { # $1: directory to create summary from logs
    # touch $1/summary_hx8k.csv
    expDir=($1exp)
    sumDir=($1summaries/)
    # echo $1
    # echo $expDir
    for seedDir in $expDir/*; do
        # echo $seedDir
        ./generateCsv.py $seedDir/ $sumDir
    done
    ./generateSummaryCsv.py $sumDir
}

make_csv_for_all(){

    for dir in ./!(tmp)/; do
        # echo $dir
        make_csv_for_run $dir
    done
}

run_seeded_exp(){
    for i in {1..10}
    do
        echo "******* Run $i *******"
        mySeed=$RANDOM
        for dir in ./!(tmp)/; do
            # : $(copy_and_execute $dir $mySeed)
            copy_and_execute $dir $mySeed
        done
    done
}

