%checking whether selected electrodes differ in their time-to-peak values
%based on eccentricity indipendent of category
%needs epochs_acrossSubs from avgTR_HouVsFac.m loaded incl TTP values
figure();hold on;

e_thresh = 10;
TTP = [epochs_acrossSubs.TtP_faces epochs_acrossSubs.TtP_houses];
ecc_ind = [epochs_acrossSubs.Eccentricity];
x = TTP(ecc_ind>e_thresh);
y = TTP(ecc_ind<=e_thresh);

bar(1,mean(x))
bar(2,mean(y))
scatter(1,x)
scatter(2,y)

%%
scatter(ecc_ind, TTP)
