function cimgs = fs_get_contrast_images(root_dir, con_name)
% 
%
% Parameters
% ----------
% root_dir : Directory in which subject directories are found
% con_name : Name of the 1st level contrast to get images for
%
% Returns
% ----------
% cimgs    : Full path to the contrast images

%subjects = to_cell(ls(fullfile(root_dir, 'sub*')));
subjects = fs_fullpath(root_dir, 'sub*');
mask = logical(size(subjects));
for i = 1:length(subjects)
    mask(i) = isdir(subjects{i});
end
subjects = subjects(mask);
%subjects = cat_paths(root_dir, subjects(mask));

cimgs = cell(size(subjects));
for i = 1:length(subjects)
    level1 = fullfile(fs_getd_fmri(subjects{i}), 'Analysis', 'SPM_1st_level');
    load(fullfile(level1, 'SPM.mat'));
    for j = 1:length(SPM.xCon)
        if strfind(lower(SPM.xCon(j).name), lower(con_name))
            cimgs{i} = fullfile(level1, SPM.xCon(j).Vcon.fname);
        end
    end
end
