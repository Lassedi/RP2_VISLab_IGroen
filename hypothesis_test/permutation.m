function [ori_dif, permu_dif] = permutation(dist1, dist2, permutations, mean_mode)
% calculates the original difference of the chosen test statistic
% (mean/median) and makes permutation samples based on the permutations
% argument passed using the respective test statistic

if ~exist("mean_mode", "var")
    mean_mode = true;
end


%enforcing row vectors
if iscolumn(dist1), dist1 = dist1'; end
if iscolumn(dist2), dist2 = dist2'; end

%combine the two distributions into one & calc mean difference
joinDist = [dist1, dist2];
if mean_mode
    ori_dif = mean(dist1) - mean(dist2);
else 
    ori_dif = median(dist1) - median(dist2);
end

%randomly with replacement create new distributions & calcualte their
%mean difference stored in permu_dif
permu_dif = zeros([1,permutations]);
for p = 1:permutations
    p_dist1 = randsample(joinDist, length(dist1),false);
    p_dist2 = joinDist(~ismember(joinDist, p_dist1)); % get all datapoints that are not part of p_dist1
    
    % calculate the difference with the relevant test statistic
    if mean_mode
        permu_dif(p) = mean(p_dist1) - mean(p_dist2);
    else
        permu_dif(p) = median(p_dist1) - median(p_dist2);
    end
end
end