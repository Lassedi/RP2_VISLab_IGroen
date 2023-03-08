function [data] = RP2tde_computePRFtimecourses(data, time_win, normalizeEpochs)

cd /home/lasse/Documents/ECoG_PRF_categories/matlab_code/temporalECoG/

% Computes prf timecourses for data to be fitted with analyzePRF
% [data2fit] = tde_computePRFs(recomputeData, doPlots, saveDir, resultsStr) 
%
% <data> data struct computed by tde_getData.m
% <timeWin> time window over which to average the broadband timecourse to
%   get the PRF activity estimate for each bar position
%   default: [0.05 0.55];
% <doPlots> flag indicating whether to save out plots of data and
%   prfs to fullfile(analysisRootPath, 'figures', 'prfs')
%   default 'false
%
% 2020 Iris Groen

% <time_win>
if ~exist('time_win','var') || isempty(time_win)
    time_win  = [0.05 0.55];
end

% <normalize>
if ~exist('normalizeEpochs','var') || isempty(normalizeEpochs)
    normalizeEpochs = false;
end

% <doPlots>
if ~exist('doPlots','var') || isempty(doPlots)
    doPlots = false; % boolean
end

% <plotSaveDir>
if ~exist('plotSaveDir','var') || isempty(plotSaveDir)
    plotSaveDir = fullfile(analysisRootPath, 'figures', 'prfs');
end
if ~exist(plotSaveDir, 'dir'); mkdir(fullfile(plotSaveDir));end

% Compute PRF timecourses for each subject
nSubjects = length(data);

for ii = 1:nSubjects
    
    subject  = data{ii}.subject;
    t        = data{ii}.t;
    epochs   = data{ii}.epochs_b;
    disp(subject)
    % Determine which stimuli to select for the PRF timecourse
    switch subject
        %commeted out because missing trials were substituted by 0s -
        %because of error with reshape in line 91
        %{
        case 'p01' 
            % in this subject, trigger 41 was not sent because it was the
            % same as used for the blank (stimulus coding error).
            stimInx = setdiff(1:224, 41);
        %} 
        case 'p04'
            % In this subject, a different version of the PRF experiment
            % was run, with different apertures. Since this subject only
            % contributes a few channels, we'll skip their PRF analysis.
            continue
        case 'p05'
            % the first two prf runs in this subject are bad (broke
            % fixation), we will not analyze these
            start_ind = (size(epochs,2)/2)+1;
            epochs = epochs(:,start_ind:end,:); stimInx = 1:224;
        otherwise
            stimInx = 1:224;
    end
    
    % Determine number of runs and stimuli for this subject
    [~, nTrials, nChans] = size(epochs);
    nStim = length(stimInx);    
    nRuns = round(nTrials/nStim); 
       
    % Normalize epochs, within run?
    if normalizeEpochs
        run_indices = []; 
        for jj = 1:nRuns
            run_indices = [run_indices; ones(nStim,1)*jj];
        end
        [epochs] = ecog_normalizeEpochs(epochs, t, [], [], run_indices);
    end
    
    % Compute average broadband response in time window
    trials = squeeze(mean(epochs(t>time_win(1) & t<time_win(2),:,:),1)); 

    % Transpose to have channels in first dimension
    trials = trials';
    % Reshape to separate individual runs    
    ts = reshape(trials,[nChans nStim nRuns]);
    
    data{ii}.ts       = ts;
    data{ii}.stim_inx = stimInx;   
end
   