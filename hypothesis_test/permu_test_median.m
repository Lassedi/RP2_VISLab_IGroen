function [p] = permu_test_median(distF, distH, n_samples, median_mode)
% calculates the p-value based on the permutation distribution gotten from
% the permutation function and the original difference

if ~exist("median_mode", "var")
    median_mode = false;
end

%draw permutation samples of the mean difference
[median_dif, permu_dif] = permutation(distH, distF, n_samples, median_mode);

%calculate the p - value with every difference larger than the observed
%difference to get the percentile of the observed difference
p = (sum(permu_dif > median_dif) +1) / (n_samples + 1);

end