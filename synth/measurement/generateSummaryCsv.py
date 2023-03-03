#!/usr/bin/python3
import sys, os, re, csv

def combineSummaries(summariesDir):
    LC_MAX = 7680
    RAM_MAX = 32
    resultEntry = {
                    'lc[absolute]' :{},
                    'lc[percent]' : {}, 
                    'mem[absolute]' : {}, 
                    'mem[percent]' : {}, 
                    'f_max' : {},
                    'synth time' : {},
                    'pnr time' : {}
                }

    for filename in os.listdir(summariesDir):
        expNum = os.path.splitext(filename)[0]
        print("SEED: " + expNum)
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
                if(row['Description'] == 'fmax [MHz]'):
                    fMax = row['Value']
                    resultEntry['f_max'][expNum] = fMax
                if(row['Description'] == 'Synth Time [M:s.ms]'):
                    synTime = row['Value']
                    resultEntry['synth time'][expNum] = synTime
                if(row['Description'] == 'PnR Time [M:s.ms]'):
                    pnrTime = row['Value']
                    resultEntry['pnr time'][expNum] = pnrTime
    print(resultEntry)
    # expNum = os.path.basename(os.path.dirname(summariesDir))


    # write CSV for folder
    # with open(summaryDir + expNum +".csv", "w") as csvfile:
    #     filewriter = csv.writer(csvfile, delimiter=',', quotechar='"',
    #                             quoting=csv.QUOTE_MINIMAL, lineterminator="\n")
    #     # header
    #     filewriter.writerow(['Description', 'Value'])
    #     # entries
    #     filewriter.writerow(['Slice (Logic Area)', 
    #                         (resultEntry['lc[absolute]'] + " / " + str(LC_MAX) + " (" + resultEntry['lc[percent]'] + ")")
    #                     ])
    #     filewriter.writerow(['Memory (BRAM)',
    #                         (resultEntry['mem[absolute]'] + " / " + str(RAM_MAX) + " (" + resultEntry['mem[percent]'] + ")")
    #                     ])
    #     filewriter.writerow(['f_max [MHz]',resultEntry['f_max']])
    #     filewriter.writerow(['Synth Time [M:s.ms]',resultEntry['synth time']])
    #     filewriter.writerow(['PnR Time [M:s.ms]',resultEntry['pnr time']])

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Error, wrong number of arguments!")
    else:
        sumDir = sys.argv[1]
        combineSummaries(sumDir)
