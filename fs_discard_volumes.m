function fs_discard_volumes(cfg, subject_dir)

cfg = fs_get_config(cfg, 'discard');

rd = fs_getd_runs(subject_dir);

for i = 1:length(rd)
    fprintf('Discarding first %i volumes of run %i/%i\n', cfg.n, i, length(rd))
    discard_volumes(fullfile(rd{i}, 'bold.nii'), cfg.n, cfg.Nmin);
end

function discard_volumes(input, n, Nmin)
% Discard the first n volumes of a 4D nifti file.

% Nmin : ensure that minimum Nmin volumes are kept.

V = spm_vol(input);
if nargin>2
    if length(V(n+1:end))<Nmin
        fprintf('Discarding volumes will result in less than Nmin (%i) volumes.\n',Nmin)
        fprintf('Aborting.\n')
        return
    end
end
[pa, ~, ex] = fileparts(input);
output = [fullfile(pa,'tmp') ex];    % Temporary output
spm_file_merge(V(n+1:end), output);  % Write to 4D
movefile(output, input);             % Overwrite
delete([fullfile(pa,'tmp') '.mat']); % Delete .mat transform