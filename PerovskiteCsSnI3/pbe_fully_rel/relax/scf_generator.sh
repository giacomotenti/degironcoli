ephi=60
erho=$((ephi*4))
for i in   2 3 4 5
do
dldir="$i.kconv"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $dldir
cat >> scf.in <<EOF
&CONTROL
    title = 'perovskite', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'CsIhex',
    wf_collect = .true.,
    outdir = './out',
    wfcdir = './out',
    pseudo_dir = '../../../../pseudo/',
    max_seconds = 42500,
/



 &SYSTEM
    ibrav = 8,
    A = 4.832290, 
    B = 10.765026, 
    C = 18.147277,
    nat = 20, 
    ntyp = 3,
    ecutwfc= $ephi,
    ecutrho= $erho,
    noncolin=.true.,
    lspinorb=.true.,
    nbnd=180,
/
 &ELECTRONS
    conv_thr = 1.0d-6,
    diagonalization = 'david',
    mixing_beta = 0.6,
/

ATOMIC_SPECIES
   Sn 118.7  Sn.rel-pbe-dn-kjpaw_psl.1.0.0.UPF
   I  126.9  I.rel-pbe-n-kjpaw_psl.1.0.0.UPF
   Cs 132.9  Cs.rel-pbe-spn-kjpaw_psl.1.0.0.UPF
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
$i $i $i 1 1 1

EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --time=11:59:59
#SBATCH --partition=regular2
#SBATCH --exclude=cn09-[15-16] 
#SBATCH --job-name=perov$i.kconv
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



NPROCS=\$((NNODES*32))
echo "\$(date)"
export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < scf.in > scf.out
echo " Done."

echo "\$(date)"
EOF
cd ../
done
