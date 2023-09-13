% load the table created in the category selectivity analysis which
% contains electrodes with a d-prime value above the threshold. Here we
% further select elctrodes based on their retinotopic information ie
% mean(xR2,2) - added are the columns indicating electrodes' eccentricity
% value (now mean(results.ecc,2) because of xval>0) and the same for their
% size & angluar values.

%% load the table containing the namees of electrods which are OS and have
%pos R2
saveDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';

%elect_prf = readtable("goodPRF_OS_elect.xls");
addpath(genpath('/home/lasse/Documents/ECoG_PRF_categories'))
elect_prf = readtable(fullfile(saveDir,"WoNorm_HoFa_goodPRF_OS_CS>05_xr2>10_act>1.xls"));

% Load results & data
prfFitPath = '/home/lasse/Documents/ECoG_PRF_categories/data_A/prf_fits/prf_woNorm_dataA';
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/data_A';
sub_list = cell2mat(unique(elect_prf.Participant));


for subject = 1:size(sub_list,1)
    subject = sub_list(subject,:);
    %elect_prf = elect_prf)(elect_prf.Participant == subject,:);
    load(sprintf("%s/sub-%s_prffits.mat", prfFitPath, subject));
    %load(fullfile(dataDir, sprintf('sub-%s_prfcatdata.mat', subject)));
    load(fullfile(dataDir, "derivatives", "ECoGPreprocessed", sprintf('sub-%s_prfcatdata.mat', subject)));

    % Sort electrodes into categories & select related results
    for elct = 1:length(elect_prf.Electrode)
        elct = elect_prf.Electrode{elct};
        table_ind = strcmp(elect_prf.Electrode, elct) & strcmp(elect_prf.Participant, subject);
        
        % assining results to new columns
        elect_prf(table_ind(:,1), 8) = table(mean(results.ecc(strcmp(channels.name, elct),:)));
        elect_prf(table_ind(:,1), 9) = table(mean(results.rfsize(strcmp(channels.name, elct),:)));
        elect_prf(table_ind(:,1), 10) = table(mean(results.ang(strcmp(channels.name, elct),:)));
    end
end

% Name new columns
elect_prf.Properties.VariableNames(end-2:end) = ["Eccentricity", "RFSize", "VAngle"];

%% create working table
%elect_table = elect_prf(~strcmp(elect_prf.Electrode, "GB22"), :);
elect_table = elect_prf;
%% exclude letters if wanted
elect_table = elect_prf(~strcmp(elect_prf.Selectivity, "LETTERS"),:);

%% exclude outliers
% centricityexclude extreme outlier
%elect_table = elect_table(elect_table.Eccentricity < 50,:);
%elect_table = elect_table(elect_table.RFSize < 70,:);
elect_table = elect_table(elect_table.Eccentricity - (elect_table.RFSize) < 18.6, :); % 18.6 the value the CS stimuli extended in logical pixel values from the center
elect_table = elect_table(elect_table.Mean_xR2 > 20,:);
%% Save elect_table for hypothesis testing
cd '/home/lasse/Documents/ECoG_PRF_categories/Plots';
writetable(elect_table, "2_electSelection_final.xls")
%% exlude every electrode above 30 ecc (pixel value)
elect_table = elect_table(elect_table.Eccentricity<30,:);