
%load('Oc13.mat');
% if you have ToolboxToolbox set up correctly, this should load download all necessary toolboxes 
% and add them to your path:
tbUse temporalECoG; 
% If you need to add them manually you can find the relevant github links here: 
% https://github.com/WinawerLab/ToolboxRegistry/blob/master/configurations/temporalECoG.json


get_utils();
%
elect_selectionDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';
elect_selection = readtable(fullfile(elect_selectionDir,"1_electSelection_final.xls"));
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/data_A/derivatives/ECoGPreprocessed';
saveDir = elect_selectionDir;

%% get data
data_allPP = get_epochs_allPP(elect_selection, dataDir);


% Average Time to Peak per electrode for across trials to corresponding selectivity
data_allPP = get_averageCSTS(data_allPP, elect_selection, true);

f_TS = [data_allPP.Face_Selective];
h_TS = [data_allPP.House_Selective];

%% PREP data

% Get relevant input parameters
nTimePoints = size(f_TS(:,1),1);
epoch_t     = [-0.199 1]; % epoch time window
srate       = 512;
t           = epoch_t(1):1/srate:epoch_t(2);
data        = f_TS;
%data        = data./max(data,[], 1);


% Make stimulus timecourse
stim = zeros(nTimePoints,1);
stim(t>0 & t<=0.5) = 1;
stim      = repmat(stim, 1, size(data, 2));

% FIT model

modelfuns = tde_modelTypes(); 
% this gives you a list of the model names available in the toolbox
% or you can look here: https://github.com/irisgroen/temporalECoG/tree/main/temporal_models

% specify the model you'd like to fit:
objFunction = @TTCSTIG19; 
%objFunction = @DN;

%% Set options for fitting
options           = [];
options.xvalmode  = 0; % to do cross-validation, we need multiple trials/conditions
options.algorithm = 'bads';  % bads works the best in my experience, but it's a separate toolbox, not a built-in Matlab optimize
options.display   = 'iter';  % you can set this to 'final' or 'off' to see less outputs

% Fit model
results = {};
for elect=1:size(data,2)
    [params, pred, pnames] = tde_fitModel(objFunction, stim, data(:,elect), srate, options);
    % Compute explained variance
    rsq = computeR2(data(:,elect),pred);
    
    % Display model parameters and outputs
    fprintf('%s%s%0.2f \n', func2str(objFunction), ' R2 = ', rsq);
    for ii = 1:length(pnames)
        fprintf('%s%s%0.3f \n', pnames{ii}, ' = ', params(ii));
    end
    
    % save results
    results = [results; [rsq, params, pred, {pnames}]];
end

%% PLOT model and prediction
%load("TempFits/3_TTCSTIG19_houseFit_fit4individualElect.mat") %!!!! comment out when
%plotting new fit


%data_n = data./max(data,[], 1);
%pred_i = pred./max(pred,[], 1);
data_n = data;
pred_i = [results(:,3)]'; %pred;
rsq = [results(:,1)];

figure(); hold on;
count = 0;
for n_elect = 1:size(data,2)
    count = count + 1;
    subplot(round(sqrt(size(data,2))), ceil(sqrt(size(data,2))), n_elect); hold on;

    plot(t,stim, 'k');
    plot(t,data_n(:,n_elect), 'r', 'LineWidth', 2);
    plot(t,pred_i{:,n_elect}, 'b', 'LineWidth', 2);
    
    xlabel('Time (s)'); 
    %if ceil(sqrt(size(data,2))) < count
    %    ylabel('Broadband power (normalized)');
    %    count = 0;
    %end
    
    title(sprintf('%s%s%0.2f', func2str(objFunction), 'Model R2 = ', rsq{n_elect}))
end


legend({'stimulus', 'data', func2str(objFunction)});

%% save params

save("3_TTCSTIG19_houseFit_fit4individualElect.mat", "data", "results", "t", "stim", "objFunction")


%% plot bar plot - get the data
load("TempFits/3_TTCSTIG19_houseFit_fit4individualElect.mat") % load face or house fit
parameter_table = [results{:,2}];

% Make structure containing parameter distributions for face and house fit
%weight.Faces = parameter_table(1,:); % take the array of weights for the transient channel for each electrode
weight.Houses = parameter_table(1,:);
%% make the bar plot
f = figure(); hold on;

face_mean = mean(weight.Faces);
house_mean = mean(weight.Houses);

b = bar([1,2], [face_mean, house_mean]);
s1 = swarmchart(ones(size(weight.Faces,2)), weight.Faces, "filled", "MarkerFaceAlpha",0.5);
s2 = swarmchart(2*ones(size(weight.Houses,2)), weight.Houses, "filled", "MarkerFaceAlpha",0.5);

[s1.XJitterWidth] = deal(0.3);
[s2.XJitterWidth] = deal(0.3);

%standarderror
plot_std_error(weight)

b.FaceColor = "flat";
b.FaceAlpha = 0.7;

xticks([1,2])
xticklabels(["Faces", "Houses"])
title("Mean Weight on Transient Channel")

%make it pretty
pubgraph(f, 10, 0.5, "w", false)

%% save - barplot
file_name = "1_BarMeanWeightTrans_HD";
saveplots(saveDir, "Temporal_Dynamics", "TempModels_TTC19", file_name, 1000)
close all

%% Next steps:
% 1. Decide what we want to fit the model on (face/house trials or pRF
% trials?)
%
% 2. Identify relevant temporal parameters in the models:
% TTC and TTCSTIG17 models: weight transient vs. sustained
% --> simple models to interpret, but fits are not so good
% TTCSTIG19: 
% --> also has weight parameter, but also other fitted params
% DN: 
% --> does not have sustained vs transient channel but we could look at
% tau1 and tau2 parameters, tau1 captures width of onset transient, tau2
% rate of decay response decay (so a bit similar to time-to-peak and
%
% 3. Figure out how to do cross-validation (separate trials, separate halfs
% of data?) 
