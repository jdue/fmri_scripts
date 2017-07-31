function fs_display_rp(sd)
% Display realignment parameters as estimated by SPM.

[~,subject] = fileparts(sd);
bold = fs_getd_runs(sd);
fprintf('Displaying realignment parameters for subject %s\n\n', subject)
for i = 1:length(bold)
    fprintf('Run %i of %i\n',i, length(bold))
    q = load(spm_select('FPList',fullfile(bold{i}),'^rp_.*.txt'));
    display_rp(q);
    fprintf('Press any key to continue.\n')
    waitforbuttonpress; % press a key or button to display rp for ith subject  
end
close

function display_rp(q)
% Display motion parameters and get maximum translation in all directions
% and maximum rotation around all axes.
% 
% FORMAT display_rp(q)
% 
% q - matrix containing six realignment parameters (in columns)
%
% _________________________________________________________________________
% 2015-05-21
% Jesper Duemose Nielsen

if isstruct(q)                  % if loading a mat file
    q = struct2cell(q);
    q = q{:};
end
if size(q,2)~=6
   error('Expecting matrix of six parameters')
end

mt = max(abs(q(:,1:3)));        % max translation in all directions
mr = max(abs(q(:,4:6)*180/pi)); % max rotation around all axes

% Plot realignment parameters
subplot(2,1,1)
plot(q(:,1:3)),grid on
    title('Realignment Parameters: Translation')
    xlabel('Time (Scans)'), ylabel('Translation (mm)')
    legend('x','y','z')
    xlim([0 length(q)])

subplot(2,1,2)
plot(q(:,4:6)*180/pi),grid on
    title('Realignment Parameters: Rotation')
    xlabel('Time (Scans)'), ylabel('Rotation (degrees)')
    legend('Pitch','Roll','Yaw')
    xlim([0 length(q)])

% Print maxima to command line
fprintf('\nMOTION PARAMETERS MAXIMA\n')
fprintf('===============================================\n')
fprintf('Translation             Rotation\n')
fprintf('------------------      -----------------------\n')
fprintf('x        %6.2f mm      Pitch    %6.2f degrees\n',mt(1),mr(1))
fprintf('y        %6.2f mm      Roll     %6.2f degrees\n',mt(2),mr(2))
fprintf('z        %6.2f mm      Yaw      %6.2f degrees\n',mt(3),mr(3))
fprintf('===============================================\n\n')
