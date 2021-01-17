for i in  3 4 5 6 7 8 9
do
dldir="$i.kappa"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.kappa
cat >> scf.in <<EOF
&CONTROL
    title = 'SnI2tetr', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'SnI2tetr',
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
    nat = 6, 
    ntyp = 2,
    ecutwfc= 70,
    ecutrho=280,

/
 &ELECTRONS
/
 CELL_PARAMETERS {angstrom}
7.630706 0.000000 0.000000
0.000000 7.630706 0.000000
0.000000 0.000000 4.695760


 ATOMIC_SPECIES
   Sn 118.7  Sn.pbe-dn-kjpaw_psl.1.0.0.UPF
   I  126.9  I.pbe-n-kjpaw_psl.1.0.0.UPF

 ATOMIC_POSITIONS {crystal}
Sn 0.000000 0.000000 0.000000 
Sn 0.500000 0.500000 0.500000 
I 0.298521 0.298521 0.000000 
I 0.701479 0.701479 0.000000 
I 0.798521 0.201479 0.500000 
I 0.201479 0.798521 0.500000 

K_POINTS {automatic}
$i $i $i 0 0 0
EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
##SBATCH --mem=180000
#SBATCH --time=11:59:59
#SBATCH --partition=regular2
#SBATCH --job-name=SnI2t$i.kappa
#SBATCH --mail-user=drigo96@live.it
#SBATCH --mail-type=ALL

#umask -S u=rwx,g=r,o=r
module purge
module load gnu8
module load mkl
module load openmpi3
cd \${SLURM_SUBMIT_DIR}
echo \$SLURM_SUBMIT_DIR

# Define number of processors to send to mpirun for MPICH
NNODES=1
PW_EXE="/home/endrigo/q-e/bin/pw.x"




NPROCS=\$((NNODES*32))
echo "\$(date)"
export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < scf.in > scf.out
echo " Done."

echo "\$(date)"

EOF
cd ../
done
