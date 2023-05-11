function [out] = RP2tde_fitPRFs(data, bar_apertures, opt, doPlots, saveDir, resultsStr, plotSaveDir, indv)

% Fits a pRF model to PRF time series using a modified version of Kendrick
% Kay's analyzePRF.m, created by Ken Yuasa (see
% https://github.com/WinawerLab/ECoG_utils/)
% 
% <saveDir> path to save parameters and fits
%   default: fullfile(analysisRootPath, 'prfs')
% <resultsStr> string to add to the save filename for the results.mat
%   created by analyzePRF, if results are saved
%   default: 'prfs'
% 
% 2022 Iris Groen

% <doPlots>
if ~exist('doPlots','var') || isempty(doPlots), doPlots = false; end

% <saveDir>
if ~exist('saveDir', 'var') || isempty(saveDir), saveDir = fullfile(analysisRootPath, 'prfs'); end

% <resultsStr>
if ~exist('resultsStr', 'var') || isempty(resultsStr), resultsStr = 'prffits'; end

% <plotSaveDir>
if ~exist('plotSaveDir','var') || isempty(plotSaveDir)
    plotSaveDir = fullfile(analysisRootPath, 'figures', 'prfs');
end
if ~exist(plotSaveDir, 'dir'); mkdir(fullfile(plotSaveDir));end

% Resize images to speed up calculations
bar_apertures = imresize(bar_apertures, [100 100], 'nearest');

tr = 1; % no HRF for ECoG data

% Fit PRF models for each electrode in each subject
nSubjects = length(data);

out = cell(nSubjects,1);

% Loop over subjects
for ii = 1:nSubjects

    subject = data{ii}.subject;
	channels = data{ii}.channels;
    %data2fit = [];
    %stimulus = [];
    
    if ~isempty(data)
        
        % Average runs
        if ~isfield(data{ii}, 'ts')
            continue
        else
            
            % Define stimulus and data
%            stim_inx = data{ii}.stim_inx;
%             for jj = 1:size(data{ii}.ts,3)
%                 data2fit{jj} = data{ii}.ts(:,:,jj);
%                 stimulus{jj} = double(bar_apertures(:,:,stim_inx));
%             end
%           
            if indv
                data2fit = cell(1,size(data{ii}.ts, 3));
                stimulus = cell(1, size(data{ii}.ts,3));
                %disp(data2fit)
                for nrun = 1:size(data{ii}.ts,3)
                    data2fit{nrun} = data{ii}.ts(:,:,nrun);
                    stimulus{nrun} = bar_apertures;
                end

            else
                data2fit = mean(data{ii}.ts,3);
                stimulus = {bar_apertures(:,:,data{ii}.stim_inx)};

            end
            %disp(size(data2fit))
            %disp(size(stimulus))
            %results = analyzePRF_bounds(stimulus, data2fit, tr, opt);
            results = analyzePRFdog(stimulus, data2fit, tr, opt);
            results.channels = channels;
            results.subject  = subject;
            out{ii}          = results;
            
            % Save fits to results directory
            if ~isempty(saveDir)
    
                if ~exist(saveDir, 'dir'); mkdir(saveDir); end
    
                saveName = sprintf('sub-%s_%s', subject, resultsStr);
                saveName = fullfile(saveDir, saveName);
                fprintf('[%s] Saving results to %s \n', mfilename, saveName);
    
                if exist(sprintf('%s.mat',saveName),'file')
                    warning('[%s] Results file already exists! Writing new file with date-time stamp.',mfilename);
                    saveName = sprintf('%s_%s', saveName, datestr(now,30));
                    fprintf('[%s] Saving results to %s \n', mfilename, saveName);
                end
                save(saveName, 'data2fit','results', 'stimulus');  
            end

            % Make plots of the estimated PRFs and PRF fits

            if doPlots
                close all;
                channels = data{ii}.channels;

                % Timeseries + fits
                RP2ecog_plotPRFtsfits(data2fit, stimulus, results, channels);
                filename = {length(findobj("type", "figure"))};
                for f = 1:length(filename)
                    filename{f} = sprintf("prfTs_%i", f); 
                end
                saveplots(saveDir, "prfTS_allElect", subject, filename);
                close all
                
                % PRFs
                coloropt = 0;
                RP2ecog_plotPRFs(results, stimulus, channels, [], coloropt, [])
                filename = {length(findobj("type", "figure"))};
                for f = 1:length(filename)
                    filename{f} = sprintf("prfs_%i", f); 
                end
                saveplots(saveDir, "prf_all elect", subject, filename);
                close all
            end
        end
    end
end

end