#!/bin/bash
##################################################################
#preprocessing script to be copied over to an extra file and ran separately
##################################################################
name="100x"
path="/group/p00481/7T_rs_fmri_PZ/rs_fc_data/$name"
#change file type to gz
#fslchfiletype NIFTI_GZ $path/rs_fc_data.nii 
#replace 1004 with the participant name
cp /group/p00481/7T_rs_fmri_PZ/scripts/automation_rsfmri/design.fsf $path/tmpdesign.fsf
sed -i -e "s/1004_22765/${name}/g" $path/tmpdesign.fsf
#run feat
feat $path/tmpdesign.fsf
#fnirt doesnt run properly with T1_1mm

#bet the output from feat file
bet $path/rs_preproc.feat/example_func $path/rs_preproc.feat/example_func_brain -m
#run ICA-AROMA
melodic -i $path/rs_preproc.feat/filtered_func_data.nii -m $path/rs_preproc.feat/example_func_brain -o $path/ICA --Ostats

#register data to std space
regpath="/group/p00481/7T_VBM_PZ/T1s/struc"
flirt -ref $regpath/MNI152_T1_1mm_brain -in /group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain -omat $path/str2std.mat
fnirt --in=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_struc --aff=$path/str2std.mat --cout=$path/my_nonlinear_str2std_transf --ref=$regpath/MNI152_T1_1mm --inmask=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain_mask --refmask=$regpath/MNI152_T1_1mm_brain_mask

wait


