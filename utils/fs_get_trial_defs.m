function trial_defs = fs_get_trial_defs(subject_dir)

fmri_dir = fs_getd_fmri(subject_dir);

trial_defs_dir = fullfile(fmri_dir, 'trial_definitions');
trial_defs = fs_fullpath(trial_defs_dir, 'run*.mat');
