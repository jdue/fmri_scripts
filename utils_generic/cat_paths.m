function files = cat_paths(folder, files)

for i = 1:length(files) 
   files{i} = fullfile(folder, files{i});
end