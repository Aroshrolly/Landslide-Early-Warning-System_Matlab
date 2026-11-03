%% ============================================================
% MUNNAR / IDUKKI LANDSLIDE EARLY WARNING SYSTEM
%
% AI TRAINING FOR:
%   1. RISK LEVEL
%   2. RISK PERCENTAGE
%   3. TIME TO FAILURE (TTF)
%
% NO STATISTICS AND MACHINE LEARNING TOOLBOX REQUIRED
% ============================================================

clear;
clc;
close all;


%% ============================================================
% 1. MUNNAR / IDUKKI DATASET
% ============================================================

Time = [0;
        18;
        30;
        36;
        39;
        41;
        41.75;
        42];

TTF = [42;
       24;
       12;
       6;
       3;
       1;
       0.25;
       0];

Rainfall = [0;
            85;
            185;
            270;
            350;
            420;
            450;
            465];

SoilMoisture = [18.0;
                38.2;
                49.5;
                54.1;
                57.0;
                58.2;
                58.4;
                58.4];

PorePressure = [-15.0;
                -2.1;
                 4.5;
                16.8;
                26.0;
                34.5;
                41.0;
                NaN];

FS = [1.85;
      1.42;
      1.28;
      1.12;
      1.05;
      1.01;
      0.99;
      0.60];

Tilt = [0.02;
        0.08;
        0.18;
        0.52;
        1.15;
        2.05;
        4.80;
        18.00];

Strain = [12;
          85;
          240;
          580;
          1250;
          2850;
          NaN;
          NaN];


%% ============================================================
% 2. DATASET INFORMATION
% ============================================================

fprintf('\n============================================\n');
fprintf('DATASET INFORMATION\n');
fprintf('============================================\n');

fprintf('Total observations = %d\n',length(TTF));


%% ============================================================
% 3. CREATE RISK LEVEL LABELS
% ============================================================
%
% 1 = GREEN
% 2 = YELLOW
% 3 = ORANGE
% 4 = RED
%
% Based on the Munnar/Idukki sequence and FS progression.
%
% These are PROJECT LABELS, not universal field thresholds.
% ============================================================

RiskLevel = zeros(length(TTF),1);

for i = 1:length(TTF)

    if FS(i) <= 1.00

        RiskLevel(i) = 4;       % RED

    elseif FS(i) <= 1.15

        RiskLevel(i) = 3;       % ORANGE

    elseif FS(i) <= 1.42

        RiskLevel(i) = 2;       % YELLOW

    else

        RiskLevel(i) = 1;       % GREEN

    end

end


%% ============================================================
% 4. CREATE RISK PERCENTAGE TARGET
% ============================================================
%
% Risk percentage is NOT present in the original dataset.
%
% Therefore we construct a project-defined risk score using:
%
%   Rainfall
%   Soil moisture
%   Pore pressure
%   Factor of Safety
%   Tilt
%   Strain
%
% Each parameter is normalized between 0 and 1.
% ============================================================


% ---- Normalize Rainfall ----

RainScore = ...
    (Rainfall - min(Rainfall)) ./ ...
    (max(Rainfall) - min(Rainfall));


% ---- Normalize Moisture ----

MoistScore = ...
    (SoilMoisture - min(SoilMoisture)) ./ ...
    (max(SoilMoisture) - min(SoilMoisture));


% ---- Normalize Pore Pressure ----

PWP_temp = PorePressure;

% Replace missing PWP temporarily

PWP_temp(~isfinite(PWP_temp)) = ...
    max(PWP_temp(isfinite(PWP_temp)));

PoreScore = ...
    (PWP_temp - min(PWP_temp)) ./ ...
    (max(PWP_temp) - min(PWP_temp));


% ---- Factor of Safety ----
%
% Lower FS = higher risk

FSscore = ...
    (max(FS) - FS) ./ ...
    (max(FS) - min(FS));


% ---- Tilt ----

TiltScore = ...
    (Tilt - min(Tilt)) ./ ...
    (max(Tilt) - min(Tilt));


% ---- Strain ----

Strain_temp = Strain;

Strain_temp(~isfinite(Strain_temp)) = ...
    max(Strain_temp(isfinite(Strain_temp)));

StrainScore = ...
    (Strain_temp - min(Strain_temp)) ./ ...
    (max(Strain_temp) - min(Strain_temp));


%% ============================================================
% 5. WEIGHTED RISK SCORE
% ============================================================

RiskScore = ...
      0.10 * RainScore ...
    + 0.10 * MoistScore ...
    + 0.15 * PoreScore ...
    + 0.30 * FSscore ...
    + 0.15 * TiltScore ...
    + 0.20 * StrainScore;


RiskPercent = RiskScore * 100;


% Limit to 0-100

RiskPercent = max(min(RiskPercent,100),0);


%% ============================================================
% 6. DISPLAY TARGET DATA
% ============================================================

fprintf('\n============================================\n');
fprintf('RISK TARGETS\n');
fprintf('============================================\n');

fprintf('\nTime    TTF       Risk Level       Risk %%\n');

fprintf('--------------------------------------------\n');

for i = 1:length(TTF)

    fprintf('%5.2f   %6.2f h        %d          %6.2f %%\n', ...
        Time(i), ...
        TTF(i), ...
        RiskLevel(i), ...
        RiskPercent(i));

end


%% ============================================================
% 7. CREATE INPUT MATRIX
% ============================================================

% AI INPUTS:
%
% X1 = Rainfall
% X2 = Soil Moisture
% X3 = Pore Pressure
% X4 = Factor of Safety
% X5 = Tilt
% X6 = Strain

X = [ ...
    Rainfall, ...
    SoilMoisture, ...
    PorePressure, ...
    FS, ...
    Tilt, ...
    Strain];


%% ============================================================
% 8. REMOVE INCOMPLETE SENSOR ROWS
% ============================================================

valid = all(isfinite(X),2);

Xvalid = X(valid,:);

YRisk = RiskLevel(valid);

YPercent = RiskPercent(valid);

YTTF = TTF(valid);

TimeValid = Time(valid);


fprintf('\n============================================\n');

fprintf('AI TRAINING DATA\n');

fprintf('============================================\n');

fprintf('Complete sensor samples = %d\n', ...
    size(Xvalid,1));


%% ============================================================
% 9. NORMALIZE INPUTS
% ============================================================

mu = mean(Xvalid,1);

sigma = std(Xvalid,0,1);

sigma(sigma == 0) = 1;

Xnorm = ...
    (Xvalid - mu) ./ sigma;


%% ============================================================
% 10. TRAIN RISK PERCENT MODEL
% ============================================================
%
% Multiple linear regression
% No toolbox required.
% ============================================================

A = [ones(size(Xnorm,1),1) Xnorm];

BetaRisk = A \ YPercent;

PredRiskPercent = A * BetaRisk;


%% ============================================================
% 11. TRAIN TTF MODEL
% ============================================================

BetaTTF = A \ YTTF;

PredTTF = A * BetaTTF;


%% ============================================================
% 12. TRAIN RISK LEVEL MODEL
% ============================================================
%
% Risk level is predicted from the continuous risk percentage.
%
% < 25       GREEN
% 25-50      YELLOW
% 50-75      ORANGE
% >=75       RED
%
% Project-defined classification boundaries.
% ============================================================

PredRiskLevel = zeros(size(PredRiskPercent));


for i = 1:length(PredRiskPercent)

    if PredRiskPercent(i) >= 75

        PredRiskLevel(i) = 4;

    elseif PredRiskPercent(i) >= 50

        PredRiskLevel(i) = 3;

    elseif PredRiskPercent(i) >= 25

        PredRiskLevel(i) = 2;

    else

        PredRiskLevel(i) = 1;

    end

end


%% ============================================================
% 13. RISK PERCENT PERFORMANCE
% ============================================================

RiskError = YPercent - PredRiskPercent;

RiskMAE = mean(abs(RiskError));

RiskRMSE = sqrt(mean(RiskError.^2));

RiskSSres = sum(RiskError.^2);

RiskSStot = sum((YPercent - ...
    mean(YPercent)).^2);

RiskR2 = 1 - RiskSSres/RiskSStot;


%% ============================================================
% 14. TTF PERFORMANCE
% ============================================================

TTFError = YTTF - PredTTF;

TTFMAE = mean(abs(TTFError));

TTFRMSE = sqrt(mean(TTFError.^2));

TTFSSres = sum(TTFError.^2);

TTFSStot = sum((YTTF - ...
    mean(YTTF)).^2);

TTFR2 = 1 - TTFSSres/TTFSStot;


%% ============================================================
% 15. RISK LEVEL ACCURACY
% ============================================================

Correct = PredRiskLevel == YRisk;

RiskAccuracy = ...
    sum(Correct) / length(YRisk) * 100;


%% ============================================================
% 16. DISPLAY AI PERFORMANCE
% ============================================================

fprintf('\n============================================\n');
fprintf('          AI MODEL PERFORMANCE\n');
fprintf('============================================\n');


fprintf('\nRISK LEVEL CLASSIFICATION\n');

fprintf('Accuracy = %.2f %%\n',RiskAccuracy);


fprintf('\nRISK PERCENTAGE REGRESSION\n');

fprintf('MAE  = %.4f %%\n',RiskMAE);

fprintf('RMSE = %.4f %%\n',RiskRMSE);

fprintf('R^2  = %.4f\n',RiskR2);


fprintf('\nTIME TO FAILURE REGRESSION\n');

fprintf('MAE  = %.4f hours\n',TTFMAE);

fprintf('RMSE = %.4f hours\n',TTFRMSE);

fprintf('R^2  = %.4f\n',TTFR2);


%% ============================================================
% 17. RESULTS TABLE
% ============================================================

Results = table( ...
    TimeValid, ...
    YRisk, ...
    PredRiskLevel, ...
    YPercent, ...
    PredRiskPercent, ...
    YTTF, ...
    PredTTF, ...
    'VariableNames', ...
    {'Time_hours', ...
     'Actual_Risk_Level', ...
     'Predicted_Risk_Level', ...
     'Actual_Risk_Percent', ...
     'Predicted_Risk_Percent', ...
     'Actual_TTF_hours', ...
     'Predicted_TTF_hours'});


disp(' ');

disp('============================================');

disp('AI PREDICTION RESULTS');

disp('============================================');

disp(Results);


%% ============================================================
% 18. ACTUAL VS PREDICTED RISK %
% ============================================================

figure;

plot(TimeValid,YPercent,'o-','LineWidth',2);

hold on;

plot(TimeValid,PredRiskPercent,'x--','LineWidth',2);

grid on;

xlabel('Elapsed Time (hours)');

ylabel('Risk (%)');

title('AI Risk Percentage - Actual vs Predicted');

legend('Actual Risk','AI Predicted Risk', ...
       'Location','best');


%% ============================================================
% 19. RISK PERCENTAGE TREND
% ============================================================

figure;

plot(Time,RiskPercent,'o-','LineWidth',2);

grid on;

xlabel('Elapsed Time (hours)');

ylabel('Risk (%)');

title('Munnar / Idukki Risk Percentage');


%% ============================================================
% 20. TTF ACTUAL VS PREDICTED
% ============================================================

figure;

plot(TimeValid,YTTF,'o-','LineWidth',2);

hold on;

plot(TimeValid,PredTTF,'x--','LineWidth',2);

grid on;

xlabel('Elapsed Time (hours)');

ylabel('TTF (hours)');

title('AI TTF - Actual vs Predicted');

legend('Actual TTF','AI Predicted TTF', ...
       'Location','best');


%% ============================================================
% 21. RISK LEVEL GRAPH
% ============================================================

figure;

stairs(Time,RiskLevel,'LineWidth',2);

grid on;

xlabel('Elapsed Time (hours)');

ylabel('Risk Level');

title('Landslide Risk Level');

yticks([1 2 3 4]);

yticklabels({'GREEN','YELLOW','ORANGE','RED'});


%% ============================================================
% 22. FACTOR OF SAFETY
% ============================================================

figure;

plot(Time,FS,'o-','LineWidth',2);

hold on;

yline(1.2,'--');

yline(1.0,'--');

grid on;

xlabel('Elapsed Time (hours)');

ylabel('Factor of Safety');

title('Factor of Safety');

legend('FS','Warning Level','Critical Level');


%% ============================================================
% 23. SENSOR CORRELATION
% ============================================================

CorrelationData = [ ...
    Rainfall(valid), ...
    SoilMoisture(valid), ...
    PorePressure(valid), ...
    FS(valid), ...
    Tilt(valid), ...
    Strain(valid), ...
    TTF(valid), ...
    RiskPercent(valid)];


CorrelationMatrix = corrcoef(CorrelationData);


disp(' ');

disp('============================================');

disp('CORRELATION MATRIX');

disp('============================================');

disp(CorrelationMatrix);


%% ============================================================
% 24. SAVE DATASET
% ============================================================

OutputTable = table( ...
    Time, ...
    TTF, ...
    Rainfall, ...
    SoilMoisture, ...
    PorePressure, ...
    FS, ...
    Tilt, ...
    Strain, ...
    RiskLevel, ...
    RiskPercent);


writetable( ...
    OutputTable, ...
    'Munnar_AI_Complete_Dataset.csv');


%% ============================================================
% 25. SAVE AI PARAMETERS
% ============================================================

save( ...
    'Munnar_AI_Complete_Model.mat', ...
    'BetaRisk', ...
    'BetaTTF', ...
    'mu', ...
    'sigma');


%% ============================================================
% 26. FINAL SUMMARY
% ============================================================

fprintf('\n============================================\n');

fprintf('             TRAINING COMPLETE\n');

fprintf('============================================\n');

fprintf('\nOutputs trained:\n');

fprintf('1. Risk Level\n');

fprintf('2. Risk Percentage\n');

fprintf('3. Time To Failure (TTF)\n');

fprintf('\nSaved files:\n');

fprintf('Munnar_AI_Complete_Dataset.csv\n');

fprintf('Munnar_AI_Complete_Model.mat\n');

fprintf('\n============================================\n');