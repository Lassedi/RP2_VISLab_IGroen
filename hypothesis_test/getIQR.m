function IQR_dist=getIQR(dist)
% calculate Inter quartile range for the dsitribution & return the
% distribution within & excluding outliers outside 1.5 IQR from respective Quartile 

median_dist = median(dist);

Q_1 = median(dist(dist<median_dist)); %get 1. Quartile by taking median of dist lower than median(dist)
Q_3 = median(dist(dist>median_dist));%get 2. Quartile by taking median of dist higher than median(dist)
IQR = (Q_3 - Q_1) * 1.5; % 1.5 IQR



IQR_dist = dist(dist>(Q_1 - IQR) & dist < (Q_3 + IQR));
end