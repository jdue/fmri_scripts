function fs_concat_3d(cfg_file, subject_dir)

fprintf('Concatenating volumes\n')
fs_print_bar();

cfg = fs_get_config(cfg_file, 'concat');

rd = fs_getd_runs(subject_dir);

for i = 1:length(rd)
    [~, run] = fileparts(rd{i});
    fprintf('Processing %s\n', run)
    
    % Get the functional images
    bold = cellstr(spm_select('FPList', rd{i}, cfg.filter));
    if all(size(bold)==[1,1]) && isempty(bold{1})
        fprintf('\n')
        disp('No 3D BOLD files to concatenate.')
        fprintf('\n')
        continue
    end
    
    % Convert to 4D
    spm_file_merge(bold, fullfile(rd{i}, 'bold.nii'));
    
    %matlabbatch = [];
    %matlabbatch{1}.spm.util.cat.vols = epi;
    %matlabbatch{1}.spm.util.cat.name = 'bold.nii';
    %matlabbatch{1}.spm.util.cat.dtype = 4;
    %spm_jobman('run', matlabbatch);
    
    % Delete 3D
    fprintf('Deleting 3D files... ')
    for frame = 1:length(bold)
        delete(bold{frame});
    end
    fprintf('Done\n\n')
end