function rd = fs_getd_runs(subject_dir)
% Return directories with fMRI runs

fmri_dir = fs_getd_fmri(subject_dir);
rd = fs_fullpath(fmri_dir, 'Run*');