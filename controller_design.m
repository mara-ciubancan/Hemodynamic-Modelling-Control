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

%% PI Controller Design using the Guillemin-Truxal (GT) Method
% Imposed parameters: Settling time: ts = 30s; Overshoot: sigma = 5%
ts = 30;
sigma = 0.05;                                   
zeta = abs(log(sigma)) / sqrt(log(sigma)^2 + pi^2);  % Damping factor
wn = 4 / (zeta * ts);                                % Natural frequency
Ho_GT = tf(wn^2, [1 2*zeta*wn, wn^2]);               % Imposed closed-loop transfer function
Hc_GT = minreal((1/H_p) * (Ho_GT / (1-Ho_GT)));

hold on
y_sim_GT = 20 * step(Ho_GT, t);  %has a 20 amplitude to reach the steady-state of the process
plot(t, y_sim_GT);

%% PI Controller Design using the Internal Model Control (IMC) Method
% Imposed parameters: Settling time: ts = 30s; Filter time constant: lambda ~ ts/4; 
% IMC Filter: n = 1 (since Hc_IMC has one pole and one zero) 
ts = 30; 
lambda = ts/4; % ts/10                                          
n = 1;                                                   
F = tf(1, [lambda, 1^n])^n;                             % Filter transfer function 
Hc_IMC = 1 / H_p * F;                                   % Controller transfer function
Rc_IMC = minreal(Hc_IMC / minreal(1 - Hc_IMC * H_p));   % Equivalent controller transfer function
Hol_IMC = minreal(H_p * Rc_IMC);                        % Open-loop transfer function 
Ho_IMC = minreal(Hol_IMC / (1 + Hol_IMC));              % Closed-loop transfer function

y_sim_IMC = 20 * step(Ho_IMC, t);
hold on
plot(t, y_sim_IMC);
legend("MAP data", "Process TF H\_p", "Closed-loop TF Ho\_GT", "Closed-loop TF Ho\_IMC")

%% PI Controller Design using Frequency-Domain Design
% Imposed parameters: Gain crossover frequency: W_gc = 0.15 rad/s; Phase margin: PM = 85°
W_gc = 0.15;                                                             
PM =  85;   
 
phase_H_p = -atand(T_p * W_gc);                                          % Phase of the process transfer function
% phase_H_p = -51.340191745909905
phase_Hc = -180 + PM - phase_H_p;                                        % Phase of the controller transfer function
% phase_Hc = 58.659808254090095
modulus_H_p = k_p / (sqrt((T_p * W_gc)^2 + 1));                          % Modulus of the process transfer function

Ti_PI = tand(90 + phase_Hc) / W_gc;                                      % Controller time constant
ki_PI = (Ti_PI * W_gc) / (modulus_H_p * sqrt(Ti_PI^2 * W_gc^2 + 1));     % Controller integral gain
Hc_PI = minreal(ki_PI * (1 + tf(1, [Ti_PI 0])));                         % Controller transfer function

Hol_PI = minreal(H_p * Hc_PI);                                           % Open-loop transfer function
Ho_PI = minreal(Hol_PI / (1 + Hol_PI));                                  % Closed-loop transfer function

y_sim_PM = 20 * step(Ho_PI, t);
hold on
plot(t, y_sim_PM);
legend("MAP data", "Process TF H\_p", "Closed-loop TF Ho\_GT", "Closed-loop TF Ho\_IMC", "Closed-loop TF Ho\_PM")

%% PID Controller Design using Frequency-Domain Design
% Imposed parameters: Gain crossover frequency: W_gc = 0.15 rad/s; Phase margin: PM = 85°
W_gc = 0.15;          
PM = 85;            
n = 4;      % Ziegler-Nichols ratio (Ti = n*Td)

phase_Hp = rad2deg(angle(freqresp(H_p, W_gc)));     % Phase of the process transfer function
phase_Hc = -180 + PM - phase_Hp;                    % Phase of the controller transfer function

% For Ti=n*Td, the resulting phase of a PID controller is: n*Wc^2 * Td^2 - tan(angle)*n*Wc*Td - 1 = 0
% Quadratic equation: a*Td^2 + b*Td + c = 0
a = n * W_gc^2;
b = -tand(phase_Hc) * n * W_gc;
c = -1;

% Solve quadratic: Td = (-b +/- sqrt(b^2 - 4ac)) / 2a
delta = b^2 - 4*a*c;
Td = (-b + sqrt(delta)) / (2*a); % We take the positive root for the derivative time constant of the controller
Ti = n * Td;                     % Integral time constant of the controller               

% |Hc_PID| = kp * sqrt( 1 + (Td*W_gc - 1/(n*Td*W_gc))^2 )
mag_Hp = k_p / (sqrt((T_p * W_gc)^2 + 1));                 % Modulus of the process transfer function  
mag_Hc = sqrt(1 + (Td*W_gc - 1/(n*Td*W_gc))^2);            % Modulus of the controller transfer function (without kp)
kp_FO = 1 / (mag_Hc * mag_Hp);                             % Proportional gain of the controller

Hc_PID = pid(kp_FO, kp_FO/Ti, kp_FO*Td);                   % Controller transfer function
disp(Hc_PID)

Hol_PID = minreal(H_p * Hc_PID);                           % Open-loop transfer function
Ho_PID = minreal(Hol_PID / (1 + Hol_PID));                 % Closed-loop transfer function

y_sim_PID = 20 * step(Ho_PID, t);
hold on
plot(t, y_sim_PID);
legend("MAP data", "Process TF H\_p", "Closed-loop TF Ho\_GT", "Closed-loop TF Ho\_IMC", "Closed-loop TF Ho\_PM", "Closed-loop TF Ho\_PID")

%% PI Controller Design using Fractional-Order Control (FOC) Method
syms Wc;
Modulus = k_p/sqrt((T_p*Wc)^2+1);     % Modulus of process transfer function
Phase = -atan(T_p*Wc);                % Phase of process transfer function

Wc = 0.15; %0.155                      

phase_Hp = eval(Phase);               % Process phase in rad 
mag_Hp = eval(Modulus);               % Modulus of process transfer function
phase_deriv = eval(diff(Phase));      % The derivative of the process phase

% FO-PI controller design 
PM = 85*pi/180;   %90                 % Imposed phase margin       
W_gc = Wc;                            % Imposed gain crossover frequency

data1=[];data2=[];data3=[];           % Initialising the datasets
f=2;                                  % Imposed maximum range value

for lambda = 0:0.01:f                 % Range of fractional integration order lambda

    % Notations for segments of the equations
    z1 = lambda*W_gc^(-lambda-1) * sin(pi*lambda/2);
    z2 = 2*W_gc^(-lambda) * cos(pi*lambda/2);
    z3 = W_gc^(-2*lambda);

    % Computing ki values from the gain robustness equation (quadratic equation => two solutions)
    ki1 = -((z1 + z2*phase_deriv) + sqrt((z1 + z2*phase_deriv)^2 - 4*z3*phase_deriv^2)) / (2*z3*phase_deriv);
    ki2 = -((z1 + z2*phase_deriv) - sqrt((z1 + z2*phase_deriv)^2 - 4*z3*phase_deriv^2)) / (2*z3*phase_deriv);

    % Computing ki value from the phase margin equation
    ki3 = (tan(pi - PM + phase_Hp) * (W_gc^lambda)) / (sin(pi*lambda/2) - (tan(pi - PM + phase_Hp) * cos(pi*lambda/2)));

    data1=[data1; ki1]; data2=[data2; ki2]; data3=[data3; ki3];
end

lambda = 0:0.01:f;
figure, plot(lambda, data1, 'r')
hold on, plot(lambda, data3, 'b'), title('ki1 vs ki3'), grid

figure, plot(lambda, data2, 'r')
hold on, plot(lambda, data3, 'b'), title('ki2 vs ki3'), grid
% Select the value for lambda at the intersection point
lambda = 0.954;   %0.845   

% Recompute ki for the lambda above and check if ki1 = ki3 or ki2 = ki3
    z1 = lambda*W_gc^(-lambda-1) * sin(pi*lambda/2);
    z2 = 2*W_gc^(-lambda) * cos(pi*lambda/2);
    z3 = W_gc^(-2*lambda);
    
    % ki1 and ki2 are derived from the robustness equation
    ki1 = -((z1 + z2*phase_deriv) + sqrt((z1 + z2*phase_deriv)^2 - 4*z3*phase_deriv^2)) / (2*z3*phase_deriv);
    ki2 = -((z1 + z2*phase_deriv) - sqrt((z1 + z2*phase_deriv)^2 - 4*z3*phase_deriv^2)) / (2*z3*phase_deriv);
    % ki3 is derived from the phase equation
    ki3 = (tan(pi - PM + phase_Hp) * (W_gc^lambda)) / (sin(pi*lambda/2) - (tan(pi - PM + phase_Hp) * cos(pi*lambda/2)));

% Select ki as the common value
ki_FO = ki3;     % Controller integral time constant
 
kp_FO = (1/mag_Hp) / (sqrt(1 + 2*ki_FO*(W_gc^(-lambda)) * cos(pi*lambda/2) + (ki_FO^2)*W_gc^(-2*lambda)));  % Controller proportional time constant

% Fractional-order operator s^(-lambda) approximation using Oustaloup Recursive Approximation (ORA) improved by Robin
alfa1 = 1 - lambda;
s_alfa1 = ora_foc_RdK(alfa1, 3, W_gc/100, W_gc*100);                % Approximation of 1/s^(1-lambda)

FO_PI = minreal(kp_FO + kp_FO*ki_FO*tf(1,[1 0])*s_alfa1, 0.1);      % Controller transfer function

Hol_FO = minreal(H_p * FO_PI);                                      % Open-loop transfer function
Ho_FO = minreal(Hol_FO / (1 + Hol_FO));                             % Closed-loop transfer function

y_sim_FO = 20 * step(Ho_FO, t);
hold on
plot(t, y_sim_FO);
legend("MAP data", "Process TF H\_p", "Closed-loop TF Ho\_GT", "Closed-loop TF Ho\_IMC", "Closed-loop TF Ho\_PM", "Closed-loop TF Ho\_PID", "Closed-loop TF Ho\_FO")
