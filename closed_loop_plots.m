%% System Identification plots
plotMAP(MAP-MAP.Data(1))
hold on
% H_p(s)
t = 0:0.5:200;                
y_sim = 400 * step(H_p, t);     % Computing the step response of the process transfer function
plot(t, y_sim);
title("Comparison between \Delta MAP[mmHg] and H\_p(s)")
legend("\Delta MAP [mmHg]", "Process Transfer Function H\_p(s)")

%% Comparison between closed-loop responses of the Integer-Order Methods
figure
% H_p(s)
t = 0:0.5:200;                
y_sim = 400 * step(H_p, t);   
plot(t, y_sim);

% GT
hold on
y_sim_GT = 20 * step(Ho_GT, t);
plot(t, y_sim_GT);

% PI with PM
y_sim_PM = 20 * step(Ho_PI, t);
hold on
plot(t, y_sim_PM);

% PID with PM
y_sim_PID = 20 * step(Ho_PID, t);
hold on
plot(t, y_sim_PID);

% IMC
y_sim_IMC = 20 * step(Ho_IMC, t);
hold on
plot(t, y_sim_IMC);

title("Comparison of closed-loop responses under integer-order control strategies against the identified process model H\_p(s)")
legend("Process Transfer Function H\_p(s)", "Closed-loop Transfer Function Ho\_GT", "Closed-loop Transfer Function Ho\_PI", "Closed-loop Transfer Function Ho\_PID", "Closed-loop Transfer Function Ho\_IMC")

%% Comparison between closed-loop responses of IO-PID and FO-PID
figure
% H_p(s)
t = 0:0.5:200;                
y_sim = 400 * step(H_p, t); 
plot(t, y_sim);

% FO-PI
y_sim_FO = 20 * step(Ho_FO, t);
hold on
plot(t, y_sim_FO);

% PID with PM
y_sim_PID = 20 * step(Ho_PID, t);
hold on
plot(t, y_sim_PID);

title("Comparison of closed-loop response under FO-PI strategy against closed-loop response under IO-PID control strategy and against the identified process model H\_p(s)")
legend("Process Transfer Function H\_p(s)", "Closed-loop Transfer Function Ho\_FO", "Closed-loop Transfer Function Ho\_PID")


%%  Comparison between closed-loop responses of FO-PID and IO-PI
figure
% H_p(s)
t = 0:0.5:200;                
y_sim = 400 * step(H_p, t); 
plot(t, y_sim);

% FO-PI
y_sim_FO = 20 * step(Ho_FO, t);
hold on
plot(t, y_sim_FO);

% PI with PM
y_sim_PM = 20 * step(Ho_PI, t);
hold on
plot(t, y_sim_PM);

title("Comparison of closed-loop response under FO-PI strategy against closed-loop response under IO-PI control strategy and against the identified process model H\_p(s)")
legend("Process Transfer Function H\_p(s)", "Closed-loop Transfer Function Ho\_FO", "Closed-loop Transfer Function Ho\_PI")

%% Comparison between all closed-loop responses 
figure
% H_p(s)
t = 0:0.5:200;                
y_sim = 400 * step(H_p, t);   
plot(t, y_sim);

% GT
hold on
y_sim_GT = 20 * step(Ho_GT, t);
plot(t, y_sim_GT);

% PI with PM
y_sim_PM = 20 * step(Ho_PI, t);
hold on
plot(t, y_sim_PM);

% PID with PM
y_sim_PID = 20 * step(Ho_PID, t);
hold on
plot(t, y_sim_PID);

% IMC
y_sim_IMC = 20 * step(Ho_IMC, t);
hold on
plot(t, y_sim_IMC);

% FO-PI
y_sim_FO = 20 * step(Ho_FO, t);
hold on
plot(t, y_sim_FO);

title("Comparison of closed-loop responses under integer-order control strategies against the identified process model H\_p(s)")
legend("Process Transfer Function H\_p(s)", "Closed-loop Transfer Function Ho\_GT", "Closed-loop Transfer Function Ho\_PI", "Closed-loop Transfer Function Ho\_PID", "Closed-loop Transfer Function Ho\_IMC", "Closed-loop Transfer Function Ho\_FO")