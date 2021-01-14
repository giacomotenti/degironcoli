#!/bin/bash
#SBATCH --nodes=2            # number of nodes
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --time 00:20:00         # format: HH:MM:SS
#SBATCH --account=gtenti
#SBATCH --mem=60000
#SBATCH --partition=regular2
#SBATCH --job-name=dft 
##SBATCH --mail-user=gtenti@sissa.it
##SBATCH --mail-type=ALL

module purge
module load intel/19.0.4.243 openmpi3/3.1.4 boost/1.71.0  scalapack/2.0.2

NNODES=2
BINDIR=/home/gtenti/qe-6.6/bin
PW_EXE=$BINDIR/pw.x
NPROCS=$((NNODES*32))

cd $SLURM_SUBMIT_DIR 

export OMP_NUM_THREADS=1
mpirun -np ${NPROCS} ${PW_EXE} < scf.input > scf.output
