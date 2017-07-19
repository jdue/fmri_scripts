function SPM = nuis2iG(SPM,str)
%
% this function will move the movement regressors to the
% nuisance partition prior to the estimation of the
% design.
%
% ARGS:
% SPM -- SPM structure
% str -- cell array of strings containing unique parts of the 
%        names of the movement parameters or regressors to be 
%        moved to iG (defaults to {'bs','R','nuis','miss'})
%

% The names of regressors can be found in SPM.xX.name. They
% always start with 'SN(x) ' indicating the session of the
% regressors. Then follows the given name, followed by '*bf(x)'
% indicating that it has be convolved with the x column of the
% basis set.
%
% The argument "str" should be the first letters of the given
% name without the session specifier. For example, you have named
% your movement parameters rp1, rp2 etc. Then the SPM name of
% these regressors are: 'Sn(1) rp1', Sn(1) rp2', etc. The "str"
% argument to this function should then be 'rp'. By default, when
% using the "Multiple Regressor" option and specifying the text
% file with the motion parameters, the motion regressors are
% called R1 - R6; hence the default is "R" (but you shouldn't
% have another regressors starting with "R"). You can also
% specify addition nuisance variable through the "Covariates'
% interface of the job manager (giving them different names).
% Speciying their prefix in the "str" cell array will also move
% them to the iG partition of the design matrix.
%
% Explanation:
% SPM partitions the design matrix into 4 different partitions:
% 1. effects if interest (iC)
% 2. effects of no interest (iH)
% 3. nuisance regressors (iG)
% 4. block effects (session constants) (iB)
%
% These different partitions are field in the struct SPM.xX. They
% are vectors of columns number indicating which regressors are
% in different partitions.
%
% Upon estimation SPM internally runs and effects of interest
% F-Test to determine which are are the interesting voxels on
% which the statistics should be run. Only voxel surviving this
% initial F-Test are subsequently considered for further
% statistical analysis. The threshold for this initial F-Test can
% be set in spm_defaults.m: defaults.stats.fmri.ufp (defaults to
% 0.001)
%
% This initial F-Contrast is an identity matrix spanning the
% columns of the effects of interest and no interest (iC and iH),
% ignoring the nuisance and block regressors (iG and iB).
%
% The inclusion of the movement parameters in the iG partition is
% not done automatically, because SPM doesn't know which
% additional regressors are of interest or simply nuisance. Thus,
% this has to be done manually by the user (there is no way to do
% this in the GUI).
%
% This can turn out to be important, if for some reason, voxels
% that show strong momvement-related activation survive the
% initial F-Test and are therefore included in the statistical
% analysis.
% ----------------------------------------------------------------
% Jan Glaescher Oct-17-2007

if nargin < 2; str = {'bs','R','nuis','miss'}; end

if nargin < 1
	error('Must supply an SPM struct.')
end

iG = [];
name = SPM.xX.name;
for n = 1:length(name)
	name{n} = name{n}(7:end);
end

for s = 1:length(str)
	iG = [iG strmatch(str{s},name)'];
end
SPM.xX.iG = sort(iG);
for g = 1:length(iG)
	SPM.xX.iC(SPM.xX.iC==iG(g)) = [];
end
return;