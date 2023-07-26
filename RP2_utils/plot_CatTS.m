function plot_CatTS(TS_matrix, chan_ind, t, channels, subject, CI, avgTS_cat)
% Plot the timeseries per electrode per category in chan_ind or if
% avgTS_cat == True, the average timeseries across electrodes per category
% is plotted
% TS_matrix:    Should be a 4d array with dim: TSxTRIALSxCHANxCATEGORY with
%               the fourth dimension coding 1 with HOUSES & 2 with FACES
%               !!!if avg_TS_cat == true: datastructure from
%               get_epochs_allPP()
% chan_ind:     only necessary if avgTS_cat == false

%%
% check if confidence intervalls should be plotted
if ~exist("CI", "var")
    CI = false;
end
if ~exist("avgTS_cat", "var")
    avgTS_cat = false;
end

% create avg CI across electrodes
if avgTS_cat
   t = TS_matrix(1).Time;
   CI_build_dist = [];
   CI_face_dist = [];
   avg_TS_Matrix = [];
   for pp = 1:size(TS_matrix, 1)
        %get data from datastructure for pp
        f_ind = strcmp(TS_matrix(pp).Selectivity, "FACES");
        h_ind = ~f_ind;
        
        h_TS_matrix = [];
        f_TS_matrix = [];
        h_TS_matrix = TS_matrix(pp).Data(:,:,h_ind);
        f_TS_matrix = TS_matrix(pp).Data(:,:,f_ind);
        
       
        CI_build_dist_pp = [];
        CI_face_dist_pp = [];
        t = TS_matrix(pp).Time;
       
       if ~isempty(h_TS_matrix)
       for cc = 1:size(h_TS_matrix, 3)
            build_dist = h_TS_matrix(:,:,cc);
            % create bootstrap replicates of category distributions per
            % electrode
            bs_build_dist = bootstrp(1000, @mean, build_dist');
        
            CI_build_dist_AVG = prctile(bs_build_dist, [2.5 97.5], 1);
        
            CI_build_dist_AVG = [CI_build_dist_AVG(2,:), fliplr(CI_build_dist_AVG(1,:))];
            
            CI_build_dist_pp = [CI_build_dist_pp; CI_build_dist_AVG];
       end
       end

       if ~isempty(f_TS_matrix)
       for cc = 1:size(f_TS_matrix, 3)
            % do the same for faces
            face_dist = f_TS_matrix(:,:,cc);

            bs_face_dist = bootstrp(1000, @mean, face_dist');

            CI_face_dist_AVG = prctile(bs_face_dist, [2.5 97.5], 1);

            CI_face_dist_AVG = [CI_face_dist_AVG(2,:), fliplr(CI_face_dist_AVG(1,:))];

            CI_face_dist_pp = [CI_face_dist_pp; CI_face_dist_AVG];

       end
       end 
       CI_build_dist_pp = mean(CI_build_dist_pp, 1);
       CI_face_dist_pp = mean(CI_face_dist_pp, 1);

       CI_build_dist = [CI_build_dist; CI_build_dist_pp];
       CI_face_dist = [CI_face_dist; CI_face_dist_pp];
       
       TS_matrix_b = mean(h_TS_matrix, 2);
       TS_matrix_b = mean(TS_matrix_b, 3);

       TS_matrix_f = mean(f_TS_matrix, 2);
       TS_matrix_f = mean(TS_matrix_f, 3);
       TS_matrix_pp = cat(4, TS_matrix_b, TS_matrix_f);
       
       avg_TS_Matrix = cat(5,avg_TS_Matrix,TS_matrix_pp);
   end
   TS_matrix = mean(avg_TS_Matrix, 5, "omitnan");
   CI_build_dist = mean(CI_build_dist);
   CI_face_dist = mean(CI_face_dist);
end

% Prepare the plot

figure("Visible","on");hold on;

%count loop iterations
counter = 1;

% Loop over channels, plot one channel per subplot
for cc = 1:size(TS_matrix, 3)
    
    if counter > 4
        counter = 1;
        figure("Visible","on");hold on;
    end
    if ~avgTS_cat
        chan = table2array(chan_ind(cc,1)); 
        subplot(2,2,counter); hold on
        title(sprintf('%s %s',channels.name{chan}, subject));
    else
        title("Average Timeseries response of CS electrodes to their respective category")
    end

    % get data
    build_dist = TS_matrix(:,:,cc,1);
    face_dist = TS_matrix(:,:,cc,2);
    
    % plot data
    plot(t,mean(build_dist,2), 'LineWidth', 2)
    plot(t,mean(face_dist,2),'LineWidth', 2)
    
    if CI && ~avgTS_cat
        % create bootstrap replicates of category distributions per
        % electrode
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
    else 
        % plot CI average
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

    axis tight
    counter = counter + 1;
end
end