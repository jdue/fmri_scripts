function [epi,nruns] = fs_get_bold(subject_dir, filter)

if nargin < 2
    filter = '^bold.nii'; 
end

run_dirs = fs_getd_runs(subject_dir);

nruns = length(run_dirs);
epi = cell(nruns,1);
for i = 1:nruns
    epi{i} = cellstr(spm_select('ExtFPList', run_dirs{i},filter, Inf));
end