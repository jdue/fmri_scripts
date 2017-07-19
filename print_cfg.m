function print_cfg(cfg)

fprintf('Configuration ... \n\n')

% Concat
if isfield(cfg, 'filter')
    disp('Concat filter')
    disp(cfg.filter)
end

% Discarding initial volumes
if isfield(cfg, 'n')
    disp('Initial volumes to discard')
    disp(cfg.n)
end
if isfield(cfg, 'Nmin')
    disp('Minimum volumes to keep')
    disp(cfg.Nmin)
end

% Wavelet despike
if isfield(cfg, 'limitRAM')
    disp('RAM limit')
    disp(cfg.limitRAM)
end

% Preproc
if isfield(cfg, 'st')
%     fprintf('TR          : %.3f s\n', cfg.preproc.st.tr)
%     fprintf('Acq. time   : %.3f s\n', cfg.preproc.st.ta)
%     fprintf('Slice order : %.2f %.2f %.2f ... %.2f %.2f %.2f\n', cfg.preproc.st.so(1:3), cfg.preproc.st.so(end-2:end))
%     fprintf('Ref slice   : %.2f\n', cfg.preproc.st.ref)
%     fprintf('N slices    : %i\n', cfg.preproc.st.nslices)
    
    disp('Slice time correction')
    disp(cfg.preproc.st)
end
if isfield(cfg, 'segment')
    disp('Segment')
    disp(cfg.preproc.segment)
end
if isfield(cfg, 'normalize')    
    disp('Normalize')
    disp(cfg.preproc.normalize)
end
if isfield(cfg, 'smooth')
    disp('Smooth')
    disp(cfg.preproc.smooth)
end
if isfield(cfg, 'vdm')
    disp('Field Map')
    disp(cfg.preproc.vdm)
end

% GLM 1st / 2nd
if isfield(cfg, 'fmri_spec')
     disp('GLM design specification')
     disp(cfg.fmri_spec)
end
if isfield(cfg, 'con')     
     disp('Contrasts')
     disp(cfg.con);
end