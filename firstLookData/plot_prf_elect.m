function plot_prf_elect(subject, thresh)
%% Load a dataset

% Note: you will need to update this path to where you store the data
dataDir = '~/Documents/ECoG_PRF_categories/data';

% Pick a subject
%subject = 'p05';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);
%% Plot the average response per category 

% Find the events belonging to the prf task
trial_ind = contains(events.task_name, {'prf'});
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

%n plots
sprintf("%s Number of Plots: %i",subject, length(chan_ind))

%removed code here
if isempty(chan_ind)
    return
end 

%%
% Prepare the plot

figure("Visible","off");
hold on;

%count loop iterations
counter = 1;

%function handle to get names of unqiue pRF trial names
unique_prf = @(str)str(1:end-2);


% Loop over channels, plot one channel per subplot
for cc = 1:length(chan_ind)
    
    if counter > 2
        counter = 1;
        figure("Visible","off");hold on;
    end
    chan = chan_ind(cc,1); 
    trial_ind_VerLR = contains(events.trial_name, unique_prf(events.trial_name{1}));
    trial_ind_DiaRdLu = contains(events.trial_name, unique_prf(events.trial_name{30}));
    trial_ind_HorUD = contains(events.trial_name, unique_prf(events.trial_name{58}));
    trial_ind_DiaLdRu = contains(events.trial_name, unique_prf(events.trial_name{86}));
    trial_ind_DiaLuRd = contains(events.trial_name, unique_prf(events.trial_name{142}));
    trial_ind_DiaRuLd = contains(events.trial_name, unique_prf(events.trial_name{199}));

    subplot(2,1,counter); hold on
    plot(t,mean(epochs(:,trial_ind_VerLR,chan),2),'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind_HorUD,chan),2),'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind_DiaRuLd,chan),2), 'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind_DiaLdRu,chan),2),'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind_DiaLuRd,chan),2),'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind_DiaRdLu,chan),2),'LineWidth', 2)
    
    if rem(cc,4) == 1
        legend(unique_prf(events.trial_name{1}), ...
            unique_prf(events.trial_name{58}),...
            unique_prf(events.trial_name{199}),...
            unique_prf(events.trial_name{86}),...
            unique_prf(events.trial_name{142}),...
            unique_prf(events.trial_name{30}));
    end
    title(sprintf('%s %s',channels.name{chan}, subject));
    axis tight
    counter = counter + 1;
end
end