function [analysis_dir, level1_dir] = fs_setup_analysis_dirs(subject_dir)

fmri_dir = fs_getd_fmri(subject_dir);

analysis_dir = fullfile(fmri_dir, 'Analysis');
level1_dir = fullfile(analysis_dir, 'SPM_1st_level');

if ~exist(analysis_dir, 'dir')
    mkdir(analysis_dir)
end
if ~exist(level1_dir, 'dir')
    mkdir(level1_dir)
end