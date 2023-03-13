function plot_ind_trials(input_data, events, electrode, t, modelts, results, el)
%plot responses to all trials inlcuding blanks per run
events = events(events.task_name == "prf", :);

ind_numb = [1,224];
time_win  = [0.05 0.55];

size_events = size(events);

figure();
hold on;


xlabel = events.trial_name(ind_numb(1):ind_numb(2));

%disp(length(xlabel(1:3:end)))
count = 0;
for x = 1:length(xlabel)
    count = count + 1;
    if count  > 1
        count = 0;
        xlabel{x} = "";
    end
end
legend_labels = [];


%forloop plot
for run_n = 1:(size_events(1)/224)
%disp(run_n)
%disp(ind_numb(1))


data = input_data(t>time_win(1) & t<time_win(2),ind_numb(1):ind_numb(2));
data = mean(data);
%disp(size(data))
data = reshape(data, [], 1);
ind_numb = ind_numb + 224;
x_interval = 1:224;

plot(data, "LineWidth",1.5)
xticks(x_interval);
xticklabels(xlabel);
ax = gca();
ax.XLim = [-5, length(data)];

legend_labels{run_n} = sprintf("Run: %i", run_n);
end

if exist("modelts", "var")
    title(sprintf("Participant: %s - Channel: %s - Trial-response to " + ...
        "individual pRF stimuli & Model prediction - R2: %0.1f", ...
        results.subject, electrode, results.xval(el)));

    legend_labels{end + 1} = "Model";
    plot(modelts{1},LineStyle="-.", LineWidth=2.5, Color="black")
else
    title(sprintf("%s - Trial-response to individual pRF stimuli", ...
    electrode));
end

legend(legend_labels);
