function [p] = permu_test_mean(distF, distH, n_samples)

%draw permutation samples of the mean difference
[mean_dif, permu_dif] = permutation(distH, distF, n_samples);

%calculate the p - value with every difference larger than the observed
%difference to get the percentile of the observed difference
p = (sum(permu_dif > mean_dif) +1) / (n_samples + 1);

end