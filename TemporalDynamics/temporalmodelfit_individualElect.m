
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

% get data
data_allPP = get_epochs_allPP(elect_selection, dataDir);

%% log mean weights of selected electrodes
meanWeights = zeros(2,55);
count = 0;

% select timeseries of a single electrode 
for pp = 1:size(data_allPP,1)
    dataTS = data_allPP(pp).Data;
    
    for el = 1:size(dataTS,3)
        count = count + 1;
        electrodeTS = dataTS(:,:,el);
        
        %% make a index for face & house trials
        events = data_allPP(pp).Events;
        face_ind = contains(events.trial_name, "FACES");
        house_ind = contains(events.trial_name, "HOUSES");

        if sum(house_ind) == 0 % for participants < 11 with different trial names
            house_ind = contains(events.trial_name, "BUILDINGS");
        end
        
        %% index face & house trials of the electrode
        facesData = electrodeTS(:,face_ind);
        housesData = electrodeTS(:,house_ind);
        
        %% take mean accross trials
        facesMeanTS = mean(facesData,2);
        housesMeanTS = mean(housesData,2);
        TS = {facesMeanTS,housesMeanTS};
        meanWeightsElect = [];
        
        for ts = 1:length(TS)
            % PREP data
            
            % Get relevant input parameters
            nTimePoints = size(facesData(:,1),1);
            epoch_t     = [-0.199 1]; % epoch time window
            srate       = 512;
            t           = epoch_t(1):1/srate:epoch_t(2);
            data        = TS{ts};
            data        = data./max(data,[], 1);
            
            
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
            
            % Set options for fitting
            options           = [];
            options.xvalmode  = 0; % to do cross-validation, we need multiple trials/conditions
            options.algorithm = 'bads';  % bads works the best in my experience, but it's a separate toolbox, not a built-in Matlab optimize
            options.display   = 'off';  % you can set this to 'final' or 'off' to see less outputs
            
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
            
            % save mean weights of house & face trials for electrode 
            MeanWeight = [results{:,2}];
            MeanWeight = mean(MeanWeight(1,:));
            
            meanWeightsElect = [meanWeightsElect; MeanWeight];
        end
        
        meanWeights(:,count) = meanWeightsElect;
    end
end

%% Plot barplot
% make trial type index
face_ind = [data_allPP.Selectivity];
face_ind = strcmp(face_ind, "FACES");
house_ind = ~face_ind;

% split mean weights into face & house selective electrodes
faceSelectElect = meanWeights(:,face_ind);
houseSelectElect = meanWeights(:,house_ind);

% make barplots
figure(); hold on;

bar([1,2], [mean(faceSelectElect(1,:)), mean(faceSelectElect(2,:))])
bar([3,4], [mean(houseSelectElect(1,:)), mean(houseSelectElect(2,:))])

% label axis
xticks([1,2,3,4]);
xticklabels(["Face-Trial", "House-Trial", "Face-Trial", "House-Trial"])  

legend(["Face-Selective", "House-Selective"])

title("Mean Transient Channel Weight per Trial-Type and Selectivity")

%% PLOT model and prediction
%load("2_TTCSTIG19_faceFit_fit4individualElect.mat") %!!!! comment out when
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