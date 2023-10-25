clc;
% Prompt the user for input or use saved tensor stresses
use_saved_stresses = input('Do you want to use saved tensor stresses? (y/n): ', 's');

if strcmpi(use_saved_stresses, 'y')
    % Given stress tensor components

else
    % Prompt the user for tensor stresses
    sigma_x = input('Enter sigma_x: ');
    sigma_y = input('Enter sigma_y: ');
    sigma_z = input('Enter sigma_z: ');
    tau_xy = input('Enter tau_xy: ');
    tau_xz = input('Enter tau_xz: ');
    tau_yz = input('Enter tau_yz: ');
end

% Create the stress tensor
S = [sigma_x, tau_xy, tau_xz;
    tau_xy, sigma_y, tau_yz;
    tau_xz, tau_yz, sigma_z];

% Calculate the eigenvalues (principal stresses)
principal_stresses = eig(S);

% Calculate the radii and centers of the Mohr's circles
R1 = 0.5 * (principal_stresses(3) - principal_stresses(2));
R2 = 0.5 * (principal_stresses(3) - principal_stresses(1));
R3 = 0.5 * (principal_stresses(2) - principal_stresses(1));
center1 = [(principal_stresses(3) + principal_stresses(2)) / 2, 0];
center2 = [(principal_stresses(3) + principal_stresses(1)) / 2, 0];
center3 = [(principal_stresses(2) + principal_stresses(1)) / 2, 0];

% Create the 2D plot
figure;
hold on;

% Plot the first Mohr's circle
theta1 = linspace(0, 2 * pi, 100);
X1 = R1 * cos(theta1) + center1(1);
Y1 = R1 * sin(theta1) + center1(2);
plot(X1, Y1, 'b', 'LineWidth', 2);

% Plot the second Mohr's circle
theta2 = linspace(0, 2 * pi, 100);
X2 = R2 * cos(theta2) + center2(1);
Y2 = R2 * sin(theta2) + center2(2);
plot(X2, Y2, 'r', 'LineWidth', 2);

% Plot the third Mohr's circle
theta3 = linspace(0, 2 * pi, 100);
X3 = R3 * cos(theta3) + center3(1);
Y3 = R3 * sin(theta3) + center3(2);
plot(X3, Y3, 'g', 'LineWidth', 2);

title('3 Mohr''s Circles with Principal Stresses');
xlabel('Normal Stress (\sigma)');
ylabel('Shear Stress (\tau)');

grid on;
axis equal;
legend('Mohr''s Circle 1', 'Mohr''s Circle 2', 'Mohr''s Circle 3');

% Display the principal stresses in the terminal with σ symbol
disp('Principal Stresses:');
disp(['σ1 = ', num2str(principal_stresses(3))]);
disp(['σ2 = ', num2str(principal_stresses(2))]);
disp(['σ3 = ', num2str(principal_stresses(1))]);
disp(['τ1/2 = ', num2str(R3)]);
disp(['τ1/3 = ', num2str(R2)]);
disp(['τ2/3 = ', num2str(R1)]);
% Von Mises stress calculation
sigma_vm = sqrt(0.5 * ((principal_stresses(1) - principal_stresses(2))^2 + (principal_stresses(2) - principal_stresses(3))^2 + (principal_stresses(3) - principal_stresses(1))^2));

% Tresca stress calculation
tau_max = 0.5 * max([abs(principal_stresses(1) - principal_stresses(2)), 
                    abs(principal_stresses(2) - principal_stresses(3)), 
                    abs(principal_stresses(3) - principal_stresses(1))]);

disp(['Von Mises Stress = ', num2str(sigma_vm)]);
disp(['Maximum Shear Stress (Tresca) = ', num2str(tau_max)]);

% Check for stress failure
check_failure = input('Do you want to check for stress failure? (y/n): ', 's');
if strcmpi(check_failure, 'y')
    Sy = input('Enter yield stress: ');
    
    safety_factor_vm = Sy / sigma_vm;
    safety_factor_tresca = Sy / (2 * tau_max);
    
    disp(['Safety Factor (Von Mises) = ', num2str(safety_factor_vm)]);
    disp(['Safety Factor (Tresca) = ', num2str(safety_factor_tresca)]);
    
    if sigma_vm > Sy
        disp('Material will fail according to Von Mises criterion.');
    else
        disp('Material is safe according to Von Mises criterion.');
    end
    
    if tau_max > Sy/2
        disp('Material will fail according to Tresca criterion.');
    else
        disp('Material is safe according to Tresca criterion.');
    end
end