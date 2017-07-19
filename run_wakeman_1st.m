function run_wakeman_1st(sd)
cfg_file = '/mnt/home/jesperdn/China2017/fmri_scripts/config_wakeman.m';

[~, s] = fileparts(sd);
fprintf('Processing %s\n\n', s)

fs_defaults();
fs_concat_3d(cfg_file, sd);
fs_preprocess(cfg_file, sd);
fs_wavelet_despike(cfg_file, sd);
fs_glm_1stlevel(cfg_file, sd);