for i in 3 4 5 6 7 8 9 
do
dldir="$i.kappa"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.kappa
cat >> scf.in <<EOF
&CONTROL
    title = 'CsIrsalt', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'CsIrs',
    wf_collect = .true.,
    outdir = './out',
    wfcdir = './out',
    pseudo_dir = '../../../pseudo/',
    tprnfor = .true.,
    tstress = .true.,
    max_seconds = 42500,
    etot_conv_thr=1.d-7,
/
 &SYSTEM
    ibrav = 0,
    nat = 2, 
    ntyp = 2,
    ecutwfc=60,
    ecutrho=240,
    nbnd=9,

/
 &ELECTRONS
/
 CELL_PARAMETERS {angstrom}
4.665212 0.000000 0.000000
0.000000 4.665212 0.000000
0.000000 0.000000 4.665212


 ATOMIC_SPECIES
   Cs 132.9  Cs.pbe-spn-kjpaw_psl.1.0.0.UPF
   I  126.9  I.pbe-n-kjpaw_psl.1.0.0.UPF

 ATOMIC_POSITIONS {crystal}
Cs 0.000000 0.000000 0.000000 
I 0.500000 0.500000 0.500000 

K_POINTS {automatic}
$i $i $i 0 0 0
EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=19
#SBATCH --cpus-per-task=1
#SBATCH --time=11:59:59
#SBATCH --partition=regular2
#SBATCH --job-name=CsIrs$i.kappa
#SBATCH --mail-user=drigo96@live.it
#SBATCH --mail-type=ALL

module purge
module load gnu8
module load mkl
module load openmpi3

cd \${SLURM_SUBMIT_DIR}
echo \$SLURM_SUBMIT_DIR

# Define number of processors to send to mpirun for MPICH
NNODES=1
PW_EXE="/home/endrigo/q-e/bin/pw.x"




NPROCS=\$((NNODES*19))
echo "\$(date)"
export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < scf.in > scf.out
echo " Done."

echo "\$(date)"
EOF
cd ../
done
