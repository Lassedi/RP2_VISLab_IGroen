function plot_avg_DtsVSMts(data2fit,stimulus, events, elect, results, el)

%get data and model ts for the particular electrode
[datats, modelts] = generate_ts(data2fit, stimulus, results, el);


%plot responses to all trials inlcuding blanks per run
events = events(events.task_name == "prf", :);
ind_numb = [1,224];

% plot the two ts
a = figure();hold on;
plot(datats{1}', "LineWidth",1.5)
plot(modelts{1}',LineStyle="-.", LineWidth=1.5, Color="black")

% make the xaxis with ticks and label
x_interval = 1:224;
xticks(x_interval);

xlabel = events.trial_name(ind_numb(1):ind_numb(2));

%make every second label empty string - avoid clutter
count = 0;
for x = 1:length(xlabel)
    count = count + 1;
    if count  > 1
        count = 0;
        xlabel{x} = "";
    end
end

xticklabels(xlabel);
%limit xaxis length to ts length ie 224
ax = gca();
ax.XLim = [-5, length(datats{1})];

% make the legend
legend_labels = [];

legend_labels{1} = sprintf("Avg across runs");

% make the title
electrode = results.channels.name{el};
elect_ind = find(strcmp(elect.Electrode, electrode));
title(sprintf("Participant: %s - Channel: %s - Trial-response to " + ...
    "individual pRF stimuli & Model prediction - R2: %0.1f - %s (d': %0.1f)", ...
    results.subject, electrode, mean(results.xR2(el,:)), elect.Selectivity{elect_ind},...
    table2array(elect(elect_ind, elect.Selectivity{elect_ind}))));

legend_labels{end + 1} = "Model";

legend(legend_labels);

% make it pretty
pubgraph(a, 10, 0.5,"w", false)

