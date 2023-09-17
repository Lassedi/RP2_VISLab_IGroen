function plot_std_error(inp_strct)
%calculate and plot standard error of the mean for all samples in the input structure
% (inp_strct). This is made for barplots. !!Sample order matters in inp_strct!!

%get number and names of all sample distributions
numDist = numel(fieldnames(inp_strct));
fieldNames = fieldnames(inp_strct);

for dist = 1:numDist
    %get distribution
    ind = fieldNames{dist};
    sample = inp_strct.(ind);
    
    % get necessary statistics
    mu = mean(sample);
    sigma = std(sample);
    n = length(sample);

    %calculate and plot error bars (std error of the mean)
    stderr = sigma ./ sqrt(n);
    er = errorbar(dist, mu, stderr);
    er.Color = [0,0,0];
    er.LineStyle = "none";
    er.LineWidth = 1;
end