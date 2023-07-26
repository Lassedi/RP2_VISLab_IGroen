function epochs_acrossSubs = get_TtP(epochs_acrossSubs)
% Calculate Time to peak per electrode for each ts from get_averageCSTS

for sub = 1:length([epochs_acrossSubs.Sub])
    % time value array of max values
    time_max = [];
    % get each subs timeseries
    ts_list = epochs_acrossSubs(sub).Face_Selective;

    % restrict time window
    time_ind = epochs_acrossSubs(sub).Time > 0 & epochs_acrossSubs(sub).Time < 0.5;

    %get max values per ts
    max_ts = max(ts_list(time_ind,:));
    for ts = 1:size(ts_list, 2)

        %compare it to the ts to get index
        max_ind = ts_list(:,ts) == max_ts(ts);

        %get Time value and append it array
        time_max = [time_max, epochs_acrossSubs(sub).Time(max_ind)];
    end
    % append Time to peak for face selective electrodes to data struct
    epochs_acrossSubs(sub).TtP_faces = time_max;
    
    % house ts
    time_max = [];
    ts_list = epochs_acrossSubs(sub).House_Selective;
    max_ts = max(ts_list(time_ind,:));
    for ts = 1:size(ts_list,2)
        %compare it to the ts to get index
        max_ind = ts_list(:,ts) == max_ts(ts);

        %get Time value and append it array
        time_max = [time_max, epochs_acrossSubs(sub).Time(max_ind)];
    end
    % append houses Ttp to data structure
    epochs_acrossSubs(sub).TtP_houses = time_max;
end