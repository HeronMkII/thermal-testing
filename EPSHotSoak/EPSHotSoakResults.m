%%%%%%%%%%% EPS HOT SOAK RESULTS %%%%%%%%%%%%

clear; clc; close all;
%% Section 1.1: Voltage over Time during the Hot Soak

% The following plots voltage against time for the entirety of the test.
% Breaks and pauses in data collection were neglected.

addpath('EPSdata');
data1 = readtable('Capture2');
data2 = readtable('Capture3');

EPSdata = [data1; data2];

time = [EPSdata.Var1];
batvol = [EPSdata.Var2];
bbvol = [EPSdata.Var8];
btvol = [EPSdata.Var10];

timevec = zeros(length(time),1);

chambertemp = 60*ones(length(timevec),1);

% Converting the printed time values to seconds elapsed since the
% beginning.
for i = 1:length(time)
    time{i} = datevec(time{i}, 'HH:MM:SS');
    hourvec(i) = time{i,1}(4);
    minutevec(i) = time{i,1}(5);
    secondvec(i) = time{i,1}(6);
    timevec(i) = 3600*hourvec(i) + 60*minutevec(i) + secondvec(i);
    % Need to track a start time so that the x-axis can track the time
    % elapsed.
    start_time = 3600*hourvec(1) + 60*minutevec(1) + secondvec(1);
    timevec(i) = timevec(i) - start_time;
end

figure
plot(timevec,batvol)
hold on;
plot(timevec,bbvol)
plot(timevec,btvol)
xlabel('Time Elapsed (s)');
ylabel('Voltage (V)');
legend('Bat Vol(V)','BB Vol(V)', 'BT Vol(V)');
title('Hot Soak Voltages at 60C')

%% Section 1.2 - Current over Time from the Hot Soak

batcur = [EPSdata.Var3];
negycur = [EPSdata.Var4];
posxcur = [EPSdata.Var5];
posycur = [EPSdata.Var6];
negxcur = [EPSdata.Var7];
bbcur = [EPSdata.Var9];
btcur = [EPSdata.Var11];

figure
plot(timevec,batcur)
hold on;
plot(timevec,bbcur)
plot(timevec,btcur)
xlabel('Time (s)')
ylabel('Current (A)');
legend('Bat Cur (A)', 'BB Cur (A)', 'BT Cur (A)')
title('Bat, BB, and BT Hot Soak Currents')

figure
plot(timevec,negycur)
hold on;
plot(timevec,posycur)
xlabel('Time (s)')
ylabel('Current (A)');
legend('+Y Cur (A)', '-Y Cur(A)')
title('Y Hot Soak Currents')

figure
plot(timevec,negxcur)
hold on;
plot(timevec,posxcur)
xlabel('Time (s)')
ylabel('Current (A)');
legend('+X Cur (A)', '-X Cur(A)')
title('X Hot Soak Currents')

%% IMU Gyroscope Measurements
x_uncal = [EPSdata.Var16];
y_uncal = [EPSdata.Var17];
z_uncal = [EPSdata.Var18];
x_cal = [EPSdata.Var19];
y_cal = [EPSdata.Var20];
z_cal = [EPSdata.Var21];

figure
plot(timevec, x_uncal)
hold on;
plot(timevec, y_uncal)
plot(timevec, z_uncal)
xlabel('Time (s)')
ylabel('IMU Measurements')
legend('X-axis', 'Y-axis', 'Z-axis')
title('Uncalibrated IMU Hot Soak Measurements')

figure
plot(timevec, x_cal)
hold on;
plot(timevec, y_cal)
plot(timevec, z_cal)
xlabel('Time (s)')
ylabel('IMU Measurements')
legend('X-axis', 'Y-axis', 'Z-axis')
title('Calibrated IMU Hot Soak Measurements')
