% Load data into a variable
data = load('Helium_Hydrogen_linear.txt');
x = data(:, 1);
y = data(:, 2);
x_error = data(:, 3);
y_error = data(:, 4);

% Perform linear regression using the least squares method with errors
weights = 1./y_error.^2; % Weights for weighted least squares
A = [x.*weights, ones(size(x)).*weights]; % Design matrix [x, 1] with weights
params = (A' * A)\(A' * (y.*weights)); % Parameter estimates [slope, intercept]

% Calculate standard errors of parameter estimates
cov_matrix = inv(A' * A);
se = sqrt(diag(cov_matrix));

% Confidence intervals (95%)
alpha = 0.05;
t_critical = tinv(1 - alpha/2, length(x) - length(params));
conf_interval = [params - t_critical*se, params + t_critical*se];

% Plot the data points with error bars
figure; % Create a new figure
errorbar(x, y, y_error*2, y_error*2, x_error*2, x_error*2, 'o', 'MarkerSize', 2, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'LineWidth', 1.5, 'CapSize', 0);

hold on;

% Plot the line of best fit
fit_line = params(1) * x + params(2);
plot(x, fit_line, 'r-', 'LineWidth', 2);

% Add labels and title
xlabel('X Data');
ylabel('Y Data');
title('Linear Regression with Least Squares Method');

% Display parameter estimates, standard errors, and confidence intervals
disp('Parameter Estimates:');
disp(['Slope: ', num2str(params(1))]);
disp(['Intercept: ', num2str(params(2))]);

disp('Standard Errors:');
disp(['SE(Slope): ', num2str(se(1))]);
disp(['SE(Intercept): ', num2str(se(2))]);

disp('Confidence Intervals (95%):');
disp(['Slope CI: [', num2str(conf_interval(1, 1)), ', ', num2str(conf_interval(1, 2)), ']']);
disp(['Intercept CI: [', num2str(conf_interval(2, 1)), ', ', num2str(conf_interval(2, 2)), ']']);

hold off; % Release the "hold on" state for the current axes

% Calculate residuals
residuals = y - fit_line;
figure
errorbar(x, residuals, y_error, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
hold on;
plot([min(x), max(x)], [0, 0], 'r', 'LineWidth', 2); % Add a red horizontal line at y = 0
xlabel('x');
ylabel('Residuals');
title('Residuals vs Position');

% Calculate chi-square statistic
chi_square = sum((residuals ./ y_error).^2);

% Calculate R-squared
y_mean = mean(y);
ss_total = sum((y - y_mean).^2);
ss_residual = sum(residuals.^2);
r_squared = 1 - (ss_residual / ss_total);

% Root Mean Square Error (RMSE)
rmse = sqrt(mean(residuals.^2));

% Display goodness-of-fit results
fprintf('Chi-Square: %.4f\n', chi_square);
fprintf('R-squared: %.4f\n', r_squared);
fprintf('RMSE: %.4f\n', rmse);

figure
qqplot(residuals);
