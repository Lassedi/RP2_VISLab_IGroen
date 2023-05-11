function cat_selectivity= category_selectivity_d_prime(epochs, event_idx, t)
%Computes category selectivity using d', to determine category-selectivity.
%
%    params
%    -----------------------
%    epochs : DataFrame dim(t, n)
%        contains the broadband data for each event (n) over time (t)
%    event_idx : array dim(1, n)
%        contains the index numbers for the events belonging to one experimental condition
%    stim : string array dim(1, n)
%        contains categories (n)
%    axis : int (0 or 1) (optional)
%        measure variance over trials (axis=0) or over time (axis=1)
%
%    returns
%    -----------------------
%    category_selectivity : float
%        d' values for every stimulus condition

% preallocate space
cat_selectivity = zeros(1,size(event_idx, 1));

% iterate over stimulus dataframes and compute d'
for i = 1:size(event_idx, 1)
    % event idx of stimulus for which d' is to be computed
    event_idx_cat = logical(event_idx{i});
    data_cat = epochs(t,event_idx_cat); %possible time window: t>-0.05&t<0.85

    % event_idx for other categories to and store them in data other
    event_idx_other = logical(event_idx{1:size(event_idx,1) ~= i});
    data_other = epochs(t, event_idx_other);
    
    % take mean of both data_cat and _other
    mean_data_cat = mean(data_cat, 1);
    mean_data_other = mean(data_other, 1);
    cat_selectivity(i) = d_prime(mean_data_cat, mean_data_other);    
end

end

