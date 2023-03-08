function plot_ind_trials(input_data, events, electrode, t)

events = events(events.task_name == "prf", :);

ind_numb = [1,224];
time_win  = [0.05 0.55];

size_events = size(events);

figure();
hold on;

title(sprintf("%s - Trial-response to individual pRF stimuli", electrode));
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
disp(run_n)
disp(ind_numb(1))


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

legend(legend_labels);
