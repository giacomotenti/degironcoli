for i in  40 50 60 70 80 90 100
do
dldir="$i.ecut"
j=$((i*4))
[ ! -d "$dldir" ] && mkdir -p "$dldir"
cd $i.ecut
cat >> scf.in <<EOF
&CONTROL
    title = 'CsSnI3', 
    calculation = 'scf',
    restart_mode = 'from_scratch',
    verbosity = 'medium',
    prefix = 'CsSnI3',
    wf_collect = .true.,
    outdir = './out',
    wfcdir = './out',
    pseudo_dir = '/home/endrigo/hands-on/degir/pseudo/pseudo-usp/',
    tprnfor = .true.,
    tstress = .true.,
    max_seconds = 42500,
    etot_conv_thr=1.d-7,
/
 &SYSTEM
    ibrav = 0,
    nat = 20, 
    ntyp = 3,
    ecutwfc= $i,
    ecutrho=$j,
    nbnd=89

/
 &ELECTRONS
/
 CELL_PARAMETERS {angstrom}
8.733171 0.000000 0.000000
0.000000 8.872210 0.000000
0.000000 0.000000 12.663082

 ATOMIC_SPECIES
   Sn 118.7  Sn.pbe-dn-rrkjus_psl.1.0.0.UPF
   I  126.9  I.pbe-n-rrkjus_psl.1.0.0.UPF
   Cs 132.9  Cs.pbe-spn-rrkjus_psl.1.0.0.UPF

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
2 2 2 0 0 0
EOF
cat >>submit.job <<EOF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
##SBATCH --mem=180000
#SBATCH --time=11:59:59
#SBATCH --partition=regular2
#SBATCH --job-name=CsSnI3$i.ecut
#SBATCH --mail-user=drigo96@live.it
#SBATCH --mail-type=ALL

#umask -S u=rwx,g=r,o=r
module purge
module load intel/19.0.4.243 openmpi3/3.1.4 boost/1.71.0  scalapack/2.0.2


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
