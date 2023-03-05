#!/usr/bin/python3
import sys, os, re, csv

def makeHX8KCSV(dir, summaryDir):
    LC_MAX = 7680
    RAM_MAX = 32
    resultEntry = {
                    'lc[absolute]' :'',
                    'lc[percent]' : '', 
                    'mem[absolute]' : '', 
                    'mem[percent]' : '', 
                    'f_max' : '',
                    'synth time' : '',
                    'pnr time' : ''
                }
    regexLC = re.compile("(?<=(ICESTORM\_LC\:))(\s+((\d+)\/\s+\d+\s+(\d+\%)))")
    regexMEM = re.compile("(?<=(ICESTORM\_RAM\:))(\s+((\d+)\/\s+\d+\s+(\d+\%)))")
    regexFMax = re.compile("\d+.\d+ MHz(?=\s\()")
    regexSTime = re.compile("((\d+:)\d+\.\d+\s)(?=(real))")
    regexPTime = re.compile("((\d+:)\d+\.\d+\s)(?=(real))")
    
    expNum = os.path.basename(os.path.dirname(dir))

    with open(dir+"/pnr_stat.log", 'r') as f:
        lines = f.readlines()
        for line in lines:
            matchedLC = regexLC.search(line)
            matchedMem = regexMEM.search(line)
            matchedFMax = regexFMax.search(line)
            if(matchedLC != None):
                splitLC = re.split(r"[\s/]",re.sub(r'\s+',' ',matchedLC.group().strip()))
                resultEntry['lc[absolute]'] = splitLC[0]
                resultEntry['lc[percent]'] = splitLC[-1]
            if(matchedMem != None):
                splitMem = re.split(r"[\s/]",re.sub(r'\s+',' ',matchedMem.group().strip()))
                resultEntry['mem[absolute]'] = splitMem[0]
                resultEntry['mem[percent]'] = splitMem[-1]
            if(matchedFMax != None):
                splitFMax = re.split(r"[\s/]",matchedFMax.group())
                resultEntry['f_max'] = splitFMax[0]
    with open(dir+"/time_synth.log", 'r') as f:
        lines = f.readlines()
        for line in lines:
            matchedTime = regexSTime.search(line)
            if(matchedTime != None):
                resultEntry['synth time'] = matchedTime.group()
    with open(dir+"/time_pnr.log", 'r') as f:
        lines = f.readlines()
        for line in lines:
            matchedTime = regexPTime.search(line)
            if(matchedTime != None):
                resultEntry['pnr time'] = matchedTime.group()
    # write CSV for folder
    with open(summaryDir + expNum +".csv", "w") as csvfile:
        filewriter = csv.writer(csvfile, delimiter=',', quotechar='"',
                                quoting=csv.QUOTE_MINIMAL, lineterminator="\n")
        # header
        filewriter.writerow(['Description', 'Value'])
        # entries
        filewriter.writerow(['Slice (Logic Area)', 
                            (resultEntry['lc[absolute]'] + " / " + str(LC_MAX) + " (" + resultEntry['lc[percent]'] + ")")
                        ])
        filewriter.writerow(['Memory (BRAM)',
                            (resultEntry['mem[absolute]'] + " / " + str(RAM_MAX) + " (" + resultEntry['mem[percent]'] + ")")
                        ])
        filewriter.writerow(['f_max [MHz]',resultEntry['f_max']])
        filewriter.writerow(['Synth Time [M:s.ms]',resultEntry['synth time']])
        filewriter.writerow(['PnR Time [M:s.ms]',resultEntry['pnr time']])

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Error, wrong number of arguments!")
    else:
        expDir = sys.argv[1]
        summaryDir = sys.argv[2]
        # print(sys.argv)
        makeHX8KCSV(expDir, summaryDir)
