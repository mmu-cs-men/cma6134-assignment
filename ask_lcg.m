function output = ask_lcg(rows)
    m = input('Input modulus (m): ');
    c = input('Input multiplier (c): ');
    a = input('Input increment (a): ');
    x = input('Input seed (X_0): ');
    output = generate_lcg(rows, x, c, m, a);