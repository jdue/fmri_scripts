function fmri_t1 = fs_get_t1(subject_dir)

smri_dir = fs_getd_smri(subject_dir);
fmri_dir = fs_getd_fmri(subject_dir);

smri_t1 = fullfile(smri_dir, 'T1.nii');
fmri_dir_t1 = fullfile(fmri_dir, 't1');
fmri_t1 = fullfile(fmri_dir_t1, 'T1.nii');
if ~exist(fmri_dir_t1, 'dir')
    mkdir(fmri_dir_t1)
end
copyfile(smri_t1, fmri_t1);

