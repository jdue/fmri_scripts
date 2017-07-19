function fs_concat_3d(cfg, subject_dir)

fprintf('Concatenating volumes\n')
fs_print_bar();

cfg = fs_get_config(cfg, 'concat');

rd = fs_getd_runs(subject_dir);

for i = 1:length(rd)
    [~, run] = fileparts(rd{i});
    fprintf('%s\n', run)
    
    % Get the functional images
    bold = cellstr(spm_select('FPList', rd{i}, cfg.filter));
    if all(size(bold)==[1,1]) && isempty(bold{1})
        fprintf('\n')
        disp('No 3D BOLD files to concatenate.')
        fprintf('\n')
        continue
    end
    
    fprintf('Concatenating 3D to 4D... ')
    spm_file_merge(bold, fullfile(rd{i}, 'bold.nii'));
    fprintf('Done\n');
     
    fprintf('Deleting 3D files... ')
    for frame = 1:length(bold)
        delete(bold{frame});
    end
    fprintf('Done\n\n')
end