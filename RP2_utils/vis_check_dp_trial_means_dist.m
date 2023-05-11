function vis_check_dp_trial_means_dist(means_trials_f, means_trials_h, el_name)
% produces a scatter plot of the two categories (faceshouses) trial means
% distributions (mean response for each trial eg. 1x224) for one electrode

% concat to produce y-values & plot values
y = [means_trials_f', means_trials_h'];

title_s = sprintf("%s-Trial-Means per Category",el_name);

figure("Name",title_s); hold on;
scatter(1:2, y)
axis([0,3,min(y,[],"all")-0.2,max(y, [], 'all') + 0.2]);
xticks([0,1,2,3]);
xticklabels(["","Faces","Houses"]);
title(title_s);
hold off;