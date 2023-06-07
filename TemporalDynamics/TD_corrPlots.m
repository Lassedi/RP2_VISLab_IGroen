% Correlation plots 
get_utils()
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/data_A/derivatives/ECoGPreprocessed';
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';

load(fullfile(dataDir, "processed_final_select_DS.mat"))
%% Create the variables
selInd = [epochs_acrossSubs.Selectivity]';

ecc = [epochs_acrossSubs.Eccentricity];
ecc_f = ecc(selInd == "FACES");
ecc_h = ecc(selInd == "HOUSES");
ecc = [ecc_f, ecc_h];

RFS = [epochs_acrossSubs.RFSize];
RFS_f = RFS(selInd == "FACES");
RFS_h = RFS(selInd == "HOUSES");
RFS = [RFS_f, RFS_h];

Ttp = [epochs_acrossSubs.TtP_faces, epochs_acrossSubs.TtP_houses];
norm_StimOffResp = [epochs_acrossSubs.StimOffset_resp_faces, epochs_acrossSubs.StimOffset_resp_houses];

%% plot the scatterplots
a = figure(); hold on;
gscatter(ecc,Ttp, sort(selInd));
%lsline(gca) % get regression line per group 
%coef = polyfit(ecc,Ttp, 1);
%refline(coef(1), coef(2)); % regression line overall group
pubgraph(a, 10, 0.5,"w", true)
hold off;

a = figure(); hold on;
gscatter(RFS, Ttp, sort(selInd));
%lsline(gca)
pubgraph(a, 10, 0.5,"w", true)
hold off;

a = figure(); hold on;
gscatter(ecc, norm_StimOffResp, sort(selInd));
%lsline(gca)
pubgraph(a, 10, 0.5,"w", true);
hold off;

a = figure(); hold on;
gscatter(RFS, norm_StimOffResp, sort(selInd));
%lsline(gca)
pubgraph(a, 10, 0.5,"w", true)
hold off;

%% save plots 
fig_names = ["Ttp_Ecc", "Ttp_RFS", "StimOffResp_Ecc", "StimOffResp_RFS"];
saveplots(saveDir, "Temporal_Dynamics", "CorrelationPlots", fig_names, true)

close all