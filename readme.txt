Scripts and options.




The functions requires the following folder structure (e.g., with two runs):

    sub001/
      fMRI/
          FieldMap/ (optional)
              mag_1.nii
              mag_2.nii
              phase.nii
        
          Run_01/
              bold.nii
          Run_02/
              bold.nii
      
          TrialDefinition/
              Run_01*.mat
              Run_02*.mat

      sMRI/
          T1.nii
          T2.nii (optional)
      ...
    sub002/
      ...





fs_preprocess
=============
Preprocessing script.

* Modify options for preprocessing here.

fs_glm_1stlevel
===============
Script for subject level GLM statistics.

* Modify options for regressors and contrasts here.

fs_glm_2ndlevel
===============
Script for group level GLM statistics.

fs_master_subject
=================
Script for running subject level preprocessing and analysis.

* Modify options for volume concatenation and removal of initial volumes.

fs_master_group
=================
Script for computing several group level contrasts. Uses fs_glm_2ndlevel.

* Modify options for which 1st level contrasts to use and where to write results.