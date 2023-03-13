%% Load a dataset

% Note: you will need to update this path to where you copy the data
dataDir = '~/Documents/ECoG_PRF_categories/data';

% Pick a subject
subject = 'p01';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);
%% select data for the specific electrode and pRF trials only
electrode = "OT01";
elect_pRF_act = epochs(:,:,electrodes.name == electrode); 
%% Plot individual trials including blanks
modelts = generatemodelts( )
plot_ind_trials(elect_pRF_act, events, electrode, t, modelts)
%% Plot average over single trials not including blanks
figure();
hold on;

tile = tiledlayout(3,2);
tile.Title.String = sprintf("%s - Average response to individual pRF stimuli", electrode);
tile.TileSpacing = "tight";



%Vertical
nexttile
%prepare data
[xlabel, x_interval, data_RF] = prepare_rf_data(elect_pRF_act, "VERTICAL-L-R", events, t);

plot(data_RF, "LineWidth",1)

xticks(x_interval);
xticklabels(xlabel);
ax = gca();
ax.XLim = [0, length(data_RF)];



% Horizontal 
nexttile
[xlabel, x_interval, data_RF] = prepare_rf_data(elect_pRF_act, 'HORIZONTAL-U-D', events, t);

plot(data_RF, "LineWidth",1)

xticks(x_interval);
xticklabels(xlabel);
ax = gca();
ax.XLim = [0, length(data_RF)];



% Diagonal LU-RD
nexttile
[xlabel, x_interval, data_RF] = prepare_rf_data(elect_pRF_act, ...
    "DIAGONAL-LU-RD", events, t);

plot(data_RF, "LineWidth",1)

xticks(x_interval);
ax = gca();
ax.XLim = [0, length(data_RF)];
ax.XTickLabel = xlabel;


%Diagnoal RU-LD
nexttile
[xlabel, x_interval, data_RF] = prepare_rf_data(elect_pRF_act, ...
    "DIAGONAL-RU-LD" , events, t);

plot(data_RF, "LineWidth",1)

xticks(x_interval);
ax = gca();
ax.XLim = [0, length(data_RF)];
ax.XTickLabel = xlabel;



%Diagonal LD-RU
nexttile
[xlabel, x_interval, data_RF] = prepare_rf_data(elect_pRF_act, ...
    "DIAGONAL-LD-RU" , events, t);

plot(data_RF, "LineWidth",1)

xticks(x_interval);
ax = gca();
ax.XLim = [0, length(data_RF)];
ax.XTickLabel = xlabel;



%Diagnoal RD-LU
nexttile
[xlabel, x_interval, data_RF] = prepare_rf_data(elect_pRF_act, ...
    "DIAGONAL-RD-LU" , events, t);

plot(data_RF, "LineWidth",1)

xticks(x_interval);
ax = gca();
ax.XLim = [0, length(data_RF)];
ax.XTickLabel = xlabel;





