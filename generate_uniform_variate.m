function output = generate_uniform_variate(row_num)
    a = 1;
    b = 100;
   
    % Take the ceiling to ensure integers
    R = rand(row_num, 1);
    X = a + R * (b - a);
    X = ceil(X);
    output = X;
