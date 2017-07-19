function [phase, magnitude, vdm] = fs_get_fieldmap(subject_dir)

fmri_dir = fs_getd_fmri(subject_dir);

fieldmap_dir = fullfile(fmri_dir, 'FieldMap');

phase = fs_fullpath(fieldmap_dir, 'phase.nii');
magnitude = fs_fullpath(fieldmap_dir, 'mag_*.nii');
vdm = fs_fullpath(fieldmap_dir, 'vdm*run*.nii');