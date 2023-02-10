%% Load a dataset

% Note: you will need to update this path to where you copy the data
dataDir = '~/Documents/ECoG_PRF_categories/data';

% Pick a subject
subject = 'p05';
loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);
%% select data for the specific electrode and pRF trials only
electrode = "GB05";
elect_pRF_act = epochs(:,:,electrodes.name == electrode);

% Plot everything
figure();
hold on;

tile = tiledlayout(2,2);
tile.Title.String = sprintf("%s - Average response to individual pRF stimuli", electrode);
tile.TileSpacing = "tight";

%Vertical
nexttile
%prepare data
[xlabel, x_interval, data_VerLR] = prepare_rf_data(elect_pRF_act, "VERTICAL-L-R", events, t);

plot(data_VerLR, "LineWidth",1)

% xlabel_time = events.onset(trial_ind_VerLR) - events.onset(1); dont think
% i need this
xticks(x_interval);
xticklabels(xlabel);
ax = gca();
ax.XLim = [0, length(data_VerLR)];

%Diagonal 
nexttile
[xlabel, x_interval, data_VerLR] = prepare_rf_data(elect_pRF_act, ...
    ["DIAGONAL-LD-RU","DIAGONAL-RU-LD"] , events, t);

plot(data_VerLR, "LineWidth",1)

xticks(x_interval);
%xticklabels(xlabel);
xlabel = strtrim(sprintf('\\newline%s%s\\newline%s\n',xlabel{:}));
ax = gca();
ax.XLim = [0, length(data_VerLR)];
ax.XTickLabel = xlabel;


% Horizontal 
nexttile
[xlabel, x_interval, data_VerLR] = prepare_rf_data(elect_pRF_act, 'HORIZONTAL-U-D', events, t);

plot(data_VerLR, "LineWidth",1)

xticks(x_interval);
xticklabels(xlabel);
ax = gca();
ax.XLim = [0, length(data_VerLR)];

% Diagnal 2
nexttile
[xlabel, x_interval, data_VerLR] = prepare_rf_data(elect_pRF_act, ...
    ["DIAGONAL-LU-RD","DIAGONAL-RD-LU"] , events, t);

plot(data_VerLR, "LineWidth",1)

xticks(x_interval);
xlabel = sprintf('\\newline%s%s\\newline%s\n',xlabel{:});
ax = gca();
ax.XLim = [0, length(data_VerLR)];
ax.XTickLabel = xlabel;





