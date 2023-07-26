function epochs_acrossSubs = get_averageCSTS(epochs_acrossSubs, elect_selection, all_trials)
% get average timeseries for each subjects face and house selective
% electrodes across its respective face and house trials

%loop through all subjects which have electrodes selected for analysis
for sub = 1:length([epochs_acrossSubs.Sub])
    
    %get data per participants
    data = epochs_acrossSubs(sub).Data;
    
    %split data into house and face selective electrodes and face and house
    %trials respectively
    elect_selection_sub = elect_selection(elect_selection.Participant == ...
        epochs_acrossSubs(sub).Sub,:);
    if all_trials %get all trials (House & Face) for a category selective electrode
        data_f = data(:...
            ,contains(epochs_acrossSubs(sub).Events.trial_name, "HOUSES")...
            | contains(epochs_acrossSubs(sub).Events.trial_name, "FACES")...
            | contains(epochs_acrossSubs(sub).Events.trial_name, "BUILDINGS")...
            , elect_selection_sub.Selectivity == "FACES");
        data_h = data(:...
            ,contains(epochs_acrossSubs(sub).Events.trial_name, "HOUSES")...
            | contains(epochs_acrossSubs(sub).Events.trial_name, "FACES")...
            | contains(epochs_acrossSubs(sub).Events.trial_name, "BUILDINGS")...
            , elect_selection_sub.Selectivity == "HOUSES");
    else 
        data_f = data(:...
        ,contains(epochs_acrossSubs(sub).Events.trial_name, "FACES")...
        ,elect_selection_sub.Selectivity == "FACES");
    
    data_h = data(: ...
        ,contains(epochs_acrossSubs(sub).Events.trial_name, "HOUSES") |...
        contains(epochs_acrossSubs(sub).Events.trial_name, "BUILDINGS"),... 
        elect_selection_sub.Selectivity == "HOUSES");
    end
    
    
    %calculate meanTS per category selective electrodes and over respective
    %category trials
    meanTS_f = squeeze(mean(data_f,2));
    meanTS_h = squeeze(mean(data_h,2));
    
    % append means to datastructure 
    epochs_acrossSubs(sub).Face_Selective = meanTS_f;
    epochs_acrossSubs(sub).House_Selective = meanTS_h;

end
end