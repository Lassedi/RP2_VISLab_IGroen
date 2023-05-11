%load electrode table
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';
elect_table = readtable(fullfile(dataDir,"1_electSelection_final.xls"));

%% Wilcoxon rank sum test
% Receptive Field Size
RFSize_house = elect_table.RFSize(strcmp(elect_table.Selectivity, "HOUSES"));
RFSize_face = elect_table.RFSize(strcmp(elect_table.Selectivity, "FACES"));

p_SizeRS = ranksum(RFSize_face, RFSize_house);

% Eccentricity
Ecc_house = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "HOUSES"));
Ecc_face = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "FACES"));

p_EccRS = ranksum(Ecc_face, Ecc_house);

%% Permutation Test of the Mean
% Receptive field Size
RFSize_house = elect_table.RFSize(strcmp(elect_table.Selectivity, "HOUSES"));
RFSize_face = elect_table.RFSize(strcmp(elect_table.Selectivity, "FACES"));

p_SizePT = permu_test_mean(RFSize_face, RFSize_house, 10000);

% Eccentricity
Ecc_house = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "HOUSES"));
Ecc_face = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "FACES"));

p_EccPT = permu_test_mean(Ecc_face, Ecc_house, 10000);
