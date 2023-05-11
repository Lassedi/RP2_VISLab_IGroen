function [dp] = d_prime(data_cat, data_other)
% Returns d' value for category selectivity between to datasets.
%    params
%    -----------------------
%    data_cat : array dim(T, events)
%        data of the category of which the selectivity is being determined
%    data_other : array dim(T, events)
%        data of the other categories
%    axis : int (0 or 1)
%        measure variance over trials (axis=0) or over time (axis=1)
%
%    returns
%    -----------------------
%    d_prime : float
%        selectivity measure for a given category


%compute mean row-wise for all events - result: 1xlen(events)
mean_cat = mean(data_cat);
mean_other = mean(data_other);

%compute variance 
var_cat = std(data_cat).^2;
var_other = std(data_other).^2;

%compute d'
dp = (mean_cat - mean_other) / sqrt((var_cat + var_other)/2);
end
