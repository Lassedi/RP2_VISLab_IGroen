function vis_check_dp_trial_means_dist(means_trials_f, means_trials_h, el_name)
% produces a scatter plot of the two categories (faceshouses) trial means
% distributions (mean response for each trial eg. 1x224) for one electrode


% concat to produce y-values & plot values
y = [means_trials_f' means_trials_h'];
x = [ones(1,size(y,1))' 2*ones(1,size(y,1))'];

title_s = sprintf("%s: Trial-Means Distribution per Category",el_name);

f = figure("Name",title_s); hold on;
a = swarmchart(x(:,1)', y(:,1)', "filled", "MarkerFaceAlpha",0.5);
b = swarmchart(x(:,2)', y(:,2)', "filled", "MarkerFaceAlpha",0.5);

a.XJitterWidth = 0.6;
b.XJitterWidth = 0.6;

% plot variance around mean
errorbar([1 2],[mean(means_trials_f), mean(means_trials_h)] ...
    ,[var(means_trials_f) var(means_trials_h)], "black")

axis([0.5,2.5,min(y,[],"all")-0.2,max(y, [], 'all') + 0.2]);
fontname(gcf,"Times")
xticks([1,2]);
xlabel("Trial Category");
ylabel("Change in Signal");
title(title_s);

pubgraph(f,10,0.5, "w", false);

%plot the means of the distributions
plot(0.8:0.2:1.2, repmat(mean(means_trials_f), 3,1)', LineWidth=2)
plot(1.8:0.2:2.2, repmat(mean(means_trials_h), 3,1)', LineWidth=2)

xticklabels(["Faces","Houses"]);

hold off;