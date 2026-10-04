%% System Identification
plotMAP(MAP-MAP.Data(1))      % MAP response to 400 mL/h NOR input (without initial conditions - 
% substracting the baseline MAP to start from 0)
Ts_p = 50;                    % Settling time 
T_p = Ts_p/4;                 % Process time constant
k_p = 20/400;                 % Process gain
H_p = tf(k_p, [T_p, 1]);      % Identified process transfer function 
hold on
t = 0:0.5:200;                
y_sim = 400 * step(H_p, t);   % Computing the step response of the process transfer function       
plot(t, y_sim);