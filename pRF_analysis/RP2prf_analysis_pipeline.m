% 1: Preparing Dataset
tbUse ({'ECoG_utils', 'analyzePRF'});


%% dataDir = '~/Documents/ECoG_PRF_categories/data_A/data_light';
dataDir = '~/Documents/ECoG_PRF_categories/data_A';
%dataDir = '~/Documents/ECoG_PRF_categories/data';

sub_list = ["p02"];%,"p02", "p05", "p06", "p07", "p08", "p09", "p10","p11", "p12", "p13", "p14"];

data = prep_data(sub_list, dataDir);

% do some things to the data
[data] = RP2tde_computePRFtimecourses(data, [], []);

% Load the stimulus apertures
%cd /home/lasse/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/
stimName = fullfile(tdeRootPath, 'prf_apertures', 'bar_apertures.mat');
load(stimName, 'bar_apertures');

% 2: Model fitting
% Fit the PRF time courses with analyzePRF
addpath(genpath("/home/lasse/Documents/ECoG_PRF_categories/matlab_code/"))
tr              = 1;
opt.hrf         = 1;
opt.maxpolydeg  = 0;
opt.xvalmode    = 2; 
opt.forcebounds = 1;
opt.display     = 'off';
saveDir         = '/home/lasse/Documents/ECoG_PRF_categories/data/prf_fits/prf_woNorm_dataAT';


doPlots = false;
[results] = RP2tde_fitPRFs(data, bar_apertures, opt, doPlots,saveDir,[],[],false);