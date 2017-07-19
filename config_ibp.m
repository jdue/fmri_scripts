% CONFIGURATION FILE
% 

% DISCARD
% =========================================================================
cfg.discard.n    = 3;
cfg.discard.Nmin = 322;


% WAVELET DESPIKE
% =========================================================================
cfg.wavelet.limitRAM = 10;


% PREPROCESSING
% =========================================================================
TR = 1.368;

% Slice timing
so = [0.0, 712.49999999, 79.99999999, 792.49999998, ...
      157.5, 872.5, 237.49999999, 952.49999998, ...
      317.49999998, 1030.0, 397.49999999, 1109.99999999, ...
      474.99999998, 1190.0, 554.99999999, 1267.49999999, ...
      634.99999998, 0.0, 712.49999999, 79.99999999, ...
      792.49999998, 157.5, 872.5, 237.49999999, ...
      952.49999998, 317.49999998, 1030.0, 397.49999999, ...
      1109.99999999, 474.99999998, 1190.0, 554.99999999, ...
      1267.49999999, 634.99999998, 0.0, 712.49999999, ...
      79.99999999, 792.49999998, 157.5, 872.5, ...
      237.49999999, 952.49999998, 317.49999998, 1030.0, ...
      397.49999999, 1109.99999999, 474.99999998, 1190.0, ...
      554.99999999, 1267.49999999, 634.99999998, 0.0, ...
      712.49999999, 79.99999999, 792.49999998, 157.5, ...
      872.5, 237.49999999, 952.49999998, 317.49999998, ...
      1030.0, 397.49999999, 1109.99999999, 474.99999998, ...
      1190.0, 554.99999999, 1267.49999999, 634.99999998];

cfg.preproc.st.tr = TR;
if all(so==round(so)) %|| any(so>250)
    sso = sort(so);
    cfg.preproc.st.so = so;
    cfg.preproc.st.ref = sso(round(length(so)/2));
else
    cfg.preproc.st.so = so;
    cfg.preproc.st.ref = so(round(length(so)/2));
end
cfg.preproc.st.nslices = length(cfg.preproc.st.so); % no. of slices
cfg.preproc.st.ta = cfg.preproc.st.tr-(cfg.preproc.st.tr/cfg.preproc.st.nslices); % acquisition time, usually TR-(TR/nslices)
clear so sso

% Segmentation
cfg.preproc.segment.reg = 'eastern';

% Normalization
cfg.preproc.normalize.vox_epi = [3 3 3];
cfg.preproc.normalize.vox_t1  = [2 2 2];

% Smoothing
cfg.preproc.smooth.fwhm = [6 6 6];

% FieldMap
cfg.preproc.vdm.te_short = 4.92;
cfg.preproc.vdm.te_long  = 7.38;
cfg.preproc.vdm.BPPPE    = 15.466;
cfg.preproc.vdm.blip_dir = -1;


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
cfg.glm1.con(1).name    = 'Effects of Interest';
cfg.glm1.con(1).weights = [1 0 0 0; ...
                           0 1 0 0; ...
                           0 0 1 0; ...
                           0 0 0 1];
cfg.glm1.con(2).name    = 'Right Index';
cfg.glm1.con(2).weights = [1 0 0 0];     
cfg.glm1.con(3).name    = 'Right Middle';
cfg.glm1.con(3).weights = [0 1 0 0];
cfg.glm1.con(4).name    = 'left Index';
cfg.glm1.con(4).weights = [0 0 1 0];
cfg.glm1.con(5).name    = 'Left Middle';
cfg.glm1.con(5).weights = [0 0 0 1];
cfg.glm1.con(6).name    = 'Right Index > Right Middle';
cfg.glm1.con(6).weights = [1 -1 0 0];
cfg.glm1.con(7).name    = 'Right Middle > Right Index';
cfg.glm1.con(7).weights = [-1 1 0 0];
cfg.glm1.con(8).name    = 'Left Index > Left Middle';
cfg.glm1.con(8).weights = [0 0 1 -1];
cfg.glm1.con(9).name    = 'Left Middle > Left Index';
cfg.glm1.con(9).weights = [0 0 -1 1];


% SECOND LEVEL GLM
% =========================================================================

% Contrasts
cfg.glm2.con(1).name = cfg.glm1.con(1).name;
cfg.glm2.con(1).outdir = 'effects_of_interest';

cfg.glm2.con(2).name = cfg.glm1.con(2).name;
cfg.glm2.con(2).outdir = 'right_index';
cfg.glm2.con(3).name = cfg.glm1.con(3).name;
cfg.glm2.con(3).outdir = 'right_middle';

cfg.glm2.con(4).name = cfg.glm1.con(4).name;
cfg.glm2.con(4).outdir = 'left_index';
cfg.glm2.con(5).name = cfg.glm1.con(5).name;
cfg.glm2.con(5).outdir = 'left_middle';

cfg.glm2.con(6).name = cfg.glm1.con(6).name;
cfg.glm2.con(7).outdir = 'right_index-middle';
cfg.glm2.con(7).name = cfg.glm1.con(7).name;
cfg.glm2.con(7).outdir = 'right_middle-index';

cfg.glm2.con(8).name = cfg.glm1.con(8).name;
cfg.glm2.con(8).outdir = 'left_index-middle';
cfg.glm2.con(9).name = cfg.glm1.con(9).name;
cfg.glm2.con(9).outdir = 'left_middle-index';