import pandas as pd
import json
import sys
import numpy as np
from six.moves import xrange

def build_call_tree_threads(df):
    """
    Build a multi-threaded call tree from profiling data

    Parameters
    ----------
    df : pandas DataFrame
         data frame with profile data

    Returns
    -------
    dictionary containing the call stack and thread names

    """
    out = []

    gb = df.groupby('thread')

    #threadNames = gb.groups.keys()

    tst = gb['time'].min()
    tet = gb['time'].max()

    tst.sort_values(inplace=True)
    threadNames = list(tst.keys())
    tet = np.array(tet[threadNames])
    tst = np.array(tst)

    thread_levels = np.zeros(len(tet), 'i')

    thread_levels[1] = np.logical_and(tet[0] >= tst[1], tst[0] <= tet[1])
    for i in xrange(2, len(tst)):
        lower_levels = thread_levels[:i][np.logical_and(tet[:i] >= tst[i], tst[:i] <= tet[i])]
        if len(lower_levels) == 0:
            thread_levels[i] = 0
        else:
            thread_levels[i] = np.max(thread_levels[:i][np.logical_and(tet[:i] >= tst[i], tst[:i] <= tet[i])]) + 1

    for threadIDX, k in enumerate(threadNames):
        print(k)
        stack = []
        level = 0

        for i, l in gb.get_group(k).iterrows():
            if 'fProfile.py' in l.file:
                pass
            #print l
            elif l.event == 'call':
                level += 1
                stack.append((float(l.time), l.file, l.function))
            elif l.event == 'return':
                try:
                    c = stack.pop()
                    out.append({'ts': c[0],
                                'f': l.file,
                                'n': l.function,
                                'tf': float(l.time),
                                'l': level,
                                'td': threadIDX,
                                'tl' : float(thread_levels[threadIDX]),
                                'ns' : str(getattr(l, 'names', ''))})
                    level -= 1
                except IndexError:
                    pass

    threadLines = [{'ts' : float(tst_i), 'tf' : float(tet_i), 'tl' : float(tl_i)} for tst_i, tet_i, tl_i in zip(tst, tet, thread_levels)]


    return {'callstack': out, 'threadNames': threadNames, 'threadLines' : threadLines, 'maxConcurrentThreads' : int(thread_levels.max() + 1)}


def convert(infile='prof_spool.txt', outfile='prof_spool.json'):
    """
    Convert a profile file as generated by the fProfile module into the json format required by the viewer

    Parameters
    ----------
    infile : string
        the input file name
    outfile : string
        the output file name

    Returns
    -------

    """
    #try:
    df = pd.read_csv(infile, '\t', names=['time', 'thread', 'file', 'function', 'event', 'names'])
    #except:
    #    df = pd.read_csv(infile, '\t', names=['time', 'thread', 'file', 'function', 'event'])

    callstack = build_call_tree_threads(df)

    with open(outfile, 'w') as f:
        f.write(json.dumps(callstack))


if __name__ == '__main__':
    convert(sys.argv[1], sys.argv[2])
