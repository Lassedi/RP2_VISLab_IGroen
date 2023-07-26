
load('Oc13.mat');
% if you have ToolboxToolbox set up correctly, this should load download all necessary toolboxes 
% and add them to your path:
tbUse temporalECoG; 
% If you need to add them manually you can find the relevant github links here: 
% https://github.com/WinawerLab/ToolboxRegistry/blob/master/configurations/temporalECoG.json

%% PREP data

% Get relevant input parameters
nTimePoints = size(Oc13,1);
epoch_t     = [-0.199 1]; % epoch time window
srate       = 512;
t           = epoch_t(1):1/srate:epoch_t(2);
data        = Oc13;

% Make stimulus timecourse
stim = zeros(nTimePoints,1);
stim(t>0 & t<=0.5) = 1;

%% FIT model

modelfuns = tde_modelTypes(); 
% this gives you a list of the model names available in the toolbox
% or you can look here: https://github.com/irisgroen/temporalECoG/tree/main/temporal_models

% specify the model you'd like to fit:
%objFunction = @TTCSTIG19; 
objFunction = @DN;

% Set options for fitting
options           = [];
options.xvalmode  = 0; % to do cross-validation, we need multiple trials/conditions
options.algorithm = 'bads';  % bads works the best in my experience, but it's a separate toolbox, not a built-in Matlab optimize
options.display   = 'iter';  % you can set this to 'final' or 'off' to see less outputs

% Fit model
[params, pred, pnames] = tde_fitModel(objFunction, stim, data, srate, options);

% Compute explained variance
rsq = computeR2(data,pred);

% Display model parameters and outputs
fprintf('%s%s%0.2f \n', func2str(objFunction), ' R2 = ', rsq);
for ii = 1:length(pnames)
    fprintf('%s%s%0.3f \n', pnames{ii}, ' = ', params(ii));
end

%% PLOT model and prediction

figure;hold on
plot(t,stim, 'k');
plot(t,data./max(data), 'r', 'LineWidth', 2);
plot(t,pred./max(pred), 'b', 'LineWidth', 2);

legend({'stimulus', 'data', func2str(objFunction)});
xlabel('Time (s)');
ylabel('Broadband power (normalized)');

title(sprintf('%s%s%0.2f', func2str(objFunction), 'Model R2 = ', rsq))

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
