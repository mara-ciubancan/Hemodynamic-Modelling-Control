load('nor_map_cases\vitaldb_case_5478.mat')

% 1. Cleaning the NOR input signal
% We use 'previous' (Forward Fill / Zero-Order Hold) to replace NaNs with the 
% last valid recorded value

U_NE_clean = fillmissing(U_NE, 'previous');

% Fill any NaNs that might exist at the very beginning of the series 
% by using the 'next' valid value.

U_NE_clean = fillmissing(U_NE_clean, 'next');

% 2. Cleaning the MAP output signal
% We apply the same cleaning method to the output signal

Y_MAP_clean = fillmissing(Y_MAP, 'previous');
Y_MAP_clean = fillmissing(Y_MAP_clean, 'next');

% 3. Final validation
% We find the indices where both signals are non-NaN (after cleaning) and truncate the dataset.

valid_indices = ~isnan(Y_MAP_clean) & ~isnan(U_NE_clean);

T_final = T(valid_indices);
Y_MAP_final = Y_MAP_clean(valid_indices);
U_NE_final = U_NE_clean(valid_indices);

% 4. Display the results
figure;
subplot(2,1,1);
plot(T_final, U_NE_final, 'b');
title('Input: Norepinephrine Rate (U)');
xlabel('Time (s)');
ylabel('Infusion Rate (mL/hr)');
grid on;

subplot(2,1,2);
plot(T_final, Y_MAP_final, 'r');
title('Output: Mean Arterial Pressure (Y)');
xlabel('Time (s)');
ylabel('MAP (mmHg)');
grid on;
