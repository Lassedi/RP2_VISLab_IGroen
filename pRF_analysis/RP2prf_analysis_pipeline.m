%% 1: Preparing Dataset
dataDir = '~/Documents/ECoG_PRF_categories/data';
sub_list = ["p01", "p02", "p05", "p06", "p07", "p08", "p09", "p10","p11"];

data = prep_data(sub_list, dataDir);

%% do some things to the data
[data] = RP2tde_computePRFtimecourses(data, [], []);

%% Load the stimulus apertures
%cd /home/lasse/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/
stimName = fullfile(tdeRootPath, 'prf_apertures', 'bar_apertures.mat');
load(stimName, 'bar_apertures');

%% 2: Model fitting
cd /home/lasse/Documents/ECoG_PRF_categories/matlab_code/pRF_analysis/
tbUse ({'ECoG_utils', 'analyzePRF'});

% Fit the PRF time courses with analyzePRF
addpath(genpath("/home/lasse/Documents/ECoG_PRF_categories/matlab_code/"))
tr              = 1;
opt.hrf         = 1;
opt.maxpolydeg  = 0;
opt.xvalmode    = 0; 
opt.forcebounds = 1;
opt.display     = 'off';

doPlots = true;
[results] = RP2tde_fitPRFs(data, bar_apertures, opt, doPlots);
