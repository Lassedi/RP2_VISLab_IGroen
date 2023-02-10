
tbUse ECoG_utils;

%% Load a dataset

% Note: you will need to update this path to where you copy the data
dataDir = '~/Documents/RP2/ECoG_PRF_categories/data/';

% Pick a subject
subject = 'p11';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);

%% Plot the patient's electrodes on the brain using code from the ECoG_utils repository

specs.plotmesh = 'auto';
specs.plotlabel = 'yes';
specs.plotelecrad = 2; % put to 2 for subjects p01 and p02, leave empty ([]) for other subjects
bidsEcogPlotElectrodesOnMesh(dataDir, subject, session, 'smry_wang15_mplbl',[],[],specs)

%% Plot the average response per category 

% Find the events belonging to the spatial object task
trial_ind = contains(events.task_name, {'spatialobject'});

% Find channels that show a good response to these trials:
% First, average across all trials in these runs
tmp = squeeze(mean(epochs(:,trial_ind,:),2));
% Then, select the channels that have a response increase greater than thresh
thresh = 2;  % this means xfold increase relative prestimulus baseline, so 1 = 100% increase in signal
chan_ind1 = find(max(tmp) > thresh);
% Exclude the depth channels for now (include only surface channels)
chan_ind2 = find(contains(channels.type, 'ECOG'));
chan_ind = intersect(chan_ind1,chan_ind2);

% Prepare the plot
nRows = ceil(sqrt(length(chan_ind)));
figure;hold on; 

% Loop over channels, plot one channel per subplot
for cc = 1:length(chan_ind)
    
    chan = chan_ind(cc); 
    trial_ind1 = contains(events.trial_name, 'HOUSE');
    trial_ind2 = contains(events.trial_name, 'FACE');
    trial_ind3 = contains(events.trial_name, 'LETTER');
    
    subplot(nRows,nRows,cc);hold on
    plot(t,mean(epochs(:,trial_ind1,chan),2), 'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind2,chan),2),'LineWidth', 2)
    plot(t,mean(epochs(:,trial_ind3,chan),2),'LineWidth', 2)
    if cc == 1
        legend('HOUSE', 'FACE', 'LETTER');
    end
    title(channels.name{chan});
    axis tight
end

%% To do @Lasse
%
% - Generate plots of the category trials for all subjects. Do you see any
% selective channels? Write down which ones.
%
% - Also look at the brain mesh with electrodes and see if you think the
% category-responses 'make sense': for exampe, do you see face-selective
% responses in the brain locations where you expect OFA to be, or OPA?
%
% - Play with the threshold for selecting channels (see line 24). What
% happens as you put it higher, or lower?
%
% - Try to adapt the code in order to plotting the PRF trials, instead of
% the category trials. What do these look like?
 



