function [saveDir] = get_utils()
%get to .../matlab_code and add the .../matlab_code to path in order to get
%access to .../matlab_code/RP2utils for pubgraph
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';

[~,x] = fileparts(pwd); %get string of current folder name
count = 0;

%check if current folder is matlab_code and ifso add the wd to path
if x == "matlab_code"
    y = pwd;
end

%go back subfolders until you get to matlab_code and again add it to path
%with its subfolders
while x ~= "matlab_code"
    [y,~] = fileparts(pwd); %get path excluding current folder
    [~,x] = fileparts(y);
    
    if count == 5 % how many parent folders to check
        error("matlab_code not a parent directory")
    end
    count = count + 1;
end

%add matlab_code and subfolders to path
addpath(genpath(y))
end