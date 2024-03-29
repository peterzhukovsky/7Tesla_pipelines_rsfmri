#!/bin/bash
#!
#! Example SLURM job script for HPHI
#! Last updated: Mon Oct 31 11:30:00 BST 2016
#!

# RUN THIS WITH sbatch <filename>

#!#############################################################
#!#### Modify the options in this section as appropriate ######
#!#############################################################

#! sbatch directives begin here ###############################
#! Name of the job:
#SBATCH -J pz_rsfc

#! Which project should jobs run under:
#SBATCH -A hphi

#! What QoS should the job run in?
#SBATCH --qos=long.q

#! How much resource should be allocated?
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16000



#! How much wall-clock time will be required?
#SBATCH --time=3-00:00:00


#! What e-mail address to use for notifications?
#! Insert your mail address here for job notifications
#! Remove the ! to uncomment
#SBATCH --mail-user=pz249@cam.ac.uk

#! What types of email messages do you wish to receive?
#! Remove the ! to uncomment
#SBATCH --mail-type=ALL

#! Uncomment this to prevent the job from being requeued (e.g. if
#! interrupted by node failure or system downtime):
#! SBATCH --no-requeue

#! Partition: Don't need to change, unless running on the GPU node:
#SBATCH -p wbic-cs

#! sbatch directives end here (put any additional directives above this line)

#! ############################################################
#! Modify the settings below to specify the application's environment, location
#! and launch method:

#! Optionally modify the environment seen by the application
#! (note that SLURM reproduces the environment at submission irrespective of ~/.bashrc):
. /etc/profile.d/modules.sh                # Leave this line (enables the module command)
module purge                               # Removes all modules still loaded
module load default-wbic                   # REQUIRED - loads the basic environment

#! Insert additional module load commands after this line if needed:

#! Full path to your application executable:
application="hostname"

#! Run options for the application:
options=""

#! Work directory (i.e. where the job will run):
workdir="$SLURM_SUBMIT_DIR"  # The value of SLURM_SUBMIT_DIR sets workdir to the directory
                             # in which sbatch is run.

#! Are you using OpenMP (NB this is **unrelated to OpenMPI**)? If so increase this
#! safe value to no more than 24:
export OMP_NUM_THREADS=24

# Command line to be submited by SLURM:
CMD="/group/p00481/7T_rs_fmri_PZ/rs_fc_data/100x/rs_preprocessing.sh"

###############################################################
### You should not have to change anything below this line ####
###############################################################

cd $workdir
echo -e "Changed directory to `pwd`.\n"

JOBID=$SLURM_JOB_ID

echo -e "JobID: $JOBID\n======"
echo "Time: `date`"
echo "Running on master node: `hostname`"
echo "Current directory: `pwd`"

if [ "$SLURM_JOB_NODELIST" ]; then
        #! Create a machine file:
	export NODEFILE=`generate_pbs_nodefile`
        cat $NODEFILE | uniq > machine.file.$JOBID
        echo -e "\nNodes allocated:\n================"
        echo `cat machine.file.$JOBID | sed -e 's/\..*$//g'`
fi

echo -e "\nExecuting command:\n==================\n$CMD\n"

eval $CMD
