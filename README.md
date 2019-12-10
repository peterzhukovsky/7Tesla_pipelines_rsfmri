# 7Tesla_pipelines_rsfmri
A set of scripts used for preprocessing resting state functional MRI data from a 7Tesla scanner (WBIC, Cambridge)

# Included files:
  1. Scripts that run preprocessing (rs_preprocessing_original.sh) and can automate this process using cluster computing by parallelizing the operation (slurm_rsfc_pz.sh) 
   **!!! All paths need to be adjusted to point to the right files** \
  2. Scripts that finish preprocessing by registering the filtered clean rs data to standard space (1mm MNI152) and allow for ICA-based denoising of manual labels and extracting timeseries from the HCP Glasser et al 2016 parcellation linked below (rs_preprocessing.sh) and can be sped up by using the cluster (slurm_rsfc_pz_for_REGFILT.sh)\
  https://www.nature.com/articles/nature18933 \
  *Note: fslregfilt needs a lot of memory at 1mm resolution hence the extra cluster script*\
  *Note 2: Please check the registration accuracy from structural to MNI standard space: flirt and fnirt may not deal as well with the 7T data as e.g. SPM or Freesurfer *\
  **!!! Also, all paths need to be adjusted to point to the right files**\ 
  3. HCP_left and HCP_right volumetric parcellation from Glasser et al brought into strutural space by Andreas Horn:\
  https://figshare.com/articles/HCP-MMP1_0_projected_on_MNI2009a_GM_volumetric_in_NIfTI_format/3501911
