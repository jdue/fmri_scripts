function fs_glm_2ndlevel(cfg_file, root_dir)
% 
% root_dir : directory containing the subjects
% cfg file with name and outdir
% con_name : (exact) name of the contrast from the 1st level analysis
% dirname  : name of the directory in which to write the results
% 

% OPTIONS
% =========================================================================
%con_name = 'Faces > Scrambled';

cfg = fs_get_config(cfg_file, 'glm2');

fs_initialize_spm()
for i = 1:length(cfg.con)
    con = cfg.con(i);
    fprintf('Estimating group level effects for "%s"\n', con.name);

    % Prepare for Processing
    % =========================================================================
    cimgs = fs_get_contrast_images(root_dir, con.name);

    level2 = fullfile(root_dir, 'Analysis', 'SPM_glm_2nd_level', con.outdir);
    if ~exist(level2, 'dir')
        mkdir(level2);
    end

    % Start the Processing
    % =========================================================================

    [~, subject] = fileparts(subject_dir);
    fprintf('Processing %s', subject)

    % Model specification
    matlabbatch = [];
    matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(level2);
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cimgs;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = [con.name ' (Group Effect)'];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;
    spm_jobman('run',matlabbatch);  
end   