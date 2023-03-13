tbUse({'ECoG_utils' 'analyzePRF'});
prfFitPath = '~/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/analysis/prfs';
dataDir = '~/Documents/ECoG_PRF_categories/data';

addpath(prfFitPath)

sub = "p01";

load(fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', sub)))
load("sub-p01_prffits.mat")

%% plot prf fits
coloropt = 0;
RP2ecog_plotPRFs(results, stimulus, channels, [],[], coloropt)

%% plot timeseries fits
addpath(".")
data = prep_data(sub, dataDir);

data = RP2tde_computePRFtimecourses(data);

data_ori = mean(data{1}.ts, 3);

RP2ecog_plotPRFtsfits(data_ori, stimulus, results, channels)