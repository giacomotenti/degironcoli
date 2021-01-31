for i in 20 30 40 50 60 70 80 
do
dldir="$i.ecut"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.ecut
cat >> scf.in <<EOF
&CONTROL
    title = 'CsIsalt', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'CsIsalt',
    wf_collect = .true.,
    outdir = './out',
    wfcdir = './out',
    pseudo_dir = '/scratch/afiorent/degironcoli/pseudo/pseudo-usp',
    tprnfor = .true.,
    tstress = .true.,
    forc_conv_thr=1.d-4,
    max_seconds = 42500,
/



 &SYSTEM
    ibrav = 1,
    A = 4.665212, 
    nat = 2, 
    ntyp = 2,
    ecutwfc= $i,
    ecutrho= $j,
    noncolin=.true.,
    lspinorb=.true.,
/
 &ELECTRONS
    conv_thr = 1.0d-6,
    diagonalization = 'david',
    mixing_beta = 0.6,
/

ATOMIC_SPECIES
   I  126.9  I.rel-pbe-n-rrkjus_psl.0.2.2.UPF 
   Cs 132.9  Cs.rel-pbe-spn-rrkjus_psl.1.0.0.UPF
ATOMIC_POSITIONS {crystal}
Cs 0.000000 0.000000 0.000000 
I 0.500000 0.500000 0.500000 

K_POINTS {automatic}
4 4 4 1 1 1

EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --time=00:59:59
#SBATCH --partition=regular2
#SBATCH --exclude=cn09-[19,34]
#SBATCH --job-name=CsI$i.ecut
#SBATCH --mail-user=afiorent@sissa.it
##SBATCH --mail-type=ALL


module purge
module load intel/19.0.4.243 openmpi3/3.1.4 boost/1.71.0  scalapack/2.0.2

NNODES=1
PW_EXE="/home/gtenti/qe-6.6/bin/pw.x"
#PW_EXE=$BINDIR/pw.x
NPROCS=\$((NNODES*32))

cd \${SLURM_SUBMIT_DIR} 
echo \$SLURM_SUBMIT_DIR

export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < scf.in > scf.out
echo " Done."

echo "\$(date)"
EOF
cd ../
done
