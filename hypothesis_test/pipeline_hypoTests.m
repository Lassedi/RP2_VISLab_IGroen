%load electrode table
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots/';
elect_table_ori = readtable(fullfile(dataDir,"2_electSelection_final.xls"));
loc_table = readtable(fullfile(dataDir, "1_locations_final_electrode_selection.xls"));

%exclude EVC
%elect_table = elect_table_ori(loc_table.HouVFa == 0 | loc_table.HouVFa == 1 | loc_table.oddCases == 1,:); 

%dont exclude EVC
elect_table = elect_table_ori;

exclude_outliers = true; % exclude outliers based on 1.5 IQR from respective Quartile

%% Wilcoxon rank sum test
% Receptive Field Size
RFSize_house = elect_table.RFSize(strcmp(elect_table.Selectivity, "HOUSES"));
RFSize_face = elect_table.RFSize(strcmp(elect_table.Selectivity, "FACES"));

if exclude_outliers
    RFSize_face = getIQR(RFSize_face);
    RFSize_house = getIQR(RFSize_house);
end

p_SizeRS = ranksum(RFSize_face, RFSize_house);

% Eccentricity
Ecc_house = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "HOUSES"));
Ecc_face = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "FACES"));

if exclude_outliers
    Ecc_face = getIQR(Ecc_face);
    Ecc_house = getIQR(Ecc_house);
end

p_EccRS = ranksum(Ecc_face, Ecc_house);

%% Permutation Test of the Mean
% Receptive field Size
RFSize_house = elect_table.RFSize(strcmp(elect_table.Selectivity, "HOUSES"));
RFSize_face = elect_table.RFSize(strcmp(elect_table.Selectivity, "FACES"));

if exclude_outliers
    RFSize_face = getIQR(RFSize_face);
    RFSize_house = getIQR(RFSize_house);
end

p_SizePT_mean = permu_test_mean(RFSize_face, RFSize_house, 10000);

% Eccentricity
Ecc_house = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "HOUSES"));
Ecc_face = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "FACES"));

if exclude_outliers
    Ecc_face = getIQR(Ecc_face);
    Ecc_house = getIQR(Ecc_house);
end

p_EccPT_mean = permu_test_mean(Ecc_face, Ecc_house, 10000);

%% Permutation Test of the Median
% Receptive field Size
RFSize_house = elect_table.RFSize(strcmp(elect_table.Selectivity, "HOUSES"));
RFSize_face = elect_table.RFSize(strcmp(elect_table.Selectivity, "FACES"));

if exclude_outliers
    RFSize_face = getIQR(RFSize_face);
    RFSize_house = getIQR(RFSize_house);
end

p_SizePT_median = permu_test_median(RFSize_face, RFSize_house, 10000);

% Eccentricity
Ecc_house = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "HOUSES"));
Ecc_face = elect_table.Eccentricity(strcmp(elect_table.Selectivity, "FACES"));

if exclude_outliers
    Ecc_face = getIQR(Ecc_face);
    Ecc_house = getIQR(Ecc_house);
end

p_EccPT_median = permu_test_median(Ecc_face, Ecc_house, 10000);

%% Permutation test from matlab file exchange
p_offEcc_mean = OFF_permutationTest(Ecc_face, Ecc_house, 10000, 'sidedness','smaller');
p_offRFS_mean = OFF_permutationTest(RFSize_face, RFSize_house, 10000, 'sidedness','smaller');