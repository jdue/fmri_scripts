function fs_check_third_in_path()
% Check if WaveletDespike is in the path.
fsdir = fs_dir();

if ~exist('nuis2iG', 'file')
    addpath(fullfile(fsdir, 'third_party'));
end

if ~exist('WaveletDespike','file')
    warning('Could not find WaveletDespike.m!')
    %fprintf('Adding BrainWavelet to path\n')
    %bw = fullfile(fsdir, 'third_party', 'BrainWavelet');
    %addpath(bw);
    %run setup
    %
end


%assert(exist('WaveletDespike','file')==2, '"WaveletDespike" not in path')
%assert(exist('nuis2iG','file')==2,        '"nuis2iG" not in path')
