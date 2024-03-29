% category stimuli
stimFile = '~/Documents/ECoG_PRF_categories/data_A/stimuli/sub-p10_ses-nyuecog01_task-spatialobject_acq-clinical_run-01.mat';

load(stimFile);
figure; hold on;
img = [1,13,25];
for ii = 1:length(img)
    subplot(1,3,ii)
    imshow(stimulus.images(:,:, img(ii)))
end
%%

figure;hold on
for ii = 1:size(stimulus.images,3)-1 % 37th stimulus is just a gray screen (blank)
    subplot(6,6,ii);
    imshow(stimulus.images(:,:,ii)); 
    axis tight
end
%%
% pRF stimuli
stimFile = '~/Documents/ECoG_PRF_categories/data_A/stimuli/sub-p10_ses-nyuecog01_task-prf_acq-clinical_run-01.mat';

load(stimFile);

%% 28 stimuli = one sweep
figure;hold on
imlist = 1:28;
for ii = 1:28 
    subplot(4,7,ii);
    imshow(stimulus.images(:,:,imlist(ii))); 
    axis tight
end
%%
figure;hold on
imlist = 29:41;
for ii = 1:12 
    subplot(4,7,ii);
    imshow(stimulus.images(:,:,imlist(ii))); 
    axis tight
end

%% plot report PRFstimuli 
figure;hold on
imlist = [57:85 29:41 1:28];
for ii = 1:length(imlist)
    wanted_stims = ii == [1,15,28, 30,36,41, 43,57,70];
    if sum(wanted_stims)
        subplot(3,3,find(wanted_stims));
        imshow(stimulus.images(:,:,imlist(ii))); 
    end
    axis tight
end

% etc
stimulus.tsv % this shows the order of the stimuli, e.g. stimilus 41-56 are blanks (empty screens)
%% save plot
saveDir = get_utils();
fig_name = ["1_PrfStim"];
saveplots(saveDir, "Report", "Part1_Hypothesis", fig_name, 1000)
%% Get columns with image information ie where the image starts and ends
for j = 1:length(y(1,:))
    if sum(x(:,j)==128) ~= 568
         disp(j)
    end
end