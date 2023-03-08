%%
tbUse ECoG_utils;
% Load a dataset - 3Dbrain

% Note: you will need to update this path to where you copy the data
dataDir = '~/Documents/ECoG_PRF_categories/data';

%% Pick a subject
subject = 'p05';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);

% Plot the patient's electrodes on the brain using code from the ECoG_utils repository
specs.plotmesh = 'auto';
specs.plotlabel = 'yes';
specs.plotelecrad = []; % put to 2 for subjects p01 and p02, leave empty ([]) for other subjects
bidsEcogPlotElectrodesOnMesh(dataDir, subject, session, 'wang15_mplbl',[], [],specs)

%% Find all channels above a certain threshold for all subjects and plot the
%epoch values
close all
thresh = 1;
chan_ind = cell(0,2);
chan_ind = cell2table(chan_ind);
chan_ind.Properties.VariableNames = ["chan_ind" "subject"];
for sub = ["p01", "p02", "p05", "p06", "p07", "p08", "p09", "p10", "p11"]
    os_elect_resp(thresh,sub)
end

%% prf plots
cd '/home/lasse/Documents/RP2/ECoG_PRF_categories/matlab_code/firstLookData'
thresh = 1;

for sub = ["p01", "p02", "p05", "p06", "p07", "p08", "p09", "p10", "p11"]
    plot_prf_elect(sub, thresh)
end

%% Save all figures produced into a pdf in current wd
path = '/home/lasse/Documents/RP2/ECoG_PRF_categories/Plots/firstPrfLook/';
for fig_count = 1:length(findobj('type','figure'))
    exportgraphics(figure(fig_count), sprintf('%sthresh_%i.pdf',path, thresh), 'Append', true)
end
close all

%%
cd '/home/lasse/Documents/RP2/ECoG_PRF_categories/Plots/firstPrfLook'
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
 


