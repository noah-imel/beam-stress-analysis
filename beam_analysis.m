L = 1; % Length (Meters)
P = 2000; % Load (Newtons)
b = 0.01; % Width (Meters)
h = 0.01; % Height (Meters)
E = 2e11; % Young's Modulus of Steel (Pascals)
n = 200; % Number of Points Across the Beam

I = (b * h^3) / 12; % Moment of Inertia (Rectangular Cross-Section) (Meters^4)

c = h/2; % Distance to Outer Fiber (Meters)

% R1 + R2 should equal P due to equilibrium
R1 = P/2;
R2 = P/2;

% Vector of n positions along the beam
x = linspace(0, L, n); 

% Compute bending moment M(x) along the beam
M = zeros(1, n);
for i = 1:n
    if x(i) <= L/2
        M(i) = R1 * x(i); % Moment from left support (before load at center)
    else
        M(i) = R2 * (L - x(i)); % Moment decreasing toward right support (after load)
    end
end

% Compute bending stress distribution along the beam (outer fiber)
% Using magnitude only to simplify the model and clearly verify correctness
% (Will change later
sigma = (abs(M) * c) / I; % Pascals

% Converting Sigma From Pascals to MPa
stress_MPa = sigma / 1e6;

% Typical yield strength of steel
sigma_yield = 250; % MPa



figure;
hold on
plot(x, stress_MPa, 'LineWidth', 2);
title ('Bending Stress Distribution (Simply Supported Beam)');
xlabel('Position Along Beam (m)');
ylabel('Stress (MPa)');
grid on;

% Highlight the yield strength line for comparison
yline(sigma_yield, '--r', 'Yield', 'LineWidth', 1.5);
legend('Bending Stress', 'Location', 'Best');

% Display maximum bending stress and its position
[sigma_max, idx_max] = max(stress_MPa);
x_max = x(idx_max);
plot(x_max, sigma_max, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Max Stress');

% Finding Abolute Max on Graph
text(x_max, sigma_max, sprintf('Max = %.1f MPa', sigma_max), 'VerticalAlignment', 'top', 'HorizontalAlignment', 'center');

legend('Bending Stress', 'Yield Strength', 'Max Stress', 'Location', 'Best');

% Gives Space Above Max Stress Level to Better View Data
ylim([0 max(stress_MPa) * 1.12]);

hold off




