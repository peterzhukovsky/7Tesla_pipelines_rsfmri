#!/bin/bash
##################################################################
#preprocessing script to be copied over to an extra file and ran separately
##################################################################
name="100x"

path="/group/p00481/7T_rs_fmri_PZ/rs_fc_data/$name"
regpath="/group/p00481/7T_VBM_PZ/T1s/struc"
#struc to 1mm MNI temp
#flirt -ref $regpath/MNI152_T1_1mm_brain -in /group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain -omat $path/str2std.mat
#fnirt --in=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_struc --aff=$path/str2std.mat --cout=$path/my_nonlinear_str2std_transf --ref=$regpath/MNI152_T1_1mm --inmask=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain_mask --refmask=$regpath/MNI152_T1_1mm_brain_mask

#bet $path/rs_preproc.feat/example_func $path/rs_preproc.feat/example_func_brain -m
#fsl_regfilt -i $path/rs_preproc.feat/filtered_func_data.nii -d $path/ICA/melodic_mix -o $path/ICA/denoised_func_data_nonaggr -m $path/rs_preproc.feat/example_func_brain_mask -f `tail -1 /group/p00481/7T_rs_fmri_PZ/rs_fc_data/ICA_classification_manual/${name}_label.txt` 


#applywarp --ref=$regpath/MNI152_T1_1mm --in=$path/ICA/denoised_func_data_nonaggr --warp=$path/my_nonlinear_str2std_transf --out=$path/ICA/denoised_func_data_instd --premat=$path/rs_preproc.feat/reg/example_func2highres.mat


#fslmeants extract timeseries from each parcel and store them in one text file for each person: glasser left, glasser right, striatum left striatum right
mkdir $path/ts_HCP_left
mkdir $path/ts_HCP_right
mkdir $path/ts_STR

for i in `seq 1 180`; do
fslmeants -i $path/ICA/denoised_func_data_instd -o $path/ts_HCP_left/${i}.txt -m /group/p00481/7T_rs_fmri_PZ/scripts/automation_rsfmri/HCP_left/ROI_${i}
fslmeants -i $path/ICA/denoised_func_data_instd -o $path/ts_HCP_right/${i}.txt -m /group/p00481/7T_rs_fmri_PZ/scripts/automation_rsfmri/HCP_right/ROI_${i}
done

for i in `seq 1 10`; do
fslmeants -i $path/ICA/denoised_func_data_instd -o $path/ts_STR/${i}.txt -m /group/p00481/7T_rs_fmri_PZ/scripts/automation_rsfmri/STR/${i}
done
#motion fsl mean fd after ICA to check for motion issues 
fsl_motion_outliers -i $path/ICA/denoised_func_data_nonaggr -o $path/motion_outliers.txt -s $path/mean_fd.txt --fd -m $path/rs_preproc.feat/example_func_brain_mask

wait


