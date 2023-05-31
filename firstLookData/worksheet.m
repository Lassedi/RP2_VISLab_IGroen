%%
tbUse ECoG_utils;
% Load a dataset - 3Dbrain

%% Note: you will need to update this path to where you copy the data
dataDir = '~/Documents/ECoG_PRF_categories/data_A';

% Pick a subject
subject = 'p10';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);

%% Plot the patient's electrodes on the brain using code from the ECoG_utils repository
specs.plotmesh = 'auto';
specs.plotlabel = 'yes';
specs.plotelecrad = []; % put to 2 for subjects p01 and p02, leave empty ([]) for other subjects
bidsEcogPlotElectrodesOnMesh(dataDir, subject, session, 'smry_wang15_mplbl',[], [],specs)

%% Find all channels above a certain threshold for all subjects and plot the
%epoch values
%close all
dataDir = '~/Documents/ECoG_PRF_categories/data_A/data_light';
%dataDir = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
thresh = 0;
%["p01", "p02", "p05", "p06","p07", "p08", "p09",
for sub = ["p14"];%, "p11", "p12", "p13", "p14"]
    cs_elect_resp(dataDir,thresh,sub, true)
end
%%
close all
thresh = 1;

for sub = ["p01", "p02", "p05", "p06", "p07", "p08", "p09", "p10", "p11"]
    plot_prf_elect(sub,thresh)
end

%% Save all figures produced into a pdf in current wd
plotDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/firstObjSelctElect/data_A';
if ~exist("plotDir", "dir")
    mkdir(plotDir);
end
for fig_count = 1:length(findobj('type','figure'))
    set(figure(fig_count), 'Position', get(0, 'Screensize'));
    exportgraphics(figure(fig_count), fullfile(plotDir,sprintf('%s_CIthresh_%i.pdf', sub, thresh)), 'Append', true)
    close
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
 


