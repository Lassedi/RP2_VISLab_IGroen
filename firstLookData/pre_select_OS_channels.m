% load participant data
subject = "p01";
dataDir = '~/Documents/ECoG_PRF_categories/data_A';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);

% Find the events belonging to the spatial object task
thresh = 0.5;

face_ind = contains(events.trial_name, "FACE");
building_ind = contains(events.trial_name, ["BUILDING", "HOUSE"]);


% Find channels that show a good response to these trials:
% First, average across all trials in these runs
tmp_f = squeeze(mean(epochs(:,face_ind,:),2));
tmp_b = squeeze(mean(epochs(:,building_ind,:),2));


% Then, select the channels that have a response increase greater than thresh
%thresh = 1;  % this means xfold increase relative prestimulus baseline, so 1 = 100% increase in signal
chan_indf = find(max(tmp_f) > thresh);
chan_indb = find(max(tmp_b) > thresh);
chan_ind = union(chan_indb, chan_indf);


% selecting the data and saving it to save directory
epochs = epochs(:,:,chan_ind);
channels = channels(chan_ind, :);
electrodes = electrodes(chan_ind,:);
save(fullfile(dataDir, "data_light", sprintf('sub-%s_prfcatdata.mat', subject)),...
    "epochs", "events", "channels", "t", "electrodes", "projectDir", "session", "subject")

