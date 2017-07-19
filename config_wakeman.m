% CONFIGURATION FILE
% 

% CONCATENATE
% =========================================================================
cfg.concat.filter = '^fMR';

% WAVELET DESPIKE
% =========================================================================
cfg.wavelet.limitRAM = 20;

% PREPROCESSING
% =========================================================================

TR = 2;

so = [1:2:33 2:2:33];

cfg.preproc.st.tr = TR;               % repetition time

if all(so==round(so)) %|| any(so>250)
    % Slice order given as slice timings
    % Note that the reference slice is specified as the timing of the
    % reference slice - not the index in the slice order vector
    sso = sort(so);
    cfg.preproc.st.so = so;
    cfg.preproc.st.ref = sso(round(length(so)/2));
else
    % Slice order given as slice indices
    % Note that the reference slice is specified as the slice NUMBER - not
    % the index in the slice order vector
    cfg.preproc.st.so = so;
    cfg.preproc.st.ref = so(round(length(so)/2));
end
cfg.preproc.st.nslices = length(cfg.preproc.st.so); % no. of slices
cfg.preproc.st.ta = cfg.preproc.st.tr-(cfg.preproc.st.tr/cfg.preproc.st.nslices); % acquisition time, usually TR-(TR/nslices)
clear so sso

% SEGMENTATION
cfg.preproc.segment.reg = 'mni'; % regularization of affine warp in segmentation
                         %  - 'mni'     = european brains
                         %  - 'eastern' = east asian brains

% NORMALIZATION
% Voxel size of normalized volumes.
cfg.preproc.normalize.vox_epi = [3 3 3];
cfg.preproc.normalize.vox_t1  = [2 2 2];

% SMOOTHING
cfg.preproc.smooth.fwhm = [6 6 6]; % smoothing kernel in mm


% FIRST LEVEL GLM
% =========================================================================

% Design parameters
HP_cutoff = 128;
design_units = 'secs';

cfg.glm1.fmri_spec.units     = design_units; 
cfg.glm1.fmri_spec.tr        = TR;
cfg.glm1.fmri_spec.hp_filter = HP_cutoff;
cfg.glm1.fmri_spec.t         = cfg.preproc.st.nslices;
cfg.glm1.fmri_spec.t0        = ceil(cfg.glm1.fmri_spec.t/2);

% Contrasts
cfg.glm1.con = struct();
cfg.glm1.con(1).name    = 'Effects of Interest';
cfg.glm1.con(1).weights = [1 0 0; 0 1 0; 0 0 1];
cfg.glm1.con(2).name    = 'Familiar Faces';
cfg.glm1.con(2).weights = [1 0 0];      
cfg.glm1.con(3).name    = 'Unfamiliar Faces';
cfg.glm1.con(3).weights = [0 1 0];  
cfg.glm1.con(4).name    = 'Scrambled Faces';
cfg.glm1.con(4).weights = [0 0 1];  
cfg.glm1.con(5).name    = 'Faces > Scrambled';
cfg.glm1.con(5).weights = [0.5 0.5 -1];
cfg.glm1.con(6).name    = 'Familiar > Unfamiliar';
cfg.glm1.con(6).weights = [1 -1 0];

% SECOND LEVEL GLM
% =========================================================================
cfg.glm2.con(1).name = cfg.glm1.con(5).name;
cfg.glm2.con(1).outdir = 'faces-scrambled';
cfg.glm2.con(2).name = cfg.glm1.con(6).name;
cfg.glm2.con(2).outdir = 'familiar-unfamiliar';