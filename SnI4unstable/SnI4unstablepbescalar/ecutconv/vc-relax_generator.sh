for i in  40 50 60 70 80 90 100
do
dldir="$i.ecut"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.ecut
cat >> vc-relax.in <<EOF
&CONTROL
    title = 'SnI4un', 
    calculation = 'vc-relax',
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
    forc_conv_thr=1.d-4,
/
 &SYSTEM
    ibrav = 0,
    nat = 5, 
    ntyp = 2,
    ecutwfc= $i,
    ecutrho=$j,

/
 &ELECTRONS
    conv_thr = 1.0d-6,
    diagonalization = 'david',
    mixing_beta = 0.5,
/
 &IONS
    ion_dynamics = 'bfgs',
/

 &CELL
    cell_dynamics = 'bfgs',
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
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=19
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
NNODES=1
PW_EXE="/home/endrigo/q-e/bin/pw.x"




NPROCS=\$((NNODES*19))
echo "\$(date)"
export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < vc-relax.in > vc-relax.out
echo " Done."

echo "\$(date)"

EOF
cd ../
done
