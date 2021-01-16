for i in  40 50 60 70 80 90 100
do
dldir="$i.ecut"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.ecut
cat >> scf.in <<EOF
&CONTROL
    title = 'SnI4un', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'SnI4un',
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
    nat = 5, 
    ntyp = 2,
    ecutwfc= $i,
    ecutrho=$j,
    nbnd=23,

/
 &ELECTRONS
/
 CELL_PARAMETERS {angstrom}
6.686428 0.000000 0.000000
0.000000 6.686428 0.000000
0.000000 0.000000 6.686428

 ATOMIC_SPECIES
   Sn 118.7  Sn.pbe-dn-kjpaw_psl.1.0.0.UPF
   I  126.9  I.pbe-n-kjpaw_psl.1.0.0.UPF

 ATOMIC_POSITIONS {crystal}
Sn 0.000000 0.000000 0.000000 
I 0.233903 0.766097 0.766097 
I 0.766097 0.233903 0.766097 
I 0.766097 0.766097 0.233903 
I 0.233903 0.233903 0.233903 

K_POINTS {automatic}
2 2 2 0 0 0
EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
##SBATCH --mem=180000
#SBATCH --time=11:59:59
#SBATCH --partition=regular2
#SBATCH --job-name=SnI4un$i.ecut
#SBATCH --mail-type=ALL

#umask -S u=rwx,g=r,o=r
module purge
module load gnu8
module load mkl
module load openmpi3
cd \${SLURM_SUBMIT_DIR}
echo \$SLURM_SUBMIT_DIR

# Define number of processors to send to mpirun for MPICH
NNODES=2
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
