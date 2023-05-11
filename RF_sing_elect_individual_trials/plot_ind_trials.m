function plot_ind_trials(input_data, events, elect, t, modelts, results, el, avg)

if isempty(avg)
    avg = false;
end

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

n_run = (size_events(1)/224);

if avg
    upper_ind = n_run*224;
    input_data = input_data(:,1:upper_ind);
    input_data = reshape(input_data, size(input_data, 1), 224, []);
    input_data = mean(input_data, 3);
    n_run = 1;
end

degs = results.options.maxpolydeg;
polymatrix = {};

%forloop plot
for run_n = 1:n_run
    %disp(run_n)
    %disp(ind_numb(1))
    
    polymatrix{run_n} = projectionmatrix(constructpolynomialmatrix(length(input_data(ind_numb(1):ind_numb(2))),0:degs(run_n)));
    disp(size(polymatrix{1}))
    disp(size(input_data(ind_numb(1):ind_numb(2))))
    %data = input_data(t>time_win(1) & t<time_win(2),ind_numb(1):ind_numb(2)); 
    % ^this necessary of epochs is passed instead of data2fit
    data = polymatrix{run_n}*(input_data(ind_numb(1):ind_numb(2))'); %this for data2fit
    %data = mean(data); % this is necessary if epochs are passed instead of
    %data2fit
    %disp(size(data))
    %data = reshape(data, [], 1);
    ind_numb = ind_numb + 224;
    
    plot(data, "LineWidth",1.5)
    legend_labels{run_n} = sprintf("Run: %i", run_n);
    if avg
        legend_labels{run_n} = sprintf("Avg across runs");
    end
end
x_interval = 1:224;
xticks(x_interval);
xticklabels(xlabel);
ax = gca();
ax.XLim = [-5, length(data)];



electrode = results.channels.name{el};
elect_ind = find(strcmp(elect.Electrode, electrode));
if exist("modelts", "var")
    title(sprintf("Participant: %s - Channel: %s - Trial-response to " + ...
        "individual pRF stimuli & Model prediction - R2: %0.1f - %s (d': %0.1f)", ...
        results.subject, electrode, mean(results.xR2(el)), elect.Selectivity{elect_ind},...
        table2array(elect(elect_ind, elect.Selectivity{elect_ind}))));

    legend_labels{end + 1} = "Model";
    plot(modelts{1},LineStyle="-.", LineWidth=2.5, Color="black")
else
    title(sprintf("%s - Trial-response to individual pRF stimuli", ...
    electrode));
end

legend(legend_labels);
