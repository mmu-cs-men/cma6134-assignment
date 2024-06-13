function output = generate_exp_variate(row_num, lambda)
    % After running some simulations, this was determined to be the
    % best value for lambda that would yield values between [1,100]    
    if isempty(lambda)
        lambda = 0.0482;
    end
    
    % Exp. variate generator outputs floats but the range should only 
    % support integers so we take the ceiling of the value.
    % Then, we ensure the value is within [1,100] by clamping it with min,max
    R = rand(row_num, 1);
    X = -(log(1 - R)) / lambda;
    X = ceil(X);
    X = min(max(X, 1), 100);
    output = X;
