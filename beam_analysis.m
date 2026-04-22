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

% Plotting
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

% V2: Deflection Analysis (Simply Supported Beam with Center Load) 

EI = E * I; % Flexural rigidity (beam stiffness)

v = zeros(1,n); % Deflection at each position along the beam (Meters)

for i = 1:n
    if x(i) <= L/2
        v(i) = (P * x(i) * (3 * L^2 - 4 * x(i)^2)) / (48 * EI);
    else
        v(i) = (P * (L - x(i)) * (3 * L^2 - 4 * (L - x(i))^2)) / (48 * EI);
    end
end

v = -v; % To make downward deflection negative
v_mm = abs(v) * 1000; % Convert Deflection to mm

figure;
hold on;
plot(x, v_mm, 'LineWidth', 2);
title('Deflection Profile of a Simply Supported Beam Under Center Load');
xlabel('Position Along Beam (m)');
ylabel('Deflection Magnitude (mm)');

yline(0, '--k'); % Reference line to make deflection easier to read

% Find maximum deflection point
[v_max, idx_max] = max(v_mm);
x_max = x(idx_max);

plot (x_max, v_max, 'ko', 'MarkerFaceColor', 'k');
text(x_max, v_max, sprintf(' Peak = %.1f mm', v_max), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');

% Resize frame of figure
xlim([0 L]);
ylim([0 max(v_mm) * 1.1]);

legend('Deflection', 'Peak Deflection', 'Location', 'best');

grid on;
hold off;