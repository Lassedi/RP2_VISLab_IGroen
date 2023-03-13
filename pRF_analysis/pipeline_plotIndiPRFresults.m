%% Helper functions
tbUse({'ECoG_utils' 'analyzePRF'})
%% load the table containing the namees of electrods which are OS and have
%pos R2
addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories'))

elect_prf = readtable("goodPRF_OS_elect.xls");
% Load results & dataOdsf
prfFitPath = '~/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/analysis/prfs';

subject = "p05";
elect = elect_prf(elect_prf.Participant == subject,:);
load(sprintf("%s/sub-%s_prffits.mat", prfFitPath, subject));
load(sprintf('sub-%s_prfcatdata.mat', subject));

%% PLot prf per subject
RP2ecog_plotPRFs(results, stimulus, channels, [], 1, elect.Electrode)

%% Saving plot to drectory (PRF)
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';

file_name = {zeros(length(elect.Electrode), 1)};
for f = 1:length(elect.Electrode)
    file_name{f} = sprintf("%s_modelPredPRF", elect.Electrode{f});
end
saveplots(saveDir, "modelPredPRF", subject, file_name)
%% Plot individual trials including blanks and the corresponding model prediction (TimeSeries)
for el = 1:length(elect.Electrode)    
    % select data for the specific electrode and pRF trials only
    electrode = elect.Electrode{el};
    elect_pRF_act = epochs(:,:,strcmp(electrodes.name, electrode));
    el_ind = find(strcmp(electrodes.name, electrode), 1, "first");
    
    %generate model ts and plot data and prediction
    modelts = generate_modelts(data2fit, stimulus, results, el_ind);
    plot_ind_trials(elect_pRF_act, events, electrode, t, modelts, results, el_ind)
end

%% Saving plot to directory (Timeseries)
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';

file_name = {zeros(length(elect.Electrode), 1)};
for f = 1:length(elect.Electrode)
    file_name{f} = sprintf("%s_indivTrialModPred_Resp", elect.Electrode{f});
end
saveplots(saveDir, "modelPredTS_indivTrialResp", subject, file_name)
