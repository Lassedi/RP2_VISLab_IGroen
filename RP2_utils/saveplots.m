function saveplots(saveDir, folder_name, subject, file_name)
%saves plots when provided with a savedirectory & folder name for the plots
% make another directory for the specific subjecct - filname should be cell
% array (1*x dim) with x many filenames as there are plots
if ~isfolder(fullfile(saveDir, folder_name))
    mkdir(fullfile(saveDir, folder_name));
    saveDir = fullfile(saveDir, folder_name);
else 
    saveDir = fullfile(saveDir, folder_name);
end

if ~isfolder(fullfile(saveDir, subject))
    mkdir(fullfile(saveDir, subject))
    saveDir = fullfile(saveDir, subject);
else
    saveDir = fullfile(saveDir, subject);
end
fig_count = length(findobj("type", "figure"));

for f = 1:fig_count    
    set(f, "Name", file_name{f})
    set(f, 'Position', get(0,'screensize'))
    saveas(f, fullfile(saveDir, file_name{f}), "png")
    close
end