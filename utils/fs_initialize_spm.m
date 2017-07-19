function fs_initialize_spm()

fprintf('Initializing SPM... ')

spm('defaults','fMRI');
spm_get_defaults('cmdline',true);
spm_jobman('initcfg');

fprintf('Done\n')
