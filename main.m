% =====================================
% Clear previous junk
% =====================================
clear all;

% =====================================
% Seed the RNG
% =====================================
current_time = clock;
seed(69, round(current_time(6)));

% =====================================
% Print all the probability tables
% =====================================
print_service_time_table();
printf('\n\n');
print_inter_arrival_table();
printf('\n\n');
print_service_type_table();
printf('\n\n');

% =====================================
% User input section
% =====================================
printf('How many cars do you want to simulate?\n\n');
max_cars = input('Input: ');

printf('\nWhat random number generator would you like to use?\n\n1. FreeMat randi function\n2. Linear Congruential Generator (LCG)\n3. Exponential Variate Generator\n4. Uniform Variate Generator (same distribution as 1 and 2)\n\n');
rng_choice = input('Input: ');

printf('\n\n\n')

% =====================================
% Generate random numbers
% =====================================
total_rn_num = max_cars * 3;

if rng_choice == 1
    rn_arr = generate_randi(total_rn_num);
elseif rng_choice == 2
    printf('How would you like to configure the LCG?\n\n1. Use the same LCG parameters for all random number generators\n2. Use different LCGs with different parameters\n\n');
    lcg_choice = input('Input: ');
    
    if lcg_choice == 1
        printf('\n\nEnter parameters for all LCGs:\n\n');
        m = input('Input modulus (m): ');
        c = input('Input multiplier (c): ');
        a = input('Input increment (a): ');
        x = input('Input seed (X_0): ');
        rn_arr = generate_lcg(total_rn_num, x, c, m, a);
    elseif lcg_choice == 2
        printf('\n\nEnter parameters for wash bay service times:\n\n');
        m = input('Input modulus (m): ');
        c = input('Input multiplier (c): ');
        a = input('Input increment (a): ');
        x = input('Input seed (X_0): ');
        rn_arr(1) = generate_lcg(max_cars, x, c, m, a);
        
        printf('\n\nEnter parameters for inter arrival times:\n\n');
        m = input('Input modulus (m): ');
        c = input('Input multiplier (c): ');
        a = input('Input increment (a): ');
        x = input('Input seed (X_0): ');
        rn_arr(2) = generate_lcg(max_cars, x, c, m, a);
        
        printf('\n\nEnter parameters for service types:\n\n');
        m = input('Input modulus (m): ');
        c = input('Input multiplier (c): ');
        a = input('Input increment (a): ');
        x = input('Input seed (X_0): ');
        rn_arr(3) = generate_lcg(max_cars, x, c, m, a);
    else
        error('Invalid choice');
    end
    
    printf('\n\n');
elseif rng_choice == 3
    rn_arr = generate_exp_variate(total_rn_num);
elseif rng_choice == 4
    rn_arr = generate_uniform_variate(total_rn_num);
else
    error('Invalid choice');
end

% =====================================
% Run the simulation
% =====================================
n_col = [1:max_cars]';

inter_arrival_rn_col = rn_arr(1+max_cars : max_cars*2);
inter_arrival_col = transform_to_inter_arrival(inter_arrival_rn_col);

arrival_time_col = zeros(max_cars, 1);

for n=2:max_cars
    arrival_time_col(n) = arrival_time_col(n-1) + inter_arrival_col(n);    
end

service_type_rn_col = rn_arr(1+max_cars*2 : max_cars*3);
service_type_col = transform_to_service_type(service_type_rn_col);

num_bays = 3;
bay_next_available_time = zeros(1, num_bays);

service_time_rn_col = rn_arr(1 : max_cars);

time_service_begins_col = zeros(max_cars, 1);
time_service_ends_col = zeros(max_cars, 1);
waiting_time_col = zeros(max_cars, 1);
time_spent_col = zeros(max_cars, 1);
bay_assigned_col = zeros(max_cars, 1);
service_time_col = zeros(max_cars, 1);

for n=1:max_cars
    [min_time, bay_index] = min(bay_next_available_time);
    bay_assigned_col(n) = bay_index;
    
    printf('Car %d arrives at time %d\n', n, arrival_time_col(n));
    
    if bay_next_available_time(bay_index) <= arrival_time_col(n)
        time_service_begins_col(n) = arrival_time_col(n);
    else
        time_service_begins_col(n) = bay_next_available_time(bay_index);
        printf('Car %d begins waiting in queue at time %d\n', n, arrival_time_col(n));
    end
    
    printf('Car %d begins washing at bay %d at time %d\n', n, bay_index, time_service_begins_col(n));

    if bay_index == 1
        service_time_col(n) = transform_to_service_time_bay_1(service_time_rn_col(n));
    elseif bay_index == 2
        service_time_col(n) = transform_to_service_time_bay_2(service_time_rn_col(n));        
    else
        service_time_col(n) = transform_to_service_time_bay_3(service_time_rn_col(n));
    end
    
    bay_next_available_time(bay_index) = time_service_begins_col(n) + service_time_col(n);
    time_service_ends_col(n) = time_service_begins_col(n) + service_time_col(n);    
    waiting_time_col(n) = time_service_begins_col(n) - arrival_time_col(n);
    time_spent_col(n) = service_time_col(n) + waiting_time_col(n);
    
    printf('Car %d departs at time %d\n', n, time_service_ends_col(n));
end

% =====================================
% Construct and print final tables
% =====================================
indices_bay1 = find(bay_assigned_col == 1);
indices_bay2 = find(bay_assigned_col == 2);
indices_bay3 = find(bay_assigned_col == 3);

table1 = [n_col inter_arrival_rn_col inter_arrival_col arrival_time_col service_type_col];
table2 = [n_col(indices_bay1) service_time_rn_col(indices_bay1) service_time_col(indices_bay1) time_service_begins_col(indices_bay1) time_service_ends_col(indices_bay1) waiting_time_col(indices_bay1) time_spent_col(indices_bay1)];
table3 = [n_col(indices_bay2) service_time_rn_col(indices_bay2) service_time_col(indices_bay2) time_service_begins_col(indices_bay2) time_service_ends_col(indices_bay2) waiting_time_col(indices_bay2) time_spent_col(indices_bay2)];
table4 = [n_col(indices_bay3) service_time_rn_col(indices_bay3) service_time_col(indices_bay3) time_service_begins_col(indices_bay3) time_service_ends_col(indices_bay3) waiting_time_col(indices_bay3) time_spent_col(indices_bay3)];

printf('\n\n');

disp('Overall Table:');
disp('-------------------------------------------------------------------------------------');
disp('n       RN for Interarrival Time    Interarrival Time    Arrival Time    Service Type');
disp('-------------------------------------------------------------------------------------');

for n=1:max_cars
    printf('%-4d    %-24d    %-17d    %-12d    %-12d\n', table1(n, :));
end

printf('\n\n');

disp('Wash Bay 1 Table:');
disp('-----------------------------------------------------------------------------------------------------------');
disp('n       RN for Service Time    Service Time    Service Begins    Service Ends    Waiting Time    Time Spent');
disp('-----------------------------------------------------------------------------------------------------------');

for n=1:length(indices_bay1)
    printf('%-4d    %-19d    %-12d    %-14d    %-12d    %-12d    %-10d\n', table2(n,:));
end

printf('\n\n');

disp('Wash Bay 2 Table:');
disp('-----------------------------------------------------------------------------------------------------------');
disp('n       RN for Service Time    Service Time    Service Begins    Service Ends    Waiting Time    Time Spent');
disp('-----------------------------------------------------------------------------------------------------------');
for n=1:length(indices_bay2)
    printf('%-4d    %-19d    %-12d    %-14d    %-12d    %-12d    %-10d\n', table3(n,:));
end

printf('\n\n');

disp('Wash Bay 3 Table:');
disp('-----------------------------------------------------------------------------------------------------------');
disp('n       RN for Service Time    Service Time    Service Begins    Service Ends    Waiting Time    Time Spent');
disp('-----------------------------------------------------------------------------------------------------------');
for n=1:length(indices_bay3)
    printf('%-4d    %-19d    %-12d    %-14d    %-12d    %-12d    %-10d\n', table4(n,:));
end

printf('\n');

% =====================================
% Print simulation results
% =====================================
avg_waiting_time = mean(waiting_time_col);
printf('Average waiting time (in general): %.2f\n', avg_waiting_time);

avg_waiting_time_bay1 = mean(waiting_time_col(indices_bay1));
avg_waiting_time_bay2 = mean(waiting_time_col(indices_bay2));
avg_waiting_time_bay3 = mean(waiting_time_col(indices_bay3));
printf('Average waiting time (Bay 1): %.2f\n', avg_waiting_time_bay1);
printf('Average waiting time (Bay 2): %.2f\n', avg_waiting_time_bay2);
printf('Average waiting time (Bay 3): %.2f\n', avg_waiting_time_bay3);

avg_inter_arrival_time = mean(inter_arrival_col);
printf('Average inter arrival time: %.2f\n', avg_inter_arrival_time);

avg_time_spent = mean(time_spent_col);
printf('Average time spent: %.2f\n', avg_time_spent);

prob_wait_in_queue = sum(waiting_time_col > 0) / max_cars;
printf('Probability that a car has to wait in queue: %.2f\n', prob_wait_in_queue);

avg_service_time_bay1 = mean(service_time_col(indices_bay1));
avg_service_time_bay2 = mean(service_time_col(indices_bay2));
avg_service_time_bay3 = mean(service_time_col(indices_bay3));
printf('Average service time (Bay 1): %.2f\n', avg_service_time_bay1);
printf('Average service time (Bay 2): %.2f\n', avg_service_time_bay2);
printf('Average service time (Bay 3): %.2f\n', avg_service_time_bay3);

avg_service_time = mean(service_time_col);
printf('Average service time (in general): %.2f\n', avg_service_time);
