function os_elect_resp(thresh, subject)


%% Load a dataset

% Note: you will need to update this path to where you copy the data
dataDir = '~/Documents/ECoG_PRF_categories/data';

% Pick a subject
%subject = 'p05';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);

%% Plot the average response per category 

% Find the events belonging to the spatial object task
trial_ind = contains(events.task_name, {'spatialobject'});
%%
% Find channels that show a good response to these trials:
% First, average across all trials in these runs
tmp = squeeze(mean(epochs(:,trial_ind,:),2));
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

%%
% Prepare the plot

figure("Visible","off");hold on;

%count loop iterations
counter = 1;

% Loop over channels, plot one channel per subplot
for cc = 1:height(chan_ind)
    
    if counter > 4
        counter = 1;
        figure("Visible","off");hold on;
    end
    chan = table2array(chan_ind(cc,1)); 
    trial_ind1 = contains(events.trial_name, 'HOUSE');
    trial_ind2 = contains(events.trial_name, 'FACE');
    trial_ind3 = contains(events.trial_name, 'LETTER');
     
    subplot(2,2,counter); hold on
    plot(t,mean(epochs(:,trial_ind1,chan),2), 'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind2,chan),2),'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind3,chan),2),'LineWidth', 2)
    if cc == 1
        legend('HOUSE', 'FACE', 'LETTER');
    end
    title(sprintf('%s %s',channels.name{chan}, subject));
    axis tight
    counter = counter + 1;
end
end
