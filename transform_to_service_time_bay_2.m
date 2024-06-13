function output = transform_to_service_time_bay_2(col)
    cdf = [0.17 0.32 0.45 0.58 0.69 0.78 0.86 0.93 0.98 1];
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
