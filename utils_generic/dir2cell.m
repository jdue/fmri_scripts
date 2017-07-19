function cell_x = dir2cell(x)
% Convert the result of dir to cell using .name field

cell_x = cell(1,length(x));
for i = 1:length(x)
    cell_x{i} = fullfile(x(1).name); 
end

% if ispc
%     cell_x = cellstr(x);
% elseif isunix
%     cell_x = strsplit(x);
% end