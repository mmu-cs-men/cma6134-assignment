function output = transform_to_service_time_bay_1(col)
    cdf = [0.05 0.1 0.2 0.3 0.5 0.65 0.8 0.9 0.95 1];
    service_times = [6 7 8 9 10 11 12 13 14 15];
    
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
