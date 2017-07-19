function fs_cleanup(subject_dir, keep)
% Remove intermediate files in the directories 'run...'. Keep only
% 
% bold.nii
% rp_*.txt
% dsw*.nii
% ubold.nii

if nargin < 2
    keep = {'bold.nii', 'ubold.nii', '^rp_*.txt', '^dsw*.nii'};
end
if isa(keep, 'char') && strcmp(keep, 'all')
    keep = {'bold.nii'};
end
keep = cell(keep); % Ensure cell


rd = fs_getd_runs(subject_dir);

% Ensure bold.nii is kept
if ~any(ismember(keep, 'bold.nii'))
    keep{end+1} = 'bold.nii';
end

for i = 1:length(keep)
    keep{i} = strrep(keep{i}, '*', '\w*');
end

for i = 1:length(rd)
    files = fs_fullpath(rd{i},'*');
    files = files(3:end);

    for j = 1:length(keep)
        if isempty(regexp(keep{j}, '[*^]', 'ONCE'))
            files(ismember(files,keep{j})) = [];
        else
            x = regexp(files,keep{j});
            files(~cellfun(@isempty, x)) = [];
        end
    end
    % Delete
    for k = 1:length(files)
        delete(files{k});
    end
end