get_utils();

elect_selectionDir = '/home/lasse/Documents/ECoG_PRF_categories/Plots';
elect_selection = readtable(fullfile(elect_selectionDir,"1_electSelection_final.xls"));
dataDir = '/home/lasse/Documents/ECoG_PRF_categories/data_A/derivatives/ECoGPreprocessed';
saveDir = elect_selectionDir;

%% get data
data_allPP = get_epochs_allPP(elect_selection, dataDir);

% Average Time to Peak per electrode for across trials to corresponding selectivity
data_allPP = get_averageCSTS(data_allPP, elect_selection, true);

%% plot average temporal response across participants & electrodes per category

plot_CatTS(data_allPP,[],[],[],[],true, true)

%% save plot

file_name = ["AvgTR_allElect_Subs"];
saveplots(saveDir, "Temporal_Dynamics", "AvgTR_perElect_allSubs", file_name, true)
close all
%% plot average NORMALIZED temporal response across participants & electrodes per category
% get the data
h = [data_allPP.House_Selective]';
f = [data_allPP.Face_Selective]';
t = data_allPP(1).Time;

%% divide each row by max value within timepoint above 0 and below 0.4
h = h./max(h(:,t>0&t<0.5),[],2);
f = f./max(f(:,t>0&t<0.5),[],2);

p = figure(); hold on;
plot(t, mean(f,1),t, mean(h,1))

% CI intervals 
f_CI = prctile(bootstrp(1000, @mean, f), [2.5, 97.5], 1); % bootstrap 1000 average distributions out of the category distribution
h_CI = prctile(bootstrp(1000, @mean, h), [2.5, 97.5], 1);% calculate percentiles from the resulting bootstrap distrubtions for plotting


f_CI = [f_CI(2,:) fliplr(f_CI(1,:))];
h_CI = [h_CI(2,:) fliplr(h_CI(1,:))];

% plot CI
fp = fill([t' fliplr(t')], f_CI(1,:), "blue");
fp.FaceAlpha = 0.4;
fp.EdgeColor = "none";

hp = fill([t' fliplr(t')], h_CI(1,:), "red");
hp.FaceAlpha = 0.4;
hp.EdgeColor = "none";

legend("Face", "House")
xlabel("Time(s)")
ylabel("Normalized Broadband Power")

%make it pretty
pubgraph(p, 10, 0.5,"w", true)

%% plot average temporal response per electrode for both categories for all participants
figure(); hold on;

h = [data_allPP.House_Selective]';
f = [data_allPP.Face_Selective]';
t = data_allPP(1).Time;

for r = 1:size(h,1)
    plot(t, h(r,:))
end

title("Average TR accross trials for house selective electrodes for all participants")
hold off;

figure(); hold on;

for r = 1:size(f,1)
    plot(t, f(r,:))
end

title("Average TR accross trials for face selective electrodes for all participants")
hold off

%% save plots

file_name = ["AvgTR_perElect_H", "AvgTR_perElect_F"];
saveplots(saveDir, "Temporal_Dynamics", "AvgTR_perElect_allSubs", file_name, true)
close all

%% plot normalized average temporal response per electrode for both categories for all participants
% get the data
h = [data_allPP.House_Selective]';
f = [data_allPP.Face_Selective]';
t = data_allPP(1).Time;
lgnd = vertcat(data_allPP.Channels);

% divide each row by max value within timepoint above 0 and below 0.4
h = h./max(h(:,t>0&t<0.5),[],2);
f = f./max(f(:,t>0&t<0.5),[],2);

% plot all time series for houses
figure(); hold on;

for r = 1:size(h,1)
    plot(t, h(r,:))
end
title("Normalized average TR accross trials for house selective electrodes for all participants")

legend(lgnd(strcmp([data_allPP.Selectivity], "HOUSES")))

xticks(round(t(1):0.1:1,2))
hold off;

% plot everything for faces
figure(); hold on;

for r = 1:size(f,1)
    plot(t, f(r,:))
end
title("Normalized average TR accross trials for face selective electrodes for all participants")

legend(lgnd(strcmp([data_allPP.Selectivity], "FACES")))
xticks(round(t(1):0.1:1,2))
hold off;
%% save plots

file_name = ["AvgTR_perElect_H_Time05", "AvgTR_perElect_Time05"];
saveplots(saveDir, "Temporal_Dynamics", "AvgTR_perElect_allSubs_NORM", file_name, 400)
close all

%% plot normalized average temporal response per electrode for both categories PER participant
file_name = [];

%plot normalized average TR for house selctive electrodes
for pp = 1:length(data_allPP)

    h = data_allPP(pp).House_Selective;
    h = h ./ max(h(t>0&t<0.5,:),[],1);
    fig = figure(); hold on;
    
    plot(t,h)
    ax = gca();
    ax.LineStyleOrder = ["-";":";"--"];

    elect = data_allPP(pp).Channels;
    legend(elect(strcmp(data_allPP(pp).Selectivity, "HOUSES")))
    title(sprintf("House-Selective Electrodes for Participant: %s", data_allPP(pp).Sub))
    file_name = [file_name sprintf("PP_%s_AvgTR_perElect_H_Time05_difMar", data_allPP(pp).Sub)];
    pubgraph(fig, 10, 0.5,"w", true)
    hold off

end


% plot normalized average TR for face selctive electrodes
for pp = 1:length(data_allPP)
    if ~isempty(data_allPP(pp).Face_Selective)
        f = data_allPP(pp).Face_Selective;
        f = f ./ max(f(t>0&t<0.5,:),[],1);
        fig = figure(); hold on;
        
        plot(t,f)
        ax = gca();
        ax.LineStyleOrder = ["-",":","--"];
    
        elect = data_allPP(pp).Channels;
        legend(elect(strcmp(data_allPP(pp).Selectivity, "FACES")))
        title(sprintf("Face-Selective Electrodes for Participant: %s", data_allPP(pp).Sub))
        file_name = [file_name sprintf("PP_%s_AvgTR_perElect_F_Time05_difMar", data_allPP(pp).Sub)];
        pubgraph(fig, 10, 0.5,"w", true)

        hold off

    end
end
%% save plots

saveplots(saveDir, "Temporal_Dynamics", "AvgTR_perElect_perSub_NORM", file_name, 800)
close all
