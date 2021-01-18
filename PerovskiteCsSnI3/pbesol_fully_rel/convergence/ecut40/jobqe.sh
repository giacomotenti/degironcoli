#!/bin/bash
#SBATCH --nodes=2           # number of nodes
#SBATCH --ntasks-per-node=20
#SBATCH --cpus-per-task=2
#SBATCH --time 00:40:00         # format: HH:MM:SS
#SBATCH --account=cmalosso
#SBATCH --mem=60000
#SBATCH --partition=regular2
#SBATCH --job-name=dft 
##SBATCH --mail-user=cmalosso@sissa.it
##SBATCH --mail-type=ALL

source /home/cmalosso/moduli/moduli-qe.sh

NNODES=2
BINDIR=/home/cmalosso/q-e/bin
PW_EXE=$BINDIR/pw.x
NPROCS=$((NNODES*20))

cd $SLURM_SUBMIT_DIR 

export OMP_NUM_THREADS=2
/opt/ohpc/pub/mpi/openmpi3-gnu8/3.1.4/bin/mpirun -np ${NPROCS} ${PW_EXE} < scf.input > scf.output
