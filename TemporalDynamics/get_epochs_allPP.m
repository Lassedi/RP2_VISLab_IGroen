function epochs_acrossSubs = get_epochs_allPP(elect_selection, dataDir)
% Getting all epochs for all participants (excluding PRF trial responses -
% only CS) and returning a data struct

unique_subs = unique(elect_selection.Participant);
epochs_acrossSubs = cell(length(unique_subs), 8);

for sub = 1:length(unique_subs)
    %load subjects for which electrodes got selected
    sub_name = string(unique_subs(sub));
    load(fullfile(dataDir, sprintf("sub-%s_prfcatdata.mat", sub_name)))
    
    %exclude responses to PRF trials
    CS_ind = ~(events.task_name == "prf");

    %find the index of electrodes selected in among all electrodes for
    %current participant
    [~,ind] = ismember(elect_selection.Electrode(elect_selection.Participant == sub_name) , channels.name);
    
    % store epoch data of selected electrodes in a cell array
    epochs_acrossSubs{sub,1} = sub_name;
    epochs_acrossSubs{sub,2} = epochs(:,CS_ind,ind);
    epochs_acrossSubs{sub,3} = channels.name(ind);
    epochs_acrossSubs{sub,4} = events(CS_ind,:);
    epochs_acrossSubs{sub,5} = t;
    epochs_acrossSubs{sub,6} = elect_selection.RFSize(elect_selection.Participant == sub_name)';
    epochs_acrossSubs{sub,7} = elect_selection.Eccentricity(elect_selection.Participant == sub_name)';
    epochs_acrossSubs{sub,8} = elect_selection.Selectivity(elect_selection.Participant == sub_name)';
end

% convert to datastructure 
epochs_acrossSubs = cell2struct(epochs_acrossSubs, ["Sub", "Data" ...
    , "Channels", "Events", "Time", "RFSize", "Eccentricity", "Selectivity"], 2);