for i in 40
do
dldir="$i.ecut"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.ecut
cat >> vc-relax.in <<EOF
&CONTROL
    title = 'CsSnI3', 
    calculation = 'vc-relax',
    restart_mode = 'from_scratch',
    ndr = 61,
    ndw = 62,
    verbosity = 'medium',
    prefix = 'CsSnI3',
    wf_collect = .true.,
    outdir = './out',
    wfcdir = './out',
    pseudo_dir = '../../pseudo/',
    tprnfor = .true.,
    tstress = .true.,
    max_seconds = 42500,
    forc_conv_thr=1.d-4,
/
 &SYSTEM
    ibrav = 0,
    nat = 20, 
    ntyp = 3,
    ecutwfc= $i,
    ecutrho=$j,

/
 &ELECTRONS
    conv_thr = 1.0d-6,
    diagonalization = 'cg',
    mixing_beta = 0.5,
/
 &IONS
    ion_dynamics = 'bfgs',
/

 &CELL
    cell_dynamics = 'bfgs',
/
 &CELL_PARAMETERS{angstrom}
     4.832290 0.000000 0.000000
     0.000000 10.765026 0.000000
     0.000000 0.000000 18.147277

/

ATOMIC_SPECIES
   Cs 132.9  Cs.pbe-spn-kjpaw_psl.1.0.0.UPF
   Sn 118.7  Sn.pbe-dn-kjpaw_psl.1.0.0.UPF
   I  126.9  I.pbe-n-kjpaw_psl.1.0.0.UPF

ATOMIC_POSITIONS {alat}
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
2 2 2 0 0 0
EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH --mem=180000
#SBATCH --time=11:59:59
#SBATCH --account=Sis20_baroni
#SBATCH --partition=skl_usr_prod
#SBATCH --job-name=CsSnI3$i.ecut
##SBATCH --mail-user=endrigo@sissa.it
#SBATCH --mail-type=ALL

module purge
module load profile/phys
module load autoload qe/6.4
umask -S u=rwx,g=r,o=r

cd \${SLURM_SUBMIT_DIR}
echo \$SLURM_SUBMIT_DIR

# Define number of processors to send to mpirun for MPICH
NNODES=1
PW_EXE="pw.x"




NPROCS=\$((NNODES*48))
echo "\$(date)"
export OMP_NUM_THREADS=1
mpirun -np \${NPROCS} \${PW_EXE} < vc-relax.in > vc-relax.out
echo " Done."

echo "\$(date)"
EOF
cd ../
done
