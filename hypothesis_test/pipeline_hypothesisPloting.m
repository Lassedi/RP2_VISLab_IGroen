%load electrode table
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';
elect_table_ori = readtable(fullfile(dataDir,"1_electSelection_final.xls"));
loc_table = readtable(fullfile(dataDir, "1_locations_final_electrode_selection.xls"));
saveDir = dataDir;
%% calculate sumary stats per group 
elect_table = elect_table_ori(loc_table.HouVFa == 0 | loc_table.HouVFa == 1 | loc_table.oddCases == 1,:);
sumstats = grpstats(elect_table, "Selectivity",["mean", "std", "median"],"DataVars",["Eccentricity", "RFSize"]);

%% Plot Size - Boxplot
boxplot(elect_table.RFSize, elect_table.Selectivity)
text(1:2, sumstats.median_RFSize+1, string(round(sumstats.median_RFSize, 2)))
title("Size")
%% save - boxplot
file_name = "1_RFSize_final";
saveplots(saveDir, "hypo_plots", "Size_woOutliers", file_name)
close all
%% Barplot
% make a barplot
bar(1:2,sumstats.mean_RFSize);
ax = gca;
ax.XTickLabels = sumstats.Selectivity;
hold on

% add single datapoints ontop of the barplot - different arrays because
% different amount of datapoints
%ecc_l = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"RFSize"));
ecc_f = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"RFSize"));
ecc_h = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{2}), "RFSize"));

%plot(1, ecc_l, "ok")
plot(1, ecc_f, "ok")
plot(2, ecc_h, "ok")

%calculate and plot error bars (std error of the mean)
stderr = sumstats.std_RFSize ./ sqrt(sumstats.GroupCount);
er = errorbar(1:2, sumstats.mean_RFSize, stderr);
er.Color = [0,0,0];
er.LineStyle = "none";
er.LineWidth = 2;
title("Size")
hold off
%% save - barplot
file_name = "1_BarRFSize_final";
saveplots(saveDir, "hypo_plots", "Size_woOutliers", file_name)
close all
%% Plot Eccentricity - boxplot
boxplot(elect_table.Eccentricity, elect_table.Selectivity)
text(1:2, sort(sumstats.median_Eccentricity,"descend")+0.5,...
    string(round(sort(sumstats.median_Eccentricity,"descend"), 2)))
title("Eccentricity")
%% save - boxplot
file_name = "1_Eccentricity_final";
saveplots(saveDir, "hypo_plots", "Eccentricity_woOutliers", file_name)
close all
%% Barplot
% make a barplot
bar(sumstats.mean_Eccentricity);
ax = gca;
ax.XTickLabels = sumstats.Selectivity;
hold on

% add single datapoints ontop of the barplot
%ecc_l = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"Eccentricity"));
ecc_f = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"Eccentricity"));
ecc_h = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{2}), "Eccentricity"));

%plot(1, ecc_l, "ok")
plot(1, ecc_f, "ok")
plot(2, ecc_h, "ok")

%calculate and plot error bars (std error of the mean)
stderr = sumstats.std_Eccentricity ./ sqrt(sumstats.GroupCount);
er = errorbar(1:2, sumstats.mean_Eccentricity, stderr);
er.Color = [0,0,0];
er.LineStyle = "none";
er.LineWidth = 2;
title("Eccentricity")
hold off
%% save - barplot

file_name = "1_BarEccentricity_final";
saveplots(saveDir, "hypo_plots", "Eccentricity_woOutliers", file_name)
close all

