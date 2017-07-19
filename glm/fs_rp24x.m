function filenames = fs_rp24x(subject_dir)

rd = fs_getd_runs(subject_dir);

filenames = cell(size(rd));
for i = 1:length(rd)
    rp_file = spm_select('FPList', rd{i}, '^rp.*.txt');
    m = load(rp_file);
    
    mlag = [zeros(1,6); m(1:end-1,:)];                  % calculate 1 lag
    R = [m m.^2 mlag mlag.^2];                   % compute the 24 parameters
    R = bsxfun(@minus,R,mean(R));  % demean
    R = bsxfun(@rdivide,R,std(R)); % variance normalization
    
    filenames{i} = fullfile(rd{i}, 'nvr_24_motion_expansion.txt');
    save(filenames{i}, 'R', '-ascii');
end

