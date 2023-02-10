x = events(contains(events.task_name, 'prf'),:);
y= regexp(x.trial_name, "-", "split");
r=[];
for c = 1:length(y)
    if strcmp(strjoin(y{c}), 'BLANK')
        r(end+1)=0;
    else 
        r(end+1)=1;
    end
end

r = logical(transpose(r));

y = y(r,:);
finally = {};

for f = 1:length(y)
    finally(end+1) = {strjoin(y{f}(1:3))};
end

unique(finally)