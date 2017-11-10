import sys

import pandas as pd
import os
import re
from os import listdir
from os.path import isfile, join

output_path = '/Users/mj/Documents/Courses/fall-2017/cse-572-data-mining/project/Data-mining/Data/Annotations_formatted/'
input_path = '/Users/mj/Documents/Courses/fall-2017/cse-572-data-mining/project/Data-mining/Data/Annotation'
def readcsv(name):
    return pd.read_csv(name)


def read_sort_write(filename):
    print(filename)
    file = open_file(filename)
    df = pd.DataFrame()

    for line in file:
        if line.__contains__(','):
            newline = re.split(",",line)
        else:
            newline = re.split("\s+", line)

        #newline = list(map(int, newline)

        newline = [s.rstrip() for s in newline]
        newline = list(filter(None, newline))
        newline = list(map(int, newline))
        newline = sorted(newline)
        last_two = newline[-2:]
        if len(last_two)>0:
            df = df.append(pd.DataFrame([last_two],columns=('start','end')), ignore_index=True)
        write_to_csv(df,filename)


def open_file(filename):
    path = os.path.join(input_path,filename)
    file = open(path, 'r')
    return file


def write_to_csv(df,filename):
    _filename = filename.split('.')[0]
    path = os.path.join(output_path,_filename+'.csv')
    df.to_csv(path,header=False,index=False)

def main(argv):
    onlyfiles = [f for f in listdir(input_path) if isfile(join(input_path, f)) and not f.startswith('.')]
    for f in onlyfiles:
        read_sort_write(f)
    
if __name__ == '__main__':
    main(sys.argv)








