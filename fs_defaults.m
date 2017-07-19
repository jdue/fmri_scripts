function fs_defaults()

fd = fs_dir();

addpath(fullfile(fd, 'glm'));
addpath(fullfile(fd, 'misc'));
addpath(fullfile(fd, 'preproc'));
addpath(fullfile(fd, 'utils'));
addpath(fullfile(fd, 'utils_generic'));

fs_check_third_in_path();
