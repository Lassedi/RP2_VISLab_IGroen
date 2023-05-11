tbUse({'ECoG_utils' 'analyzePRF'});
%%
%prfFitPath = '~/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/analysis/prfs';
%^old 
prfFitPath = '~/Documents/ECoG_PRF_categories/data/prf_fits/prf_2withNormalization';
dataDir = '~/Documents/ECoG_PRF_categories/data';
addpath(prfFitPath)
%
subject = "p02";

load(fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject)))
load(sprintf("sub-%s_prffits.mat", subject))

%% plot prf fits
coloropt = 0;
RP2ecog_plotPRFs(results, stimulus, channels,[], coloropt, [])
%% save prf fits 
addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories/matlab_code'));
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';
filename = {zeros(length(findobj("type", "figure")))};
for fign = 1:length(findobj("type", "figure"))
        filename{fign} = sprintf("prfs_%i", fign);
end
saveplots(saveDir, "prf_all elect", subject, filename);
close all
%% plot timeseries fits
%{
addpath(".")
data = prep_data(convertCharsToStrings(subject), dataDir);

data = RP2tde_computePRFtimecourses(data2fit);

data_ori = mean(data{1}.ts, 3);
%}
%data2fit = {data{1}.ts(:,:,1), data{1}.ts(:,:,2)};
RP2ecog_plotPRFtsfits(data2fit, stimulus, results, channels)
%% save prf ts fits 
addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories/matlab_code'));
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';
filename = {zeros(length(findobj("type", "figure")))};
for fign = 1:length(findobj("type", "figure"))
        filename{fign} = sprintf("prfs_%i", fign);
end
saveplots(saveDir, "prfTS_allelect", subject, filename);
close all