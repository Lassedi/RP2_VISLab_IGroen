% Plotting average Temporal Response across participants for each category
% (Faces & Houses)

elect_selectionDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/data_A/derivatives/ECoGPreprocessed';

elect_selection = readtable(fullfile(elect_selectionDir,"1_electSelection_final.xls"));



%% Getting all epochs for all participants (excluding PRF trial responses - only CS)
unique_subs = unique(elect_selection.Participant);
epochs_acrossSubs = cell(length(unique_subs), 3);

for sub = 1:length(unique_subs)
    %load subjects for which electrodes got selected
    sub_name = string(unique_subs(sub));
    load(fullfile(dataDir, sprintf("sub-%s_prfcatdata.mat", sub_name)))
    
    %exclude responses to PRF trials
    CS_ind = ~(events.task_name == "prf");

    %find the index of electrodes selected in amog all electrodes for
    %current participant
    [~,ind] = ismember(elect_selection.Electrode(elect_selection.Participant == sub_name) , channels.name);
    
    % store epoch data of selected electrodes in a cell array
    epochs_acrossSubs{sub,1} = sub_name;
    epochs_acrossSubs{sub,2} = epochs(:,CS_ind,ind);
    epochs_acrossSubs{sub,3} = channels.name(ind);
end

% convert to datastructure 
epochs_acrossSubs = cell2struct(epochs_acrossSubs, ["Sub", "Data", "Channels"], 2);
%% Averaging across participants to get Time response for faces and house selective electrodes
avg_elect = true;

if avg_elect
    TR_mean_Ho = zeros(614,1);
    TR_mean_Fa = zeros(614,1);
else
    TR_mean_Ho = zeros(614, sum(elect_selection.Selectivity == "HOUSES"));
    TR_mean_Fa = zeros(614, sum(elect_selection.Selectivity == "FACES"));
end

for sub = 1:length(epochs_acrossSubs)
    disp(epochs_acrossSubs(sub).Sub)

    %select the selected electrodes of each participant
    elect_selection_indv = elect_selection(elect_selection.Participant == epochs_acrossSubs(sub).Sub,:); 

    %make indexes to find which of these elctrodes are category selective
    elect_Fa = elect_selection_indv.Selectivity == "FACES";
    elect_Ho = elect_selection_indv.Selectivity == "HOUSES";
    
    

    %average accross epochs first over the 2nd(trials), then
    %3rd(electrodes) dimension and finally average with previous
    %participants TRs
    if avg_elect
        if any(sum(elect_Ho)) %check if index is nonzero
            TR_mean_Ho = mean([TR_mean_Ho, mean(mean(epochs_acrossSubs(sub).Data(:,:,elect_Ho), 2), 3)], 2);
        end
        if any(sum(elect_Fa))
            TR_mean_Fa = mean([TR_mean_Fa, mean(mean(epochs_acrossSubs(sub).Data(:,:,elect_Fa), 2), 3)], 2);
        end
    else 
        %make index for assigning the individual electrodes to the TR_elect array
        %house electrodes
        x = find(~any(TR_mean_Ho));
        
        if isempty(x)
            x(1) = 1;
        end
        
        if any(sum(elect_Ho)) %check if index is nonzero
            TR_mean_Ho(:,x(1):(x(1)-1)+sum(elect_Ho)) = squeeze(mean(epochs_acrossSubs(sub).Data(:,:,elect_Ho), 2));
        end
        
        %face electrodes
        x = find(~any(TR_mean_Fa));
        
        if isempty(x)
            x(1) = 1;
        end

        if any(sum(elect_Fa))
            TR_mean_Fa(:,x(1):(x(1)-1)+sum(elect_Fa)) = squeeze(mean(epochs_acrossSubs(sub).Data(:,:,elect_Fa), 2));
        end
    end
end

%% Plot Temporal Face and House responses
figure; hold on

plotTitle = "Average Temporal Response Across Participants";

set(gcf,'Units','points');
    if avg_elect; alp = 0.7;else; alp = 0.2; end
    f = plot(cat(1, TR_mean_Fa),'Color', [1,0.2,0,alp], 'LineWidth', 2,'DisplayName',"Face");
    h = plot(cat(1, TR_mean_Ho),'Color', [0,0.5,1,alp],'LineWidth', 2, 'DisplayName',"House");
    xlabel('Stimulus'); ylabel('Broadband response')
    set(gca, 'FontSize', 14)
    set(gca, 'XTickLabel', []);
    title(plotTitle);
    axis tight

    legend([unique({f.DisplayName}), unique({h.DisplayName})])
    
%% averaging accross high vs low eccentricity

elect_ecc_low = elect_selection(elect_selection.Eccentricity < 10,:);
elect_ecc_high = elect_selection(elect_selection.Eccentricity > 10,:);


elect_name_l = elect_ecc_low.Electrode(elect_ecc_low.Participant == "p02");
elect_name_h = elect_ecc_low.Electrode(elect_ecc_high.Participant == "p02");


strcmp(epochs_acrossSubs(1).Channels,string(elect_name_l))
strcmp(epochs_acrossSubs(1).Channels,string(elect_name_h))


