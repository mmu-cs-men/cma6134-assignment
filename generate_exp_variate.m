function output = generate_exp_variate(row_num)
    lambda = 0.0482;
    R = rand(row_num, 1);
    X = -(log(1 - R)) / lambda;
    X = ceil(X);
    X = min(max(X, 1), 100);
    output = X;
