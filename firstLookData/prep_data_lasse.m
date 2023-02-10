%tbUse temporalECoG;

subjectList = {'p01', 'p02', 'p05', 'p06', 'p07', 'p08', 'p09', 'p10', 'p11'};
% p03 doesn't have PRF data
% p04 had different PRF data paradigm
% not yet excluded: first two runs of p05 (do this during prf fitting) 
srate             = 512;

for s = 1:length(subjectList)
       
    projectDir        = '/Users/iiagroen/surfdrive/BAIR/BIDS/visual_ecog_recoded';
    subject = subjectList{s};
    session           = [];
    task              = {'prf', 'spatialobject'};
    runnums           = [];

    % load broadband data
    inputFolder       = 'ECoGBroadband';
    description       = 'broadband';
    dataPath          = fullfile(projectDir, 'derivatives', inputFolder);   
    [data, channels, events] = bidsEcogGetPreprocData(dataPath, subject, session, task, runnums, description, srate); 

    % match electrodes to visual areas
    atlasName         = {'benson14_varea', 'wang15_mplbl'};
    electrodes        = bidsEcogMatchElectrodesToAtlas(projectDir, subject, [], atlasName);

     % SHIFT the UMCU data 
    if contains(subject, {'p01', 'p02'}) 
        fprintf('This is a umcu patient. Shifting onsets \n');
        % Shift onsets
        shiftInSeconds = 0.072; % 72 ms; determined through cross correlation, see s_determineOnsetShiftUMCUvsNYU.m
        events.onset = events.onset + shiftInSeconds;
    end

    % make epochs
    epoch_t           = [-0.199 1]; % epoch time window
    [epochs, t]       = ecog_makeEpochs(data, events.onset, epoch_t, channels.sampling_frequency(1));  

    % normalize epochs to prestim baseline
    [epochs]          = ecog_normalizeEpochs(epochs, t, [], 'percentsignalchange');

    % save out data
    saveDir           = fullfile(projectDir, 'derivatives', 'ECoGPreprocessed');
    saveName          = fullfile(saveDir, sprintf('sub-%s_prfcatdata.mat', subject));
    save(saveName, 'channels', 'electrodes', 'events', 'epochs', 't', 'subject','session', 'projectDir', '-v7.3');
end

