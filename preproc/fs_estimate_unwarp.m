function vdm = fs_estimate_unwarp(cfg, subject_dir)

% Options
try te_short = cfg.te_short; catch; error('Must specify short TE'); end
try te_long = cfg.te_long; catch; error('Must specify long TE'); end
try tert = cfg.tert; catch; error('Must specify total EPI readout time'); end
try blip_dir = cfg.blip_dir; catch; blip_dir = -1; end

% Get BOLD images. Keep only the first volume
[bold, nruns] = fs_get_bold(subject_dir);
for i = 1:nruns
    bold{i} = bold{i}{1};
end

% Get phase and (first) magnitude image
[phase, mags] = fs_get_fieldmap(subject_dir);
if isempty(phase) || isempty(mags)
    fprintf('Magnitude and phase images not found.\n')
    vdm = cell(0);
    return
else
    mag = mags(1);
end

% Get FieldMap T1 template
spm_dir = spm('dir');
fm_template = fullfile(spm_dir, 'toolbox', 'FieldMap', 'T1.nii');

fprintf('Estimating voxel displacement maps using the following parameters\n')
fprintf('TE (short)                   : %5.2f ms\n', te_short)
fprintf('TE (long)                    : %5.2f ms\n', te_long)
fprintf('Total EPI readout time       : %5.2f ms\n', tert)
fprintf('\n')

%initialize_spm()
matlabbatch = [];
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase = phase;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude = mag;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.et = [te_short te_long];
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.maskbrain = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.blipdir = blip_dir;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.tert = tert;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.epifm = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.ajm = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.method = 'Mark3D';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.fwhm = 10;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.pad = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.ws = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.template = {fm_template};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.fwhm = 5;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.nerode = 2;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.ndilate = 4;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.thresh = 0.5;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.reg = 0.02;
% Get the first volume from each session/run
for i = 1:nruns
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session(i).epi = bold(i);
end
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'run';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = {''};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;
spm_jobman('run',matlabbatch);

[~, ~, vdm] = fs_get_fieldmap(subject_dir);