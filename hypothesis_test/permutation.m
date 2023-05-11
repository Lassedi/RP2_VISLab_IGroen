function [mean_dif, permu_dif] = permutation(dist1, dist2, permutations)

%enforcing row vectors
if iscolumn(dist1), dist1 = dist1'; end
if iscolumn(dist2), dist2 = dist2'; end

%combine the two distributions into one & calc mean difference
joinDist = [dist1, dist2];
mean_dif = mean(dist1) - mean(dist2);

%randomly with replacement create new distributions & calcualte their
%mean difference stored in permu_dif
permu_dif = zeros([1,permutations]);
for p = 1:permutations
    p_dist1 = randsample(joinDist, length(dist1),false);
    p_dist2 = joinDist(~ismember(joinDist, p_dist1)); % get all datapoints that are not part of p_dist1
    permu_dif(p) = mean(p_dist1) - mean(p_dist2);
end
end