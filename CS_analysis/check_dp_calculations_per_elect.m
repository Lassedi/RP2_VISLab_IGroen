%% Category selectivity pipeline
% specify paths for data and prf results
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/data_A/derivatives/ECoGPreprocessed';
% prfFitPath =
% '~/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/analysis/prfs';
% ^old
prfFitPath = '/home/lasse/Documents/ECoG_PRF_categories/data_A/prf_fits/prf_woNorm_dataA';

addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories/matlab_code'))

%% load data 
sub_list = ["p02"];%, "p02", "p05", "p06", "p07", "p08", "p09", "p10", "p11", "p12", "p13", "p14"];
stim = ["FACES", "HOUSES", "BUILDINGS"];

for sub = 1:length(sub_list)
    % Pick a subject & load data, prf-results
    subject = sub_list(sub);
    loadName = fullfile(dataDir, sprintf('sub-%s_prfcatdata.mat', subject));
    load(loadName);
    
    % load PRF results and calculate mean R2 crossvalidation
    load(sprintf("%s/sub-%s_prffits.mat", prfFitPath, subject));
end

%% check d' calculations
el = "GA52";
el_epochs = epochs(:,:,strcmp(channels.name, el));

means_trials_f = mean(el_epochs(t>0&t<0.85,strcmp(events.trial_name, stim(1))));

means_trials_h = mean(el_epochs(t>0&t<0.85,strcmp(events.trial_name, stim(2))));

% calculate d'
mean_f = mean(means_trials_f);
mean_h = mean(means_trials_h);

var_f = var(means_trials_f);
var_h = var(means_trials_h);

mean_dif = mean_f-mean_h;
mean_std = sqrt((var_f + var_h)/2);

d_prime = mean_dif/mean_std;

% make a table with the different values
addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories/matlab_code'))
if ~exist("d_prime_tbl", "var")
    d_prime_tbl = cell(0,8);
end

tbl_row = [{el}, {mean_f}, {mean_h}, {var_f}, {var_h}, {mean_dif}, {mean_std}, {d_prime}];

d_prime_tbl(end+1,:) = tbl_row;

if iscell(d_prime_tbl)
    d_prime_tbl = cell2table(d_prime_tbl);
end
%name the columns
col_names = {getVarName(el), getVarName(mean_f), getVarName(mean_h), getVarName(var_f),...
    getVarName(var_h), getVarName(mean_dif), getVarName(mean_std), getVarName(d_prime)};
d_prime_tbl.Properties.VariableNames = col_names;

%% visual check of trial means distribution
el = "Oc19";
el_epochs = epochs(:,:,strcmp(channels.name, el));

means_trials_f = mean(el_epochs(t>0&t<0.85,strcmp(events.trial_name, stim(1))));
means_trials_h = mean(el_epochs(t>0&t<0.85,strcmp(events.trial_name, stim(2))));

if ~exist("fig_names", "var")
    fig_names = cell([0,0]);
end


vis_check_dp_trial_means_dist(means_trials_f, means_trials_h, el);
fig_names = [fig_names,{sprintf("%s_midterm", get(gcf,"Name"))}];
%% save plots
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';
saveplots(saveDir, "trialMeansDist_check", subject, fig_names);
clear fig_names
close all