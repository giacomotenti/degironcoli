for k in  2 3 4 5
do
dldir="$k.conv"
i=80
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $k.conv
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
    ibrav =0,
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

 CELL_PARAMETERS {angstrom}
8.733171 0.000000 0.000000
0.000000 8.872210 0.000000
0.000000 0.000000 12.663082


ATOMIC_SPECIES
   Sn 118.7  Sn.rel-pbe-dn-rrkjus_psl.1.0.0.UPF
   I  126.9  I.rel-pbe-n-rrkjus_psl.0.2.2.UPF 
   Cs 132.9  Cs.rel-pbe-spn-rrkjus_psl.1.0.0.UPF

ATOMIC_POSITIONS {crystal}
Cs 0.004683 0.023333 0.750000
Cs 0.504683 0.476667 0.750000
Cs 0.995317 0.976667 0.250000
Cs 0.495317 0.523333 0.250000
Sn 0.500000 0.000000 0.000000
Sn 0.000000 0.500000 0.500000
Sn 0.000000 0.500000 0.000000
Sn 0.500000 0.000000 0.500000
I 0.703098 0.703672 0.992436 
I 0.296902 0.296328 0.492436 
I 0.703098 0.703672 0.507564 
I 0.296902 0.296328 0.007564 
I 0.502648 0.980018 0.250000 
I 0.203098 0.796328 0.507564 
I 0.997352 0.480018 0.750000 
I 0.796902 0.203672 0.492436 
I 0.796902 0.203672 0.007564 
I 0.497352 0.019982 0.750000 
I 0.002648 0.519982 0.250000 
I 0.203098 0.796328 0.992436
 
K_POINTS {automatic}
$k $k $k  1 1 1

EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --time=05:59:59
#SBATCH --partition=regular2
#SBATCH --account=afiorent
##SBATCH --mem=60000
#SBATCH --exclude=cn09-[15-16]
#SBATCH --job-name=perov$k.conv
#SBATCH --mail-user=afiorent@sissa.it
##SBATCH --mail-type=ALL


module purge
module load intel/19.0.4.243 openmpi3/3.1.4 boost/1.71.0  scalapack/2.0.2

NNODES=3
PW_EXE="/home/gtenti/qe-6.6/bin/pw.x"
#PW_EXE=$BINDIR/pw.x
NPROCS=\$((NNODES*32))

cd \${SLURM_SUBMIT_DIR} 
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
