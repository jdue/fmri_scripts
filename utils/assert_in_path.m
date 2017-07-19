function assert_in_path()
% Check that the required functions are in the path.
% 
% 
% 

% Utilities
assert(exist('cat_paths','file')==2,           '"cat_paths" not in path')
assert(exist('to_cell','file')==2,             '"to_cell" not in path')
assert(exist('get_epi','file')==2,             '"get_epi" not in path')
assert(exist('get_fieldmaps','file')==2,       '"get_fieldmaps" not in path')
assert(exist('get_run_dirs','file')==2,        '"get_run_dirs" not in path')
assert(exist('get_t1','file')==2,              '"get_t1" not in path')
assert(exist('initialize_spm','file')==2,      '"initialize_spm" not in path')
assert(exist('setup_analysis_dirs','file')==2, '"setup_analysis_dirs" not in path')



assert(exist('wm_get_contrast_images','file')==2, '"wm_get_contrast_images" not in path')

assert(exist('fmri_get_trial_defs','file')==2, '"fmri_get_trial_defs" not in path')
assert(exist('fmri_rp_24expansion','file')==2, '"fmri_rp_24expansion" not in path')

assert(exist('fmri_concat_3d','file')==2, '"fmri_concat_3d" not in path')

assert(exist('fmri_preprocess','file')==2,      '"fmri_preprocess" not in path')
assert(exist('fmri_wavelet_despike','file')==2, '"fmri_wavelet_despike" not in path')



assert(exist('wm_fmri_glm_1stlevel','file')==2, '"wm_fmri_glm_1stlevel" not in path')
assert(exist('wm_fmri_glm_2ndlevel','file')==2, '"wm_fmri_glm_2ndlevel" not in path')

assert(exist('wm_fmri_master_group','file')==2, '"wm_fmri_master_group" not in path')
assert(exist('wm_fmri_master_subject','file')==2, '"wm_fmri_master_subject" not in path')


% 3rd party
assert(exist('WaveletDespike','file')==2, '"WaveletDespike" not in path')


