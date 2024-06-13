function output = generate_uniform_variate(row_num)
    a = 1;
    b = 100;
   
    R = rand(row_num, 1);
    X = a + R * (b - a);
    X = ceil(X);
    X = min(max(X, a), b);
    output = X;
