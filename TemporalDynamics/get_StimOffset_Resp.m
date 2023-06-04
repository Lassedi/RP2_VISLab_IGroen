function epochs_acrossSubs = get_StimOffset_Resp(epochs_acrossSubs, norm)
% return response per electrode for each ts from get_averageCSTS

for sub = 1:length([epochs_acrossSubs.Sub])
    % restrict time window
    time_ind = find(epochs_acrossSubs(sub).Time > 0.5);
    time_ind = time_ind(1);
    
    % get each subs timeseries & normalize by dividing through peak value 
    ts_list = epochs_acrossSubs(sub).Face_Selective;
    if norm
        t = epochs_acrossSubs(sub).Time;
        ts_list = [ts_list] ./ [max([ts_list(t>0&t<0.6, :)])];
    end
    
    %get max values per ts
    offset_resp = ts_list(time_ind,:);

    % append Time to peak for face selective electrodes to data struct
    epochs_acrossSubs(sub).StimOffset_resp_faces = offset_resp;
    
    % house ts
    ts_list = epochs_acrossSubs(sub).House_Selective;
    if norm
        t = epochs_acrossSubs(sub).Time;
        ts_list = [ts_list] ./ [max([ts_list(t>0&t<0.6, :)])];
    end
    offset_resp = ts_list(time_ind,:);

    % append houses Ttp to data structure
    epochs_acrossSubs(sub).StimOffset_resp_houses = offset_resp;
end