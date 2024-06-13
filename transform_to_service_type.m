function output = transform_to_service_type(col)
    cdf = [0.3, 0.7, 0.85, 0.95, 1];
    service_types = [1, 2, 3, 4, 5];
    
    output = zeros(size(col));
    
    for i = 1:length(col)
        normalized_val = col(i) / 100;
        
        for j = 1:length(cdf)
            if normalized_val <= cdf(j)
                output(i) = service_types(j);
                break;
            end
        end
    end
