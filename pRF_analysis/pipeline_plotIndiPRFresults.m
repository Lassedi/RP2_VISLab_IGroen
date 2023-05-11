%% Helper functions
tbUse({'ECoG_utils' 'analyzePRF'})
% load the table containing the namees of electrods which are OS and have
%pos R2

%%

prfFitPath = '~/Documents/ECoG_PRF_categories/data/prf_fits/prf_2withNormalization';

%specify subject and load select related data
subject = "p02";
load(sprintf("%s/sub-%s_prffits.mat", prfFitPath, subject));
addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories'))

load(sprintf('sub-%s_prfcatdata.mat', subject));
%elect_prf = readtable("goodPRF_OS_elect.xls");
elect_prf = readtable("goodPRF_OS_CSt075_PRFt10.xls");
% Load results & dataOdsf
%prfFitPath =
%'~/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/analysis/prfs';
%^old
%
elect = elect_prf(strcmp(elect_prf.Participant,subject),:);


%% PLot prf for subject
RP2ecog_plotPRFs(results, stimulus, channels, [], 1, elect)
%% Saving plot to drectory (PRF)
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';

file_name = {zeros(length(elect.Electrode), 1)};
for f = 1:length(elect.Electrode)
    file_name{f} = sprintf("%s_modelPredPRF", elect.Electrode{f});
end
saveplots(saveDir, "modelPredPRF_2", subject, file_name)
close all
%% Plot individual trials including blanks and the corresponding model prediction (TimeSeries)
for el = 1:length(elect.Electrode)    
    % select data for the specific electrode and pRF trials only
    electrode = elect.Electrode{el};
    data_2fit = cat(3, data2fit{1}, data2fit{2});
    data_2fit = reshape(data_2fit, [448,56]);
    elect_pRF_act = data_2fit(:,strcmp(electrodes.name, electrode)); % here used to be epochs(...),
    %but with data2fit we already have the normalized data the model got to
    %work with and display that as individual runs - plot_ind_trials got
    %adjusted for data2fit also
    elect_pRF_act = elect_pRF_act';
    %disp(size(elect_pRF_act))
    el_ind = find(strcmp(electrodes.name, electrode), 1, "first");
    
    %generate model ts and plot data and prediction
    modelts = generate_modelts(data2fit, stimulus, results, el_ind);
    plot_ind_trials(elect_pRF_act, events, elect, t, modelts, results, el_ind, [])
end

%% Saving plot to directory (Timeseries)
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';

file_name = {zeros(length(elect.Electrode), 1)};
for f = 1:length(elect.Electrode)
    file_name{f} = sprintf("%s_indivTrialModPred_Resp", elect.Electrode{f});
end
saveplots(saveDir, "modelPredTS_indivTrialResp", subject, file_name)

%% Plot model prediction vs AVG ts accross runs
for el = 1:length(elect.Electrode)    
    % select data for the specific electrode and pRF trials only
    electrode = elect.Electrode{el};
    elect_pRF_act = epochs(:,:,strcmp(electrodes.name, electrode));
    el_ind = find(strcmp(electrodes.name, electrode), 1, "first");
    if subject == "p01"
        elect_pRF_act = prep_data(convertCharsToStrings(subject), ...
            '~/Documents/ECoG_PRF_categories/data');
        events = elect_pRF_act{1}.events;
        elect_pRF_act = elect_pRF_act{1}.epochs_b(:,:, strcmp( ...
            electrodes.name, electrode));
    end
    
    %generate model ts and plot data and prediction
    modelts = generate_modelts(data2fit, stimulus, results, el_ind);
    plot_ind_trials(elect_pRF_act, events, elect, t, modelts, results, el_ind, true)
end
%% Saving plot to directory (Timeseries - AVG)
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';

file_name = {zeros(length(elect.Electrode), 1)};
for f = 1:length(elect.Electrode)
    file_name{f} = sprintf("%s_indivTrialModPred_Resp_AVG", elect.Electrode{f});
end
saveplots(saveDir, "modelPredTS_indivTrialResp_AVGrun_2", subject, file_name);
close all