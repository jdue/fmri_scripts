function cpath = fs_fullpath(path, filter)


dirs = dir(fullfile(path, filter));

cdirs = cell(1,length(dirs));
for i = 1:length(dirs)
    cdirs{i} = fullfile(dirs(i).name); 
end

cpath = cat_paths(path, cdirs);