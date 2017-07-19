function fs_glm_1stlevel(cfg_file, subject_dir)

cfg = fs_get_config(cfg_file, 'glm1');

% PREPARATION
% =========================================================================
[bold, nruns] = fs_get_bold(subject_dir, '^sw.*.nii');
tdefs = fs_get_trial_defs(subject_dir);
[~, level1_dir] = fs_setup_analysis_dirs(subject_dir);
nvr = fs_rp24x(subject_dir);

% PROCESS
% =========================================================================
fs_initialize_spm()

% Model specification
mb = [];
mb{1}.spm.stats.fmri_spec.dir = cellstr(level1_dir);
mb{1}.spm.stats.fmri_spec.timing.units = cfg.fmri_spec.units;
mb{1}.spm.stats.fmri_spec.timing.RT = cfg.fmri_spec.tr;
mb{1}.spm.stats.fmri_spec.timing.fmri_t = cfg.fmri_spec.t;
mb{1}.spm.stats.fmri_spec.timing.fmri_t0 = cfg.fmri_spec.t0;
for i = 1:nruns
    mb{1}.spm.stats.fmri_spec.sess(i).scans = bold{i};
    mb{1}.spm.stats.fmri_spec.sess(i).multi = cellstr(tdefs{i});
    mb{1}.spm.stats.fmri_spec.sess(i).multi_reg = nvr(i);
    mb{1}.spm.stats.fmri_spec.sess(i).hpf = cfg.fmri_spec.hp_filter;
end
mb{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
mb{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
mb{1}.spm.stats.fmri_spec.volt = 1;
mb{1}.spm.stats.fmri_spec.global = 'None';
mb{1}.spm.stats.fmri_spec.mthresh = 0.8;
mb{1}.spm.stats.fmri_spec.mask = {''};
mb{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
spm_jobman('run',mb);

% Move nuisance regressors from SPM.xX.iC (covariates) to SPM.xX.iG
% (nuisance variables)
fprintf('Moving nuisance regressors from SPM.xX.iC to SPM.xX.iG... ')
f = spm_select('FPList', level1_dir, 'SPM.mat');
load(f, 'SPM');
SPM = nuis2iG(SPM);
save(f, 'SPM');
fprintf('Done')

% Model estimation
mb = [];
mb{1}.spm.stats.fmri_est.spmmat(1) = cellstr(f);
mb{1}.spm.stats.fmri_est.write_residuals = 0;
mb{1}.spm.stats.fmri_est.method.Classical = 1;

% Contrast specification
mb{2}.spm.stats.con.spmmat(1) = cfg_dep(...
    'Model estimation: SPM.mat File', ...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','spmmat')...
    );

% Make contrasts
for i = 1:length(cfg.con)
    if all(size(cfg.con(i).weights)>1)
        mb{2}.spm.stats.con.consess{i}.fcon.name = cfg.con(i).name;
        mb{2}.spm.stats.con.consess{i}.fcon.weights = cfg.con(i).weights;
        mb{2}.spm.stats.con.consess{i}.fcon.sessrep = 'replsc';
    else
        mb{2}.spm.stats.con.consess{i}.tcon.name = cfg.con(i).name;
        mb{2}.spm.stats.con.consess{i}.tcon.weights = cfg.con(i).weights;
        mb{2}.spm.stats.con.consess{i}.tcon.sessrep = 'replsc';
    end
end
% 
% mb{2}.spm.stats.con.consess{1}.fcon.name = 'Effects of Interest';
% mb{2}.spm.stats.con.consess{1}.fcon.weights = [1 0 0
%                                                         0 1 0
%                                                         0 0 1];
% mb{2}.spm.stats.con.consess{1}.fcon.sessrep = 'replsc';
% mb{2}.spm.stats.con.consess{2}.tcon.name = 'Familiar Faces';
% mb{2}.spm.stats.con.consess{2}.tcon.weights = [1 0 0];
% mb{2}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
% mb{2}.spm.stats.con.consess{3}.tcon.name = 'Unfamiliar Faces';
% mb{2}.spm.stats.con.consess{3}.tcon.weights = [0 1 0];
% mb{2}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
% mb{2}.spm.stats.con.consess{4}.tcon.name = 'Scrambled Faces';
% mb{2}.spm.stats.con.consess{4}.tcon.weights = [0 0 1];
% mb{2}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
% mb{2}.spm.stats.con.consess{5}.tcon.name = 'Faces > Scrambled';
% mb{2}.spm.stats.con.consess{5}.tcon.weights = [0.5 0.5 -1];
% mb{2}.spm.stats.con.consess{5}.tcon.sessrep = 'replsc';
% mb{2}.spm.stats.con.consess{6}.tcon.name = 'Familiar > Unfamiliar';
% mb{2}.spm.stats.con.consess{6}.tcon.weights = [1 -1 0];
% mb{2}.spm.stats.con.consess{6}.tcon.sessrep = 'replsc';

mb{2}.spm.stats.con.delete = 0;
spm_jobman('run',mb);