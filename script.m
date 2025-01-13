clc; clear; close all;

%% Initial Conditions
initial_theta1 = 0.4;
initial_theta2 = 0.4;
dtheta1 = 0;
dtheta2 = 0;

%% Initialization and Numerical Integration Setup
x = [initial_theta1; dtheta1; initial_theta2; dtheta2];

h = 1;  % Integration step size (seconds)
T = 0:h:60; % Time interval
n = length(T);
F_input = 0; % Constant force
X = zeros(4, n);
X(:, 1) = x;

% Precompute Runge-Kutta integration
for i = 1:n-1
    X_current = X(:, i);
    
    k1 = Runge_Kutta(X_current, F_input);
    k2 = Runge_Kutta(X_current + h * k1 / 2, F_input);
    k3 = Runge_Kutta(X_current + h * k2 / 2, F_input);
    k4 = Runge_Kutta(X_current + h * k3, F_input);
    X(:, i+1) = X_current + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4);
end

%% Phase Portraits
% Extract results
theta1 = X(1, :); 
dtheta1 = X(2, :);
theta2 = X(3, :); 
dtheta2 = X(4, :);

figure;

subplot(3, 1, 1);
plot(theta1, dtheta1, 'y', 'LineWidth', 1.5);
xlabel('\theta_1 (rad)');
ylabel('d\theta_1/dt (rad/s)');
title('Phase Portrait: d\theta_1/dt(\theta_1)');
grid on;

subplot(3, 1, 2);
plot(theta2, dtheta2, 'c', 'LineWidth', 1.5);
xlabel('\theta_2 (rad)');
ylabel('d\theta_2/dt (rad/s)');
title('Phase Portrait: d\theta_2/dt(\theta_2)');
grid on;

subplot(3, 1, 3);
plot(theta1, theta2, 'k', 'LineWidth', 1.5);
xlabel('\theta_1 (rad)');
ylabel('\theta_2 (rad)');
title('Relationship \theta_2(\theta_1)');
grid on;

%% Integration Error Evaluation
% Obtain Runge-Kutta results
yrk = [theta1; theta2];

% Simulate in Simulink
F = 0;
F = timeseries(F, T);
out = sim("model.slx");

tslx = out.tout;
ysl = [out.simout.Data'; out.simout1.Data'];
ysl_interp = interp1(tslx, ysl', T, "linear")';

% Compute integration error
diff_y = ysl_interp - yrk;
integration_error = vecnorm(diff_y, 2, 1); % Norm-2

figure;
subplot(2, 1, 1);
plot(T, integration_error, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Integration Error (Norm-2)');
title('Integration Error between Simulink and RK4');
grid on;

subplot(2, 1, 2);
plot(T, theta1, 'r', 'DisplayName', 'Runge-Kutta');
hold on;
plot(T, ysl_interp(1, :), 'b--', 'DisplayName', 'Simulink');
xlabel('Time (s)');
ylabel('\theta_1 (rad)');
legend;
title('Difference between Runge-Kutta and Simulink for \theta_1');
hold off;

%% Dependency of Final State on Force
F_values = 1:1:50;
t = linspace(0, 60);
theta1_final = zeros(50, 1);
theta2_final = zeros(50, 1);

for i = 1:50
    F = F_values(i);
    F = timeseries(F, t);
    out = sim("model.slx");
    theta1_final(i) = out.simout.Data(end);
    theta2_final(i) = out.simout1.Data(end);
end

figure;
subplot(2, 1, 1);
plot(F_values, theta1_final, 'o-', 'LineWidth', 1.5);
xlabel('F_m^*(N)');
ylabel('\theta_1^*(rad)');
title('Dependency \theta_1^* on F_m^*');
grid on;

subplot(2, 1, 2);
plot(F_values, theta2_final, 'o-', 'LineWidth', 1.5);
xlabel('F_m^*(N)');
ylabel('\theta_2^*(rad)');
title('Dependency \theta_2^* on F_m^*');
grid on;

%% Polynomial Approximation
coeff_theta1 = polyfit(F_values, theta1_final, 7);
coeff_theta2 = polyfit(F_values, theta2_final, 7);
theta1_approx = polyval(coeff_theta1, F_values);
theta2_approx = polyval(coeff_theta2, F_values);

figure;
subplot(2, 1, 1);
plot(F_values, theta1_final, 'o', 'DisplayName', 'Actual Points');
hold on;
plot(F_values, theta1_approx, 'DisplayName', 'Approximation', 'LineWidth', 1.5);
xlabel('F_m^*(N)');
ylabel('\theta_1^*(rad)');
title('Polynomial Approximation for \theta_1^*(F_m^*)');
legend;
hold off;

subplot(2, 1, 2);
plot(F_values, theta2_final, 'o', 'DisplayName', 'Actual Points');
hold on;
plot(F_values, theta2_approx, 'DisplayName', 'Approximation', 'LineWidth', 1.5);
xlabel('F_m^*(N)');
ylabel('\theta_2^*(rad)');
title('Polynomial Approximation for \theta_2^*(F_m^*)');
legend;
hold off;

%% Multiplicative Uncertainty
F = 0;
F = timeseries(F, t);
perturbed_theta2 = initial_theta2;
alpha = 0.1 * randn(100, 1);

figure;

subplot(2, 1, 1);
hold on; 
xlabel('Time (s)');
ylabel('\theta_1 (rad)');
title('Evolution of \theta_1');
grid on;

subplot(2, 1, 2);
hold on;
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Evolution of \theta_2');
grid on;

for i = 1:100
    perturbed_theta2 = (1 + alpha(i)) * initial_theta2;
    x(3) = perturbed_theta2;
    out = sim("model.slx");

    subplot(2, 1, 1);
    plot(out.tout, out.simout.Data, 'LineWidth', 0.5);

    subplot(2, 1, 2);
    plot(out.tout, out.simout1.Data, 'LineWidth', 0.5);
end

subplot(2, 1, 1);
hold off;

subplot(2, 1, 2);
hold off;

%% Additive Uncertainty
F = 0;
F = timeseries(F, t);
initial_theta2 = perturbed_theta2;
perturbed_theta1 = initial_theta1;
alpha = 5 * randn(100, 1);

figure;

subplot(2, 1, 1);
hold on;
xlabel('Time (s)');
ylabel('\theta_1 (rad)');
title('Evolution of \theta_1');
grid on;

subplot(2, 1, 2);
hold on;
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Evolution of \theta_2');
grid on;

for i = 1:100
    initial_theta1 = alpha(i) + perturbed_theta1;
    out = sim("model.slx");
    
    subplot(2, 1, 1);
    plot(out.tout, out.simout.Data, 'LineWidth', 0.5);
    
    subplot(2, 1, 2);
    plot(out.tout, out.simout1.Data, 'LineWidth', 0.5);
end

subplot(2, 1, 1);
hold off;

subplot(2, 1, 2);
hold off;

%% Exogenous Signal Analysis
F = randn(length(T), 1);
F = timeseries(F, T);
out = sim("model.slx");

dtheta1 = diff(out.simout.Data);
dtheta2 = diff(out.simout1.Data);
ddtheta1 = diff(dtheta1) / h;
ddtheta2 = diff(dtheta2) / h;
time = out.tout(1:end-2);

figure;
subplot(3, 1, 1);
plot(time, ddtheta1);
xlabel('Time (s)');
ylabel('\theta_1 (rad)');
title('Second Discrete Derivative of \theta_1');
grid on;

subplot(3, 1, 2);
plot(time, ddtheta2);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Second Discrete Derivative of \theta_2');
grid on;

subplot(3, 1, 3);
plot(T, F.Data);
ylabel('F(N)');
xlabel('Time (s)');
title('Force');
