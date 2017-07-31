clear all

% set folders
% -------------------------------------------------------------------------
root = 'E:\DATA_yuan';
    path.FunImg = fullfile(root,'FunImg_Num');

% get subjects
% -------------------------------------------------------------------------
subject      = dir(path.FunImg);
subject      = struct2cell(subject)';
subject      = char(subject(:,1));
subject(subject(:,1)=='.',:) = [];
num.subjects = size(subject,1);
subject      = cellstr(subject);

% plot realignment parameters
% -------------------------------------------------------------------------
close(figure(1)) % close figure(1)
for i=1:num.subjects
    w = waitforbuttonpress; % press a key or button to display rp for ith subject
    fprintf('Displaying realignment parameters for subject %s\n',subject{i})
    q=load(spm_select('FPList',fullfile(path.FunImg,subject{i}),'^rp_.*.txt'));
    if w == 0 || w==1
        display_rp(q)
    else
    end
end
disp('All subjects have been checked!')