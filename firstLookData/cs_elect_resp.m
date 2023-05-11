function cs_elect_resp(dataDir, thresh, subject, CI)
% Plots average acitivation accross trials for Face and Building/House
% stimuli along with the 95 Confidence interval if: true is passed to CI
% dataDir:  preprocessed ECoG data BIDS format
% thresh:   if 0 is passed no threshold is applied - otherwise average
%           activation lower than the threshold get excluded

if ~exist("CI", "var")
    CI = false;
end

% load data
loadName = fullfile(dataDir, sprintf('sub-%s_prfcatdata.mat', subject));
load(loadName);

%% Plot the average response per category 

% Find the events belonging to the spatial object task
trial_ind = ~contains(events.task_name, {'prf'});

% Find channels that show a good response to these trials:
% First, average across all trials in these runs
tmp = squeeze(mean(epochs(:,trial_ind,:),2));

if thresh ~= 0
% Then, select the channels that have a response increase greater than thresh
%thresh = 1;  % this means xfold increase relative prestimulus baseline, so 1 = 100% increase in signal
chan_ind1 = find(max(tmp) > thresh);
% Exclude the depth channels for now (include only surface channels)
chan_ind2 = find(contains(channels.type, 'ECOG'));
chan_ind = intersect(chan_ind1,chan_ind2);
chan_ind = array2table(chan_ind);
chan_ind(:,"subject") = {subject};
if height(chan_ind) == 0
    return
end 
else 
    %chan_ind = array2table(find(contains(channels.type, "ECOG")));
    chan_ind = array2table((1:size(channels,1))');
    chan_ind{:, "subject"} = {subject};
end
%%
% Prepare the plot

figure("Visible","on");hold on;

%count loop iterations
counter = 1;

% Loop over channels, plot one channel per subplot
for cc = 1:height(chan_ind)
    
    if counter > 4
        counter = 1;
        figure("Visible","on");hold on;
    end
    chan = table2array(chan_ind(cc,1)); 
    trial_ind1 = contains(events.trial_name, ['BUILDINGS', "HOUSES"]);
    trial_ind2 = contains(events.trial_name, 'FACE');
    %trial_ind3 = contains(events.trial_name, 'LETTER')
    
    build_dist = epochs(:,trial_ind1,chan);
    face_dist = epochs(:,trial_ind2,chan);

    subplot(2,2,counter); hold on
    plot(t,mean(build_dist,2), 'LineWidth', 2)
    plot(t,mean(face_dist,2),'LineWidth', 2)
    %plot(t,mean(epochs(:,trial_ind3,chan),2),'LineWidth', 2)
    
    if CI
    % create bootstrap replicates of category distributions
    bs_build_dist = bootstrp(1000, @mean, build_dist');
    bs_face_dist = bootstrp(1000, @mean, face_dist');

    CI_build_dist = prctile(bs_build_dist, [2.5 97.5], 1);
    CI_face_dist = prctile(bs_face_dist, [2.5 97.5], 1);

    CI_build_dist = [CI_build_dist(2,:), fliplr(CI_build_dist(1,:))];
    CI_face_dist = [CI_face_dist(2,:), fliplr(CI_face_dist(1,:))];

    % plot CI
    b = fill([t; flipud(t)]',CI_build_dist, "blue");
    b.FaceAlpha = 0.4;
    b.EdgeColor = "none";

    h = fill([t; flipud(t)]',CI_face_dist(1,:), "red");
    h.FaceAlpha = 0.4;
    h.EdgeColor = "none";
    end

    if counter == 1
        legend('HOUSE', 'FACE');%, 'LETTER');
    end
    title(sprintf('%s %s',channels.name{chan}, subject));
    axis tight
    counter = counter + 1;
end
end
