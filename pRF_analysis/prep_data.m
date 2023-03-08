function data = prep_data(sub_list, dataDir)
%function to run on the preprocessed derivates folder structure - contains
%hardcoded paths 
%% loop through all subjects and put them into a cell array of data
% structures expected in RP2tde_computePRF
data = cell(length(sub_list), 1);
cd /home/lasse/Documents/ECoG_PRF_categories/matlab_code/pRF_analysis/
miss_da = 0;
events = 0; %pre-specify because of error otherwise

for subn = 1:length(sub_list)
    % Pick a subject
    sub = sub_list(subn);
    loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', sub));
    load(loadName);
    disp(sub)
    
    %make sure all trials are present
    if floor(size(events(events.task_name == "prf",:),1)/224) ~= ceil( ...
            size(events(events.task_name == "prf",:),1)/224)
        
        disp("!!!missing trial!!!")
        w = waitforbuttonpress;
        close
        
        miss_da = 1;
        n_runs = ceil(size(events(events.task_name == "prf",:),1)/224);
        

        %load subject which completed all trials in the first run and save
        %events file
        control_sub = "p02";
        CtrlloadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', control_sub));
        load(CtrlloadName);
        contrl_events = events(events.task_name == "prf",:);
        
        %reload subject with missing trial
        loadName = fullfile(dataDir, 'derivatives','ECoGPreprocessed', sprintf('sub-%s_prfcatdata.mat', sub));
        load(loadName);

        events_m = events;
        epochs_m = epochs;
        
        row_ind = 0;
        for run = 1:n_runs
            
            row_ind = row_ind + 224;
            fprintf("\nLast row of run: %i\n", row_ind)

            comp_log = strcmp(events_m.trial_name((row_ind - 223):row_ind), ...
                contrl_events.trial_name(1:224));

            count = 0;
            
            %check for the first missing trial(0) & replace (events = row of p02
            % epochs = 0s)- if no zero present anymore end loop
            while any(~comp_log)
            
            count = count + 1;

            miss_ind = (row_ind - 224) + find(comp_log == 0, 1);
            disp(miss_ind)
            %insert missing trial line in events by concatenating tables
            slice_events_1 = events_m(1:(miss_ind - 1),:);
            slice_events_2 = events_m(miss_ind:end, :);
          
            miss_trial = contrl_events(miss_ind - (miss_ind-224),:);

            events_m = [slice_events_1; miss_trial; slice_events_2];

            %insert 0 into epochs for missing trial
            slice_epochs_1 = epochs_m(:,1:(miss_ind - 1),:);
            slice_epochs_2 = epochs_m(:,miss_ind:end, :);
          
            epochs_m = [slice_epochs_1, zeros(size(epochs,1),1, size(channels, 1)),...
                slice_epochs_2];
            
            comp_log = strcmp(events_m.trial_name((row_ind - 223):row_ind), ...
                contrl_events.trial_name(1:224));
            end
      
            
            sprintf("Replaced: %i", count)
        end  
    else
        miss_da = 0;
    end

    % make data structure
    data_struc.subject = subject;
    data_struc.channels = channels;
    switch miss_da
        case 1
            data_struc.epochs_b = epochs_m(:,events_m.task_name == "prf",:);
            data_struc.events = events_m;
        case 0
            data_struc.epochs_b = epochs(:,events.task_name == "prf",:);
            data_struc.events = events;
    end
    data_struc.t = t;
    %append structure
    data{subn,1} = data_struc;
end
