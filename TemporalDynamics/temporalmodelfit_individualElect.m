
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
overall_results = [];

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
            
            % append results
            overall_results = [overall_results;results];
            
            % save mean weights of house & face trials for electrode 
            MeanWeight = [results{:,2}];
            MeanWeight = mean(MeanWeight(1,:));
            
            meanWeightsElect = [meanWeightsElect; MeanWeight];
        end
        
        meanWeights(:,count) = meanWeightsElect;
    end
end
%% make weight parameter distribution table
%make Index for face and house trials
facesTrialsInd = logical(repmat([1,0],[1,55])');
housestrialsInd = ~facesTrialsInd; 

%make index for face and house selective electrodes
faSelectiveInd = strcmp([data_allPP.Selectivity], "FACES");
hoSelectiveInd = ~faSelectiveInd;

%use both index to create a structure saving weight parameter distributions
faParameterTable = [overall_results{facesTrialsInd, 2}];
hoParameterTable = [overall_results{housestrialsInd, 2}];

weight.faSel_FaTrials = faParameterTable(1,faSelectiveInd);
weight.faSel_HoTrials = hoParameterTable(1,faSelectiveInd);
weight.hoSel_FaTrials = faParameterTable(1,hoSelectiveInd);
weight.hoSel_HoTRials = hoParameterTable(1,hoSelectiveInd);



%% Plot barplot
% make trial type index
face_ind = [data_allPP.Selectivity];
face_ind = strcmp(face_ind, "FACES");
house_ind = ~face_ind;

% split mean weights into face & house selective electrodes
faceSelectElect = meanWeights(:,face_ind);
houseSelectElect = meanWeights(:,house_ind);

% make barplots
f = figure(); hold on;

b1 = bar([1,2], [mean(faceSelectElect(1,:)), mean(faceSelectElect(2,:))]);
b2 = bar([3,4], [mean(houseSelectElect(1,:)), mean(houseSelectElect(2,:))]);

c1 = [0 0.4470 0.7410];

s1 = swarmchart(ones(size(weight.faSel_FaTrials,2)), weight.faSel_FaTrials, ...
    [], c1, "filled", "MarkerFaceAlpha",0.5);
s2 = swarmchart(2*ones(size(weight.faSel_HoTrials,2)), weight.faSel_HoTrials, ...
    [], c1, "filled", "MarkerFaceAlpha",0.5);
s3 = swarmchart(3*ones(size(weight.hoSel_FaTrials,2)), weight.hoSel_FaTrials, ...
    "filled", "MarkerFaceAlpha",0.5);
s4 = swarmchart(4*ones(size(weight.hoSel_HoTRials,2)), weight.hoSel_HoTRials, ...
    "filled", "MarkerFaceAlpha",0.5);

% standard error
plot_std_error(weight)

% adjust graph
b1.FaceColor = "flat";
b1.FaceAlpha = 0.7;
b2.FaceColor = "flat";
b2.FaceAlpha = 0.7;

[s1.XJitterWidth] = deal(0.3);
[s2.XJitterWidth] = deal(0.3);
[s3.XJitterWidth] = deal(0.3);
[s4.XJitterWidth] = deal(0.3);

% label axis
xticks([1,2,3,4]);
xticklabels(["Face-Trial", "House-Trial", "Face-Trial", "House-Trial"])  

legend(["Face-Selective", "House-Selective"])

title("Mean Transient Channel Weight per Trial-Type and Selectivity")

%make it pretty
pubgraph(f, 10, 0.5, "w", false)

%% save - barplot
file_name = "1_BarMeanWeightTrans_FaHoSplit_HD_2";
saveplots(saveDir, "Temporal_Dynamics", "TempModels_TTC19", file_name, 1000)
close all

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