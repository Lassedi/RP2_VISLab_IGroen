function cs_elect_resp(dataDir, thresh, subject, CI)
% Plots average acitivation accross trials for Face and Building/House
% stimuli along with the 95 Confidence interval if: true is passed to CI
% dataDir:  preprocessed ECoG data BIDS format
% thresh:   if 0 is passed no threshold is applied - otherwise average
%           activation lower than the threshold get excluded

if ~exist("CI", "var")
    CI = false;
end

% load data
loadName = fullfile(dataDir, sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);

%% Plot the average response per category 

% Find the events belonging to the spatial object task
trial_ind = ~contains(events.task_name, {'prf'});

% Find channels that show a good response to these trials:
% First, average across all trials in these runs
tmp = squeeze(mean(epochs(:,trial_ind,:),2));

if thresh ~= 0
% Then, select the channels that have a response increase greater than thresh
%thresh = 1;  % this means xfold increase relative prestimulus baseline, so 1 = 100% increase in signal
chan_ind1 = find(max(tmp) > thresh);
% Exclude the depth channels for now (include only surface channels)
chan_ind2 = find(contains(channels.type, 'ECOG'));
chan_ind = intersect(chan_ind1,chan_ind2);
chan_ind = array2table(chan_ind);
chan_ind(:,"subject") = {subject};
if height(chan_ind) == 0
    return
end 
else 
    %chan_ind = array2table(find(contains(channels.type, "ECOG")));
    chan_ind = array2table((1:size(channels,1))');
    chan_ind{:, "subject"} = {subject};
end



% Loop over channels, get TS per category per electrode
TS_matrix_h = [];
TS_matrix_f = [];

for cc = 1:height(chan_ind)
    
    chan = table2array(chan_ind(cc,1)); 
    trial_ind1 = contains(events.trial_name, ['BUILDINGS', "HOUSES"]);
    trial_ind2 = contains(events.trial_name, 'FACE');
    %trial_ind3 = contains(events.trial_name, 'LETTER')
    
    build_dist = epochs(:,trial_ind1,chan);
    face_dist = epochs(:,trial_ind2,chan);

    TS_matrix_h = cat(3,TS_matrix_h, build_dist);
    TS_matrix_f = cat(3,TS_matrix_f, face_dist);
end
TS_matrix = cat(4, TS_matrix_h, TS_matrix_f);

% plot the TS
plot_CatTS(TS_matrix, chan_ind, t, channels, subject, true, true)
end
