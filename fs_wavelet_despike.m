function fs_wavelet_despike(cfg, subject_dir)
% 
% To use this function:
% 
% (1) cd to the BrainWavelet folder and run setup.m from the command window
%     (MEX compiler required)
% (2) run WaveletDespike as
%     'WaveletDespike('\path\to\4D_file.nii(.gz)','prefix');
%     which then creates
%     - prefix_wds.nii.gz    - the wavelet despiked time series
%     - prefix_noise.nii.gz  - the noise time seies removed during despike
%     - prefix_SP.txt        - the spike percentage time series

cfg = fs_get_config(cfg, 'wavelet');

try limitRAM = cfg.limitRAM; catch; limitRAM = 10; end

owd = pwd;

rd = fs_getd_runs(subject_dir);

for i = 1:length(rd)
    % WaveletDespike writes to the current working directory so change it
    cd(rd{i});

    bold = dir('sw*.nii');
    bold = bold.name;
    [~, name, ext] = fileparts(bold);
    name = strcat('d', name);
    WaveletDespike(bold, name, 'LimitRAM', limitRAM);
    WaveletDespike(bold, name, 'LimitRAM', limitRAM, 'threshold', 25);
    %WaveletDespike(bold, name, 'LimitRAM', limitRAM, 'threshold', 15, 'chsearch','conservative');
    % Outputs
    wds = [name '_wds.nii.gz' ];    % despiked time series
    %noise = [name '_noise.nii.gz']; % noise components removed
    %sp = [name '_SP.txt' ];         % spike percentage (per frame)
    
    % Unzip
    gunzip(wds);
    delete(wds);
    
    % Remove '_wds' which is added by WaveletDespike
    movefile(wds(1:end-3), [name ext]);
end
cd(owd);