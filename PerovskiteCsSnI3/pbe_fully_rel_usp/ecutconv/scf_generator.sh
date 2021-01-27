for i in  50 60 70 80 90 100
do
dldir="$i.ecut"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.ecut
cat >> scf.in <<EOF
&CONTROL
    title = 'perovskite', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'CsSnI3',
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
    ibrav = 8,
    A = 4.832290, 
    B = 10.765026, 
    C = 18.147277,
    nat = 20, 
    ntyp = 3,
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
   Sn 118.7  Sn.rel-pbe-dn-rrkjus_psl.1.0.0.UPF
   I  126.9  I.rel-pbe-n-rrkjus_psl.0.2.2.UPF 
   Cs 132.9  Cs.rel-pbe-spn-rrkjus_psl.1.0.0.UPF
ATOMIC_POSITIONS {crystal}
Cs 0.250000 0.083477 0.670182
Cs 0.750000 0.916523 0.329818 
Cs 0.250000 0.583477 0.829818
Cs 0.750000 0.416523 0.170182
Sn 0.250000 0.341860 0.438978
Sn 0.750000 0.658140 0.561022
Sn 0.250000 0.841860 0.061022
Sn 0.750000 0.158140 0.938978 
I 0.750000 0.026100 0.111907 
I 0.250000 0.973900 0.888093 
I 0.750000 0.526100 0.388093 
I 0.250000 0.473900 0.611907 
I 0.750000 0.293174 0.791874 
I 0.250000 0.706826 0.208126 
I 0.750000 0.793174 0.708126 
I 0.250000 0.206826 0.291874 
I 0.750000 0.168496 0.498874 
I 0.250000 0.831504 0.501126 
I 0.750000 0.668496 0.001126 
I 0.250000 0.331504 0.998874 

K_POINTS {automatic}
4 4 4 1 1 1

EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --time=05:59:59
#SBATCH --partition=regular2
#SBATCH --exclude=cn09-[15-16]
#SBATCH --job-name=perov$i.ecut
#SBATCH --mail-user=afiorent@sissa.it
##SBATCH --mail-type=ALL


module purge
module load intel/19.0.4.243 openmpi3/3.1.4 boost/1.71.0  scalapack/2.0.2

NNODES=2
PW_EXE="/home/gtenti/qe-6.6/bin/pw.x"
#PW_EXE=$BINDIR/pw.x
NPROCS=\$((NNODES*32))

cd \{$SLURM_SUBMIT_DIR} 
echo \$SLURM_SUBMIT_DIR

export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < scf.in > scf.out
#module purge
#module load gnu8
#module load mkl
#module load openmpi3
#
#cd \${SLURM_SUBMIT_DIR}
#echo \$SLURM_SUBMIT_DIR
#
## Define number of processors to send to mpirun for MPICH
#NNODES=2
#
#PW_EXE="/home/afiorent/qe-6.5/bin/pw.x"
#
#
#
#NPROCS=\$((NNODES*32))
#echo "\$(date)"
#export OMP_NUM_THREADS=1
#mpirun -np \${NPROCS} \${PW_EXE} < scf.in > scf.out
echo " Done."

echo "\$(date)"
EOF
cd ../
done
