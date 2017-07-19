function fs_preprocess(cfg_file, subject_dir)

cfg = fs_get_config(cfg_file, 'preproc');

% Prepare for Preprocessing
% =========================================================================
[bold, nruns] = fs_get_bold(subject_dir);
t1 = fs_get_t1(subject_dir);

spm_dir = spm('dir');
tpm_dir = fullfile(spm_dir, 'tpm');

% Start the Preprocessing
% =========================================================================
fs_initialize_spm()

%[~, subject] = fileparts(subject_dir);
%fprintf('Preprocessing %s\n', subject)

% Get voxel displacement maps
if isfield(cfg,'vdm')
    vdm = fs_estimate_vdm(cfg.vdm, subject_dir);
end

% Slice time correction 
mb = [];
mb{1}.spm.temporal.st.scans = cell(bold);
mb{1}.spm.temporal.st.nslices = cfg.st.nslices;
mb{1}.spm.temporal.st.tr = cfg.st.tr;
mb{1}.spm.temporal.st.ta = cfg.st.ta;
mb{1}.spm.temporal.st.so = cfg.st.so;
mb{1}.spm.temporal.st.refslice = cfg.st.ref;
mb{1}.spm.temporal.st.prefix = 'a';

% Realign
if ~exist('vdm','var') || isempty(vdm)
    % Realign only
    for i = 1:nruns
        mb{2}.spm.spatial.realign.estwrite.data{i}(1) = cfg_dep(...
            sprintf('Slice Timing: Slice Timing Corr. Images (Sess %i)',i), ...
            substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
            substruct('()',{i}, '.','files'));
    end
    mb{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    mb{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    mb{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    mb{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    mb{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    mb{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    mb{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
    mb{2}.spm.spatial.realign.estwrite.roptions.which = [0 1];
    mb{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
    mb{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    mb{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
    mb{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    
    rmean = cfg_dep(...
        'Realign: Estimate & Reslice: Mean Image', ...
        substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
        substruct('.','rmean'));
    
    rimages = cell(1,nruns);
    for i = 1:nruns
        rimages{i} = cfg_dep(...
            sprintf('Realign: Estimate & Reslice: Realigned Images (Sess %i)',i), ...
            substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
            substruct('.','sess', '()',{i}, '.','cfiles'));
    end
else
    % Realign and unwarp
    for i = 1:nruns
        mb{2}.spm.spatial.realignunwarp.data(i).scans(1) = cfg_dep(...
                sprintf('Slice Timing: Slice Timing Corr. Images (Sess %i)',i), ...
                substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
                substruct('()',{i}, '.','files'));
        mb{2}.spm.spatial.realignunwarp.data(i).pmscan = vdm(i);
    end
    mb{2}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    mb{2}.spm.spatial.realignunwarp.eoptions.sep = 4;
    mb{2}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    mb{2}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    mb{2}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    mb{2}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    mb{2}.spm.spatial.realignunwarp.eoptions.weight = '';
    mb{2}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    mb{2}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    mb{2}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    mb{2}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    mb{2}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    mb{2}.spm.spatial.realignunwarp.uweoptions.sot = [];
    mb{2}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    mb{2}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    mb{2}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    mb{2}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    mb{2}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    mb{2}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    mb{2}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    mb{2}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    mb{2}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    
    rmean = cfg_dep(...
        'Realign & Unwarp: Unwarped Mean Image', ...
        substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
        substruct('.','meanuwr'));
    
    rimages = cell(1,nruns);
    for i = 1:nruns
        rimages{i} = cfg_dep(...
            sprintf('Realign & Unwarp: Unwarped Images (Sess %i)', i), ...
            substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
            substruct('.','sess', '()',{i}, '.','uwrfiles'));
    end
end

% Coregister anatomical T1 and mean realigned EPI
%mb{3}.spm.spatial.coreg.estimate.ref(1) = cfg_dep(...
%    'Realign: Estimate & Reslice: Mean Image', ...
%    substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
%    substruct('.','rmean') ...
%    );
mb{3}.spm.spatial.coreg.estimate.ref(1) = rmean;
mb{3}.spm.spatial.coreg.estimate.source = cellstr(t1);
mb{3}.spm.spatial.coreg.estimate.other = {''};
mb{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
mb{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
mb{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
mb{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

% Segment (coregistered) T1
mb{4}.spm.spatial.preproc.channel.vols(1) = cfg_dep(...
    'Coregister: Estimate: Coregistered Images', ...
    substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','cfiles'));
mb{4}.spm.spatial.preproc.channel.biasreg = 0.001;
mb{4}.spm.spatial.preproc.channel.biasfwhm = 60;
mb{4}.spm.spatial.preproc.channel.write = [0 0];
mb{4}.spm.spatial.preproc.tissue(1).tpm = {fullfile(tpm_dir, 'TPM.nii,1')};
mb{4}.spm.spatial.preproc.tissue(1).ngaus = 1;
mb{4}.spm.spatial.preproc.tissue(1).native = [1 0];
mb{4}.spm.spatial.preproc.tissue(1).warped = [0 0];
mb{4}.spm.spatial.preproc.tissue(2).tpm = {fullfile(tpm_dir, 'TPM.nii,2')};
mb{4}.spm.spatial.preproc.tissue(2).ngaus = 1;
mb{4}.spm.spatial.preproc.tissue(2).native = [1 0];
mb{4}.spm.spatial.preproc.tissue(2).warped = [0 0];
mb{4}.spm.spatial.preproc.tissue(3).tpm = {fullfile(tpm_dir, 'TPM.nii,3')};
mb{4}.spm.spatial.preproc.tissue(3).ngaus = 2;
mb{4}.spm.spatial.preproc.tissue(3).native = [1 0];
mb{4}.spm.spatial.preproc.tissue(3).warped = [0 0];
mb{4}.spm.spatial.preproc.tissue(4).tpm = {fullfile(tpm_dir, 'TPM.nii,4')};
mb{4}.spm.spatial.preproc.tissue(4).ngaus = 3;
mb{4}.spm.spatial.preproc.tissue(4).native = [1 0];
mb{4}.spm.spatial.preproc.tissue(4).warped = [0 0];
mb{4}.spm.spatial.preproc.tissue(5).tpm = {fullfile(tpm_dir, 'TPM.nii,5')};
mb{4}.spm.spatial.preproc.tissue(5).ngaus = 4;
mb{4}.spm.spatial.preproc.tissue(5).native = [1 0];
mb{4}.spm.spatial.preproc.tissue(5).warped = [0 0];
mb{4}.spm.spatial.preproc.tissue(6).tpm = {fullfile(tpm_dir, 'TPM.nii,6')};
mb{4}.spm.spatial.preproc.tissue(6).ngaus = 2;
mb{4}.spm.spatial.preproc.tissue(6).native = [0 0];
mb{4}.spm.spatial.preproc.tissue(6).warped = [0 0];
mb{4}.spm.spatial.preproc.warp.mrf = 1;
mb{4}.spm.spatial.preproc.warp.cleanup = 1;
mb{4}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
mb{4}.spm.spatial.preproc.warp.affreg = cfg.segment.reg;
mb{4}.spm.spatial.preproc.warp.fwhm = 0;
mb{4}.spm.spatial.preproc.warp.samp = 3;
mb{4}.spm.spatial.preproc.warp.write = [0 1];

% Normalize T1
mb{5}.spm.spatial.normalise.write.subj.def(1) = cfg_dep(...
    'Segment: Forward Deformations', ...
    substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','fordef', '()',{':'}));
mb{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep(...
    'Coregister: Estimate: Coregistered Images', ...
    substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','cfiles') ...
    );
mb{5}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70; 78 76 85];
mb{5}.spm.spatial.normalise.write.woptions.vox = cfg.normalize.vox_t1;
mb{5}.spm.spatial.normalise.write.woptions.interp = 4;
mb{5}.spm.spatial.normalise.write.woptions.prefix = 'w';

% Normalize EPIs
mb{6}.spm.spatial.normalise.write.subj.def(1) = cfg_dep(...
    'Segment: Forward Deformations', ...
    substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','fordef', '()',{':'}) ...
    );
for i = 1:nruns
    mb{6}.spm.spatial.normalise.write.subj.resample(i) = rimages{i};
    
    %mb{6}.spm.spatial.normalise.write.subj.resample(i) = cfg_dep(...
    %    sprintf('Realign: Estimate & Reslice: Realigned Images (Sess %i)',i), ...
    %    substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    %    substruct('.','sess', '()',{i}, '.','cfiles') ...
    %    );
end
mb{6}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70; 78 76 85];
mb{6}.spm.spatial.normalise.write.woptions.vox = cfg.normalize.vox_epi;
mb{6}.spm.spatial.normalise.write.woptions.interp = 4;
mb{6}.spm.spatial.normalise.write.woptions.prefix = 'w';

% Smooth EPIs
mb{7}.spm.spatial.smooth.data(1) = cfg_dep(...
    'Normalise: Write: Normalised Images (Subj 1)', ...
    substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('()',{1}, '.','files') ...
    );
mb{7}.spm.spatial.smooth.fwhm = cfg.smooth.fwhm;
mb{7}.spm.spatial.smooth.dtype = 0;
mb{7}.spm.spatial.smooth.im = 0;
mb{7}.spm.spatial.smooth.prefix = 's';

spm_jobman('run', mb);
