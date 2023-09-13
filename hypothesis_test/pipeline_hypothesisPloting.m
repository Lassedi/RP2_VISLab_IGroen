%load electrode table
get_utils()


dataDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';

elect_table_ori = readtable(fullfile(dataDir,"2_electSelection_final.xls")); %2_electSelection_final.xls = mean(ecc & size & ang); 
% results struct has 2 values for each parameter (2fits because of xval) in this electrode selection it is the mean of both values 
% - 1st version only uses the first value of the first fit; the change does
% not seem to change much

loc_table = readtable(fullfile(dataDir, "1_locations_final_electrode_selection.xls")); % no location table for the second electSelection yet 
% - to control if the pattern changes if EVC is excluded

saveDir = dataDir;
%% calculate sumary stats per group 

%exclude EVC
%elect_table = elect_table_ori(loc_table.HouVFa == 0 | loc_table.HouVFa == 1 | loc_table.oddCases == 1,:);
elect_table = elect_table_ori;

%calculate summary stats
sumstats = grpstats(elect_table, "Selectivity",["mean", "std", "median"],"DataVars",["Eccentricity", "RFSize"]);

%% Plot Size - Boxplot
f = figure(); hold on;
boxplot(elect_table.RFSize, elect_table.Selectivity);
title("Size")
text(1:2, sumstats.median_RFSize+1, string(round(sumstats.median_RFSize, 2)))
hold off
%% save - boxplot
file_name = "1_RFSize_final";
saveplots(saveDir, "hypo_plots", "Size_woOutliers", file_name)
close all
%% Barplot
f = figure(); hold on;
% make a barplot
c = bar(1:2,sumstats.mean_RFSize);

% add single datapoints ontop of the barplot - different arrays because
% different amount of datapoints
%ecc_l = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"RFSize"));
ecc_f = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"RFSize"));
ecc_h = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{2}), "RFSize"));

%plot(1, ecc_l, "ok")
a = swarmchart(ones(1, size(ecc_f, 1)), ecc_f', "filled", "MarkerFaceAlpha",0.5);
b = swarmchart(2*ones(1, size(ecc_h, 1)), ecc_h', "filled", "MarkerFaceAlpha",0.5);

a.XJitterWidth = 0.3;
b.XJitterWidth = 0.3;
c.FaceColor = "flat";
c.FaceAlpha = 0.7;

%calculate and plot error bars (std error of the mean)
stderr = sumstats.std_RFSize ./ sqrt(sumstats.GroupCount);
er = errorbar(1:2, sumstats.mean_RFSize, stderr);
er.Color = [0,0,0];
er.LineStyle = "none";
er.LineWidth = 1;
title("Size")
pubgraph(f, 10, 0.5, "w", false)
xticks(1:2)
ax = gca;
ax.XTickLabels = sumstats.Selectivity;
hold off
%% save - barplot
file_name = "1_BarRFSize_AllFinal_midtermHD";
saveplots(saveDir, "hypo_plots", "Size_woOutliers", file_name, true)
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
f = figure(); hold on;
c = bar(sumstats.mean_Eccentricity);


% add single datapoints ontop of the barplot
%ecc_l = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"Eccentricity"));
ecc_f = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{1}),"Eccentricity"));
ecc_h = table2array(elect_table(strcmp(elect_table.Selectivity, sumstats.Selectivity{2}), "Eccentricity"));

%plot(1, ecc_l, "ok")
a = swarmchart(ones(1, size(ecc_f, 1)), ecc_f', "filled", "MarkerFaceAlpha",0.5);
b = swarmchart(2*ones(1, size(ecc_h,1)), ecc_h', "filled", "MarkerFaceAlpha",0.5);

a.XJitterWidth = 0.3;
b.XJitterWidth = 0.3;

%calculate and plot error bars (std error of the mean)
stderr = sumstats.std_Eccentricity ./ sqrt(sumstats.GroupCount);
er = errorbar(1:2, sumstats.mean_Eccentricity, stderr);
er.Color = [0,0,0];
er.LineStyle = "none";
er.LineWidth = 2;
title("Eccentricity")

pubgraph(f, 10, 0.5,"w", false)

xticks(1:2)
ax = gca;
ax.XTickLabels = sumstats.Selectivity;
hold off
%% save - barplot

file_name = "1_BarEccentricity_AllFinal_midterm";
saveplots(saveDir, "hypo_plots", "Eccentricity_woOutliers", file_name, true)
close all

