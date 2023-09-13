% plot polar scatter plot based on electrode selection table (hypothesis_test folder) with
% information on visual angle, eccentricity and receptive field size of
% each category. Face selective & House selective electrodes will be
% separated and plotted in a different color.
% !!! Receptive field sizes are not absolut. The actual sizes of the
% recpetive fields should be larger. They are relatively correct, the
% conversion is not done properly for our usecase by polar scatter ie. they do not use
% visual degrees. The information is still there and visible. 

%% Helper functions
tbUse({'ECoG_utils' 'analyzePRF'})

get_utils()
%

%load final electrode selection & save directory
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';
dataDir = '/home/lasse/Documents/ECoG_PRF_categories';
addpath(genpath(dataDir))

%elect_prf = readtable("goodPRF_OS_elect.xls");
elect_prf = readtable("2_electSelection_final.xls");

% convert eccentricity to visual angle & use recpetive field area instead
% of the radius as size input to polarscatter (otherwise receptive field to
% small)
elect_prf.Eccentricity = elect_prf.Eccentricity .*0.166;
elect_prf.RFSize = ((elect_prf.RFSize).^2 * pi);

%% plot recptive field position & relative size per category on a polar plot
elect_prf.Col = (elect_prf.Selectivity == "FACES");
%

f = polarscatter(elect_prf.VAngle(~elect_prf.Col,:), elect_prf.Eccentricity(~elect_prf.Col), elect_prf.RFSize(~elect_prf.Col) ...
    , "filled", "MarkerFaceAlpha", 0.5);

hold on;
h = polarscatter(elect_prf.VAngle(elect_prf.Col,:), elect_prf.Eccentricity(elect_prf.Col), elect_prf.RFSize(elect_prf.Col), ...
    "filled", "MarkerFaceAlpha", 0.5);

hold off
legend("House-Selective", "Face-Selective")

%% save plot

fig_name = "1_polarReceptiveFieldPlot_perCat_relativeSizes";

saveplots(saveDir, "Report", "Part1_Hypothesis",fig_name, 1000)
clear fig_name
close all