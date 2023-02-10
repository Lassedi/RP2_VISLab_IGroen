function [xlabel, x_interval, data_elect] = prepare_rf_data(input_data, trial_str, events, t)

%% Prepare AVG Plotting
%find the trial_names that match the input string ie trial_str and see, 
% how many unique versions there are (EG.VERTICAL bar moved 28x accross the screen)
unique_trial_names = unique(events.trial_name);

trial_ind_uniq = contains(unique_trial_names, trial_str);
unique_trial_names = unique_trial_names(trial_ind_uniq);

%use the information to make a xaxis label vector within the forloop
xlabel = cell(length(unique_trial_names), 1);
%the forloop indexes all datapoints which match the unqiue trial_name and
%takes the mean of the multiple matches column-wise producing a 
% 512xunique_trial_names data array of means
data_elect = zeros(512,length(unique_trial_names));
for trial_numb = 1:length(unique_trial_names)
    
    fprintf('\n%s-%i',trial_str, trial_numb)
    
    xlabel{trial_numb} = sprintf('%s-%i',trial_str, trial_numb);
    trial_ind = ismember(events.trial_name, sprintf('%s-%i',trial_str, trial_numb));
    %disp(length(trial_ind))
    %contains(events.trial_name, sprintf('%s-%i',trial_str, trial_numb));
    data_mean = input_data(t>=0, trial_ind);
    data_mean = mean(data_mean, 2);
    data_elect(:,trial_numb) = data_mean;
    
    fprintf('\nNumber of matches: %i', sum(trial_ind))
end


%disp(size(data_elect))

%reshape the array for plotting
data_elect = reshape(data_elect,[], 1);

%% prepare the x-axis label vector
x_interval = zeros(length(data_elect),1);
x_interval(1) = 1;
counter = 0;
for x = 1:length(x_interval)
    counter = counter + 1;
    %disp(counter)
    if counter == 513
        counter =0;
        x_interval(x) = x;
    end
end
x_interval(x_interval==0) = [];
