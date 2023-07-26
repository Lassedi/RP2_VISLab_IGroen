elect_tbl = epochs_acrossSubs;

ttp = elect_tbl.Ttp;
Rso = elect_tbl.Resp_StimOff;
dp = elect_tbl.FACES;

ecc = elect_tbl.Eccentricity;
RFS = elect_tbl.RFSize;
x = [ecc,RFS,ones(length(ecc),1)];

[B,BINT,R,RINT,STATS] = regress(ttp, x);
stat_sum = STATS;

[B,BINT,R,RINT,STATS] = regress(Rso, x);
stat_sum = [stat_sum;STATS];

[B,BINT,R,RINT,STATS] = regress(dp, x);
stat_sum = [stat_sum; STATS];
