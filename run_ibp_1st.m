function run_ibp_1st(sd)
cfg_file = '/mnt/home/jesperdn/China2017/fmri_scripts/config_ibp.m';

[~, s] = fileparts(sd);
fprintf('Processing %s', s)

fs_defaults();
fs_discard_volumes(cfg_file, sd);
fs_preprocess(cfg_file, sd);
fs_wavelet_despike(cfg_file, sd);
fs_glm_1stlevel(cfg_file, sd);

% fs_cleanup(sd); % remove all intermediate files from "Run*"
% fs_cleanup(sd, 'all'); % remove everything from "Run*" except 'bold.nii'