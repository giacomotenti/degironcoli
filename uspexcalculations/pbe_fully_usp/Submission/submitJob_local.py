from __future__ import with_statement
from __future__ import absolute_import
from subprocess import check_output
import re
import sys
from io import open



def submitJob_local(index, commnadExecutable):
    """
    This routine is to submit job locally
    One needs to do a little edit based on your own case.

    Step 1: to prepare the job script which is required by your supercomputer
    Step 2: to submit the job with the command like qsub, bsub, llsubmit, .etc.
    Step 3: to get the jobID from the screen message
    :return: job ID
    """

    RUN_FILENAME = 'myrun'
    JOB_NAME = 'USPEX-{}'.format(index)

    # Step 1
    myrun_content = '''#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
##SBATCH --mem=180000
#SBATCH --time=11:59:59
#SBATCH --account=Sis20_baroni
#SBATCH --partition=skl_usr_prod
#SBATCH --job-name={}
#SBATCH --mail-user=afiorent@sissa.it
#SBATCH --mail-type=ALL

#umask -S u=rwx,g=r,o=r
module purge
module load profile/phys
module load autoload qe/6.7
env

{}
'''.format(JOB_NAME, commnadExecutable)


    with open(RUN_FILENAME, 'w') as fp:
        fp.write(myrun_content)

    # Step 2
    # It will output some message on the screen like '2350873.nano.cfn.bnl.local'
    output = check_output('sbatch {}'.format(RUN_FILENAME), shell=True, universal_newlines=True)


    # Step 3
    # Here we parse job ID from the output of previous command
    jobNumber = int(output.split(' ')[3])
    print(str(jobNumber))
    return jobNumber


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', dest='index', type=int)
    parser.add_argument('-c', dest='commnadExecutable', type=str)
    args = parser.parse_args()

    jobNumber = submitJob_local(index=args.index, commnadExecutable=args.commnadExecutable)
    print('<CALLRESULT>')
    print(int(jobNumber))
