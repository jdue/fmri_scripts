function cfg = fs_get_config(file, field)
% Configuration file for specifying most common options including
%   * preprocessing
%   * 1st level GLM statistics
% 

if nargin < 2
    field = '';
end

% Get options from the configuration file
run(file)
assert(exist('cfg', 'var')==1, 'Configuration file must contain variable "cfg".')

if ~isempty(field)
    % Return only the requested field
    cfg = cfg.(field);
end