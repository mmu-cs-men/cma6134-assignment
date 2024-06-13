function output = transform_to_service_time_bay_2(col)
    cdf = [0.02 0.07 0.14 0.22 0.31 0.42 0.55 0.7 0.87 1];
    service_times = [12 13 14 15 16 17 18 19 20 21 22];
    
    output = zeros(size(col));
    
    for i = 1:length(col)
        normalized_val = col(i) / 100;
        
        for j = 1:length(cdf)
            if normalized_val <= cdf(j)
                output(i) = service_times(j);
                break;
            end
        end
    end
