function output = transform_to_inter_arrival(col)
    cdf = [0.04 0.1 0.2 0.35 0.6 0.8 0.9 0.95 0.99 1];
    inter_arrival_times = [1 3 5 7 9 11 13 15 17 19];
    
    output = zeros(size(col));
    
    for i = 1:length(col)
        normalized_val = col(i) / 100;
        
        for j = 1:length(cdf)
            if normalized_val <= cdf(j)
                output(i) = inter_arrival_times(j);
                break;
            end
        end
    end
