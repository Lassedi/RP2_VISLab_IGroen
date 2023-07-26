%% Category selectivity pipeline
% specify paths for data and prf results
dataDir = '~/Documents/ECoG_PRF_categories/data_A';
% prfFitPath =
% '~/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/analysis/prfs';
% ^old
%prfFitPath = '/home/lasse/Documents/ECoG_PRF_categories/data/prf_fits/prf_woNorm_datalight';
prfFitPath = '/home/lasse/Documents/ECoG_PRF_categories/data_A/prf_fits/prf_woNorm_dataA';

addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories/matlab_code'))
%% create subject list to loop over
sub_list = ["p01", "p02", "p05", "p06", "p07", "p08", "p09", "p10", "p11", "p12", "p13", "p14"];

% initiate a table to store all electrode matches
CS_tbl = cell(0,7);

% define thresholds for d' and mean-xR2
cs_thresh = 0.5;
acti_thresh = 1;
prf_thresh = 10; %min(mean(results.xR2)); % if you want to get all values
stim = ["FACES", "HOUSES", "BUILDINGS"];

for sub = 1:length(sub_list)
    % Pick a subject & load data, prf-results
    subject = sub_list(sub);
    %loadName = fullfile(dataDir, sprintf('sub-%s_prfcatdata.mat', subject));
    loadName = fullfile(dataDir, "derivatives", "ECoGPreprocessed",...
        sprintf('sub-%s_prfcatdata.mat', subject));
    load(loadName);
    
    % load PRF results and calculate mean R2 crossvalidation
    load(sprintf("%s/sub-%s_prffits.mat", prfFitPath, subject));
    xR2 = mean(results.xR2, 2);
    
        
    %loop over all channels
    for el = 1:size(channels,1)
        %loop over categories & make a bool index & add it to event_idx
        event_idx = cell(length(stim),1);
        epochs_el = epochs(:,~contains(events.task_name, "prf"),el);
        events_cs = events(~contains(events.task_name, "prf"), :);

        for s = 1:length(stim)
            event_idx{s} = contains(events_cs.trial_name, stim(s));
        end
        event_idx{2} = event_idx{2} + event_idx{3};
        event_idx = event_idx(1:2);

        % calculate d_prime for each category
        dp = category_selectivity_d_prime(epochs_el, event_idx, t>0 & t<0.85); %t==t); for whole time window
        
        % calculate mean trial activation for selective category
        if find(dp == max(dp)) == 2 && any(strcmp(subject, ["p12", "p13", "p14"]))
            mt_ind = contains(events_cs.trial_name,stim(3));
        else
            mt_ind = contains(events_cs.trial_name,stim(dp == max(dp)));
        end
        mean_trial_act = mean(epochs_el(:,mt_ind), 2);
           
        % add a new row with all info to CS_tbl if over threshhold
        if max(dp) >= cs_thresh && xR2(el) > prf_thresh && acti_thresh<...
                max(mean_trial_act)-mean(mean_trial_act(t<0))
            newrow = {channels.name(el), dp(1),dp(2),...
                stim(arrayfun(@(x)isequal(x,max(dp)),dp)), {subject},...
                xR2(el), results.xval(el)};
            CS_tbl = vertcat(CS_tbl, newrow);  
        end
    end
end

% convert to table and name columns
CS_tbl = cell2table(CS_tbl);
CS_tbl.Properties.VariableNames = ["Electrode", stim(1), stim(2),...
 "Selectivity", "Participant", "Mean-xR2", "xval"];

%% save resulting table
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';

writetable(CS_tbl, fullfile(saveDir, "WoNorm_HoFa_goodPRF" + ...
    "_OS_CS>05_xr2>10_act>1.xls"))

%% get list of d' only
% create subject list to loop over
sub_list = ["p13"];%, "p02", "p05", "p06", "p07", "p08", "p09", "p10", "p11", "p12", "p13", "p14"];

% initiate a table to store all electrode matches
CS_tbl = cell(0,6);

% define thresholds for d'
cs_thresh = 0.5;
acti_thresh = 1;

for sub = 1:length(sub_list)
    % Pick a subject & load data, prf-results
    subject = sub_list(sub);
    %loadName = fullfile(dataDir, sprintf('sub-%s_prfcatdata.mat', subject));
    loadName = fullfile(dataDir, "derivatives", "ECoGPreprocessed",...
    sprintf('sub-%s_prfcatdata.mat', subject));

    load(loadName);
   
    
    stim = ["FACE", "HOUSES", "BUILDINGS"];
        
    %loop over all channels
    for el = 1:size(channels,1)
        %loop over categories & make a bool index & add it to event_idx
        event_idx = cell(length(stim),1);
        epochs_el = epochs(:,~contains(events.task_name,"prf"),el);
        events_cs = events(~contains(events.task_name, "prf"), :);
    
        for s = 1:length(stim)
            event_idx{s} = contains(events_cs.trial_name, stim(s));
        end
        event_idx{2} = event_idx{2} + event_idx{3};
        event_idx = event_idx(1:2);

        % calculate d_prime for each category
        dp = category_selectivity_d_prime(epochs_el, event_idx, t>0 & t<0.85);
        
        % calculate mean trial activation for selective category
        if find(dp == max(dp)) == 2 && any(strcmp(subject, ["p12", "p13", "p14"]))
            mt_ind = contains(events_cs.trial_name,stim(3));
        else
            mt_ind = contains(events_cs.trial_name,stim(dp == max(dp)));
        end
        mean_trial_act = mean(epochs_el(:,mt_ind), 2);
        
        % add a new row with all info to CS_tbl if over threshhold
        if max(dp)>= cs_thresh && acti_thresh<...
                max(mean_trial_act)-mean(mean_trial_act(t<0))
            newrow = {channels.name(el), dp(1),dp(2),...
                stim(arrayfun(@(x)isequal(x,max(dp)),dp)), {subject}};
            CS_tbl = vertcat(CS_tbl, newrow);  
        end
    end
end

% convert to table and name columns
CS_tbl = cell2table(CS_tbl);
CS_tbl.Properties.VariableNames = ["Electrode", stim(1), stim(2),...
    "Selectivity", "Participant"];
