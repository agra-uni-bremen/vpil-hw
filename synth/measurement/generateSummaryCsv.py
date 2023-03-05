#!/usr/bin/python3
import sys, os, re, csv

def combineSummaries(summariesDir):
    LC_MAX = 7680
    RAM_MAX = 32
    # each entry contains a row, each row is accessible through the seed id
    resultEntry = {
                    'lc[absolute]' :{},
                    'lc[percent]' : {}, 
                    'mem[absolute]' : {}, 
                    'mem[percent]' : {}, 
                    'f_max' : {},
                    'synth time' : {},
                    'pnr time' : {}
                }
    keyList = ['lc[absolute]', 'lc[percent]', 'mem[absolute]', 'mem[percent]', 'f_max', 'synth time', 'pnr time']

    # seed ids will also be the key for the dictionary per row
    summaryFieldNames = ['Description'] # append all seed ids 

    for filename in os.listdir(summariesDir):
        expNum = os.path.splitext(filename)[0]
        # print("SEED: " + expNum)
        summaryFieldNames.append(expNum)
        dirToSummary = os.path.join(summariesDir, filename)
        with open(dirToSummary) as csvSummary:
            reader = csv.DictReader(csvSummary)
            for row in reader:
                #print(row['Description'], row['Value'])
                if(row['Description'] == 'Slice (Logic Area)'):
                    sliceList = row['Value'].split(' ')
                    lcAbs = sliceList[0]
                    lcRel = sliceList[3].split('%')[0].split('(')[-1] # hmm
                    resultEntry['lc[absolute]'][expNum] = lcAbs
                    resultEntry['lc[percent]'][expNum] = lcRel
                if(row['Description'] == 'Memory (BRAM)'):
                    memoryList = row['Value'].split(' ')
                    memAbs = memoryList[0]
                    memRel = memoryList[3].split('%')[0].split('(')[-1] # hmm
                    resultEntry['mem[absolute]'][expNum] = memAbs
                    resultEntry['mem[percent]'][expNum] = memRel
                if(row['Description'] == 'f_max [MHz]'):
                    fMax = row['Value']
                    resultEntry['f_max'][expNum] = fMax
                if(row['Description'] == 'Synth Time [s.ms]'):
                    synTime = row['Value']
                    resultEntry['synth time'][expNum] = synTime
                if(row['Description'] == 'PnR Time [s.ms]'):
                    pnrTime = row['Value']
                    resultEntry['pnr time'][expNum] = pnrTime

    # prepare data for csv dict writer (could have done that right away?)
    csvRows = []
    oneRow = {}
    for description in keyList:
        for entry in summaryFieldNames:
            if entry == 'Description':
                oneRow[entry] = description
            else:
                oneRow[entry] = resultEntry[description][entry]
        csvRows.append(oneRow.copy())
        
    # write CSV for folder
    partentDir = os.path.abspath(os.path.join(summariesDir,os.pardir))
    with open(partentDir + "/summary.csv", "w") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=summaryFieldNames)
        writer.writeheader()
        for rowEntry in csvRows:
            writer.writerow(rowEntry)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Error, wrong number of arguments!")
    else:
        sumDir = sys.argv[1]
        combineSummaries(sumDir)
