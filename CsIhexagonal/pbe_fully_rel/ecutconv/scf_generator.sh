for i in 40 50 60 70 80 90 100
do
dldir="$i.ecut"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.ecut
cat >> scf.in <<EOF
&CONTROL
    title = 'CsIhexagonal', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'CsIhex',
    wf_collect = .true.,
    outdir = './out',
    wfcdir = './out',
    pseudo_dir = '../../../pseudo/',
    max_seconds = 42500,
/
 &SYSTEM
    ibrav = 0,
    nat = 8, 
    ntyp = 2,
    noncolin=.true.,
    lspinorb=.true.,
    ecutwfc= $i,
    ecutrho=$j,
    nbnd=65,

/
 &ELECTRONS
    conv_thr = 1.0d-6,
    diagonalization = 'david',
    mixing_beta = 0.6,
/
 &IONS
/

 &CELL
/
 CELL_PARAMETERS {angstrom}
7.859178 0.000000 0.000000
0.000000 7.859178 0.000000
0.000000 0.000000 7.859178

 ATOMIC_SPECIES
   I  126.9  I.rel-pbe-n-kjpaw_psl.1.0.0.UPF
   Cs 132.9  Cs.rel-pbe-spn-kjpaw_psl.1.0.0.UPF
 ATOMIC_POSITIONS {crystal}
Cs 0.000000 0.000000 0.000000 
Cs 0.000000 0.500000 0.500000 
Cs 0.500000 0.000000 0.500000 
Cs 0.500000 0.500000 0.000000 
I 0.500000 0.000000 0.000000 
I 0.500000 0.500000 0.500000 
I 0.000000 0.000000 0.500000 
I 0.000000 0.500000 0.000000 

K_POINTS {automatic}
2 2 2 0 0 0
EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=19
#SBATCH --cpus-per-task=1
#SBATCH --time=11:59:59
#SBATCH --partition=regular2
#SBATCH --job-name=CsIhex$i.ecut
#SBATCH --mail-user=afiorent@sissa.it
#SBATCH --mail-type=ALL

module purge
module load gnu8
module load mkl
module load openmpi3

cd \${SLURM_SUBMIT_DIR}
echo \$SLURM_SUBMIT_DIR

# Define number of processors to send to mpirun for MPICH
NNODES=2

PW_EXE="/home/afiorent/qe-6.5/bin/pw.x"



NPROCS=\$((NNODES*19))
echo "\$(date)"
export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < scf.in > scf.out
echo " Done."

echo "\$(date)"
EOF
cd ../
done
