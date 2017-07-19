function cfg = fs_get_config(cfg, field)
% cfg : configuration struct or an .m file defining a struct named 'cfg'.
% 
% Configuration file for specifying most common options including
%   * preprocessing
%   * 1st level GLM statistics
% 

if nargin < 2
    field = '';
end

% Get options from the configuration file
if isa(cfg, 'char') && exist(cfg, 'file')
    run(cfg)
end
assert(isa(cfg, 'struct'), '"cfg" must be either a struct or file containing a struct named "cfg".');

if ~isempty(field)
    % Return only the requested field
    cfg = cfg.(field);
end