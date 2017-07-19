% CONFIGURATION FILE EXAMPLE
% 
% 


% CONCAT 3D TO 4D
% =========================================================================
% Concatenate 3D volumes to 4D volume.

cfg.concat.filter = '^fMR'; % The pattern of the 3D files

% DISCARD INITIAL VOLUMES
% =========================================================================
% Discard initial n volumes but ensure that at least Nmin volumes are kept.

cfg.discard.n    = 3;   % Number of initial volumes to discard
cfg.discard.Nmin = 322; % Ensure that at least this many volumes are kept


% Wavelet Despike
% =========================================================================

cfg.wavelet.limitRAM = 10; % Limit RAM usage of WaveletDespike (in GB)


% PREPROCESSING OPTIONS
% =========================================================================
% Various common preprocessing options.

TR = 1.368; % Repetition time

% SLICE TIMING
so = [];    % slice order/timings specified in ms or as indices
% Example
% so = [0.0, 712.49999999, 79.99999999, 792.49999998, ...
%       157.5, 872.5, 237.49999999, 952.49999998, ...
%       317.49999998, 1030.0, 397.49999999, 1109.99999999, ...
%       474.99999998, 1190.0, 554.99999999, 1267.49999999, ...
%       634.99999998, 0.0, 712.49999999, 79.99999999, ...
%       792.49999998, 157.5, 872.5, 237.49999999, ...
%       952.49999998, 317.49999998, 1030.0, 397.49999999, ...
%       1109.99999999, 474.99999998, 1190.0, 554.99999999, ...
%       1267.49999999, 634.99999998, 0.0, 712.49999999, ...
%       79.99999999, 792.49999998, 157.5, 872.5, ...
%       237.49999999, 952.49999998, 317.49999998, 1030.0, ...
%       397.49999999, 1109.99999999, 474.99999998, 1190.0, ...
%       554.99999999, 1267.49999999, 634.99999998, 0.0, ...
%       712.49999999, 79.99999999, 792.49999998, 157.5, ...
%       872.5, 237.49999999, 952.49999998, 317.49999998, ...
%       1030.0, 397.49999999, 1109.99999999, 474.99999998, ...
%       1190.0, 554.99999999, 1267.49999999, 634.99999998];
% so = [1:2:33 2:2:33]; % slice order as indices

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

% FIELD MAP
cfg.preproc.vdm.te_short = 4.92;
cfg.preproc.vdm.te_long  = 7.38;
cfg.preproc.vdm.BPPPE    = 15.466;
cfg.preproc.vdm.blip_dir = -1;


% FIRST LEVEL GLM
% =========================================================================

HP_cutoff = 128; % in seconds
design_units = 'secs'; % units for design (e.g., onsets, durations) in trial definition files


% Microtime resolution (fmri_spec.t) is the number of time bins per scan
% for each regressor. Match to number of slices.
% Microtime onset (fmri_spec.t0) is the reference bin for the regressors.
% If slice timing correction has been performed, specify the slice to which
% the data was resampled.
cfg.glm1.fmri_spec.units     = design_units; 
cfg.glm1.fmri_spec.tr        = TR;
cfg.glm1.fmri_spec.hp_filter = HP_cutoff;
cfg.glm1.fmri_spec.t         = cfg.preproc.st.nslices;
cfg.glm1.fmri_spec.t0        = ceil(cfg.glm1.fmri_spec.t/2);

% Contrasts
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

% SECOND LEVEL CONTRASTS
% ========================
cfg.glm2.con(1).name = cfg.glm1.con(5).name;
cfg.glm2.con(1).outdir = 'faces-scrambled';
cfg.glm2.con(2).name = cfg.glm1.con(6).name;
cfg.glm2.con(2).outdir = 'familiar-unfamiliar';
