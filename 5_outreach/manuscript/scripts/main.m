clear all; close all; clc

%% Init
folder.root = '/Users/ilja/Dropbox/12_work/mr_informationSamplingVisualManual/';
folder.data = strcat(folder.root, '2_data/');

nDecimals = 2;

%% Load data
data = load(strcat(folder.data, 'data_newPipeline.mat'));

% Bonus payout
bonusPayout.visual.single = ...
    getStats(data.data.performance.finalScores(:,1));
bonusPayout.visual.double = ...
    getStats(data.data.performance.finalScores(:,2));
bonusPayout.visual.both = ...
    getStats(sum(data.data.performance.finalScores(:,1:2), 2));

bonusPayout.manual.single = ...
    getStats(data.data.performance.finalScores(:,3));
bonusPayout.manual.double = ...
    getStats(data.data.performance.finalScores(:,4));
bonusPayout.manual.both = ...
    getStats(sum(data.data.performance.finalScores(:,3:4), 2));

% Completed trials
completedTrials.visual.single = getStats(data.data.log.nCompletedTrials(:,1));
completedTrials.visual.double = getStats(data.data.log.nCompletedTrials(:,2));
completedTrials.manual.single = getStats(data.data.log.nCompletedTrials(:,3));
completedTrials.manual.double = getStats(data.data.log.nCompletedTrials(:,4));

% Excluded trials
excludedTrials.visual.single = ...
    getStats(data.quality.proportionValidTrials(:,1) .* 100);
excludedTrials.visual.double = ...
    getStats(data.quality.proportionValidTrials(:,2) .* 100);
excludedTrials.manual.single = ...
    getStats(data.quality.proportionValidTrials(:,3) .* 100);
excludedTrials.manual.double = ...
    getStats(data.quality.proportionValidTrials(:,4) .* 100);

% Proportion trials with response time
time.responseTime.proportinTrialWith.visual.single = ...
    getStats(data.data.time.propTrialsWithResp(:,1) .* 100);
time.responseTime.proportinTrialWith.visual.double = ...
    getStats(data.data.time.propTrialsWithResp(:,2) .* 100);
time.responseTime.proportinTrialWith.manual.single = ...
    getStats(data.data.time.propTrialsWithResp(:,3) .* 100);
time.responseTime.proportinTrialWith.manual.double = ...
    getStats(data.data.time.propTrialsWithResp(:,4) .* 100);

% Discrimination performance
performance.discrimination.easy.visual.single = ...
    getStats(data.data.performance.proportionCorrect.easy(:,1));
performance.discrimination.easy.manual.single = ...
    getStats(data.data.performance.proportionCorrect.easy(:,3));

performance.discrimination.difficult.visual.single = ...
    getStats(data.data.performance.proportionCorrect.difficult(:,1));
performance.discrimination.difficult.manual.single = ...
    getStats(data.data.performance.proportionCorrect.difficult(:,3));

% Planning times
performance.search.planning.easy.visual.single = ...
    getStats(data.data.time.planning.mean.easy(:,1));
performance.search.planning.easy.manual.single = ...
    getStats(data.data.time.planning.mean.easy(:,3));

performance.search.planning.difficult.visual.single = ...
    getStats(data.data.time.planning.mean.difficult(:,1));
performance.search.planning.difficult.manual.single = ...
    getStats(data.data.time.planning.mean.difficult(:,3));

performance.search.planning.overall.visual.single = ...
    getStats(data.data.time.planning.mean.overall(:,1));
performance.search.planning.overall.manual.single = ...
    getStats(data.data.time.planning.mean.overall(:,3));

% Inspection times
performance.search.inspection.easy.visual.single = ...
    getStats(data.data.time.inspection.mean.easy(:,1));
performance.search.inspection.easy.manual.single = ...
    getStats(data.data.time.inspection.mean.easy(:,3));

performance.search.inspection.difficult.visual.single = ...
    getStats(data.data.time.inspection.mean.difficult(:,1));
performance.search.inspection.difficult.manual.single = ...
    getStats(data.data.time.inspection.mean.difficult(:,3));

performance.search.inspection.overall.visual.single = ...
    getStats(data.data.time.inspection.mean.overall(:,1));
performance.search.inspection.overall.manual.single = ...
    getStats(data.data.time.inspection.mean.overall(:,3));

% Response times
performance.search.response.easy.visual.single = ...
    getStats(data.data.time.response.mean.easy(:,1));
performance.search.response.easy.manual.single = ...
    getStats(data.data.time.response.mean.easy(:,3));

performance.search.response.difficult.visual.single = ...
    getStats(data.data.time.response.mean.difficult(:,1));
performance.search.response.difficult.manual.single = ...
    getStats(data.data.time.response.mean.difficult(:,3));

performance.search.response.overall.visual.single = ...
    getStats(data.data.time.response.mean.overall(:,1));
performance.search.response.overall.manual.single = ...
    getStats(data.data.time.response.mean.overall(:,3));

% Intercepts
performance.choice.intercept.visual.double = ...
    getStats(data.data.choice.regressionFit(:,1,2));
performance.choice.intercept.manual.double = ...
    getStats(data.data.choice.regressionFit(:,1,4));

% Slopes
performance.choice.slope.visual.double = ...
    getStats(data.data.choice.regressionFit(:,2,2));
performance.choice.slope.manual.double = ...
    getStats(data.data.choice.regressionFit(:,2,4));

% Means of sigmoid
performance.choice.mean.visual.double = ...
    getStats(data.data.choice.sigmoidFit(:,1,2));
performance.choice.mean.manual.double = ...
    getStats(data.data.choice.sigmoidFit(:,1,4));

% Standard deviations of sigmoids
performance.choice.std.visual.double = ...
    getStats(data.data.choice.sigmoidFit(:,2,2));
performance.choice.std.manual.double = ...
    getStats(data.data.choice.sigmoidFit(:,2,4));

% Proportion movements to chosen target
performance.choice.sampling.onChosen.first.visual.double = ...
    getStats(data.data.fixations.timecourse.onChosen(:,1,2));
performance.choice.sampling.onChosen.second.visual.double = ...
    getStats(data.data.fixations.timecourse.onChosen(:,2,2));

performance.choice.sampling.onChosen.first.manual.double = ...
    getStats(data.data.fixations.timecourse.onChosen(:,1,4));
performance.choice.sampling.onChosen.second.manual.double = ...
    getStats(data.data.fixations.timecourse.onChosen(:,2,4));

% Proportion movements on elements from the chosen set
% NOT SEPERATED BY SET SIZE
performance.choice.sampling.onChosen.allSets.visual.double = ...
    getStats(mean(data.data.fixations.propFixOnChosenModelEval(:,:,2), 2, "omitnan"));
performance.choice.sampling.onChosen.allSets.manual.double = ...
    getStats(mean(data.data.fixations.propFixOnChosenModelEval(:,:,4), 2, "omitnan"));

performance.choice.sampling.onChosen.allSets.visual.model = ...
    getStats(mean(data.probabilisticModel.pred.visual.propFixChosen, 2, "omitnan"));
performance.choice.sampling.onChosen.allSets.manual.model = ...
    getStats(mean(data.probabilisticModel.pred.manual.propFixChosen, 2, "omitnan"));

% Proportion movements to easy set
performance.choice.sampling.onEasy.first.visual.double = ...
    getStats(data.data.fixations.timecourse.onEasy(:,1,2));
performance.choice.sampling.onEasy.second.visual.double = ...
    getStats(data.data.fixations.timecourse.onEasy(:,2,2));

performance.choice.sampling.onEasy.first.manual.double = ...
    getStats(data.data.fixations.timecourse.onEasy(:,1,4));
performance.choice.sampling.onEasy.second.manual.double = ...
    getStats(data.data.fixations.timecourse.onEasy(:,2,4));

% Proportion movements to smaller set
performance.choice.sampling.onSmaller.first.visual.double = ...
    getStats(data.data.fixations.timecourse.onSmaller(:,1,2));
performance.choice.sampling.onSmaller.second.visual.double = ...
    getStats(data.data.fixations.timecourse.onSmaller(:,2,2));

performance.choice.sampling.onSmaller.first.manual.double = ...
    getStats(data.data.fixations.timecourse.onSmaller(:,1,4));
performance.choice.sampling.onSmaller.second.manual.double = ...
    getStats(data.data.fixations.timecourse.onSmaller(:,2,4));

% Proportion movements to closest element
performance.choice.sampling.onClosest.first.visual.double = ...
    getStats(data.data.fixations.timecourse.onClosest(:,1,2));
performance.choice.sampling.onClosest.second.visual.double = ...
    getStats(data.data.fixations.timecourse.onClosest(:,2,2));

performance.choice.sampling.onClosest.first.manual.double = ...
    getStats(data.data.fixations.timecourse.onClosest(:,1,4));
performance.choice.sampling.onClosest.second.manual.double = ...
    getStats(data.data.fixations.timecourse.onClosest(:,2,4));

% Latencies of gaze shifts
performance.choice.sampling.latencies.first.visual.double = ...
    getStats(data.data.fixations.latenciesFirstGazeShift(:,1,2));
performance.choice.sampling.latencies.second.visual.double = ...
    getStats(data.data.fixations.latenciesFirstGazeShift(:,2,2));

performance.choice.sampling.latencies.first.manual.double = ...
    getStats(data.data.fixations.latenciesFirstGazeShift(:,1,4));
performance.choice.sampling.latencies.second.manual.double = ...
    getStats(data.data.fixations.latenciesFirstGazeShift(:,2,4));

% Gain per time
performance.gainPerTime.visual.double = ...
    getStats(data.data.performance.gainPerTime(:,2));
performance.gainPerTime.manual.double = ...
    getStats(data.data.performance.gainPerTime(:,4));

performance.gainPerTime.visual.idealObserver = ...
    getStats(data.idealObserver.performance(:,2));
performance.gainPerTime.manual.idealObserver = ...
    getStats(data.idealObserver.performance(:,4));

performance.gainPerTime.visual.model = ...
    getStats(data.probabilisticModel.pred.visual.performance);
performance.gainPerTime.manual.model = ...
    getStats(data.probabilisticModel.pred.manual.performance);

% Fixation noise
proModel.noise.fixation.visual = ...
    getStats(data.probabilisticModel.pred.visual.freeParameter(:,1));
proModel.noise.fixation.manual = ...
    getStats(data.probabilisticModel.pred.manual.freeParameter(:,1));

% Decision noise
proModel.noise.decision.visual = ...
    getStats(data.probabilisticModel.pred.visual.freeParameter(:,2));
proModel.noise.decision.manual = ...
    getStats(data.probabilisticModel.pred.manual.freeParameter(:,2));

%% Proportion valid trials
showStats(excludedTrials.visual.single, ...
          'VALID TRIALS', ...
          'visual search', ...
          'single-target', ...
          nDecimals);
showStats(excludedTrials.visual.double, ...
          'VALID TRIALS', ...
          'visual search', ...
          'double-target', ...
          nDecimals);
showStats(excludedTrials.manual.single, ...
          'VALID TRIALS', ...
          'manual search', ...
          'single-target', ...
          nDecimals);
showStats(excludedTrials.manual.double, ...
          'VALID TRIALS', ...
          'manual search', ...
          'double-target', ...
          nDecimals);

%% Proportion trials where response times could be calculated
% showStats(time.responseTime.proportinTrialWith.visual.single, ...
%           'PROPORTION TRIALS WITH RESPONSE TIMES', ...
%           'visual search', ...
%           'single-target', ...
%           nDecimals);
% showStats(time.responseTime.proportinTrialWith.visual.double, ...
%           'PROPORTION TRIALS WITH RESPONSE TIMES', ...
%           'visual search', ...
%           'double-target', ...
%           nDecimals);
% showStats(time.responseTime.proportinTrialWith.manual.single, ...
%           'PROPORTION TRIALS WITH RESPONSE TIMES', ...
%           'manual search', ...
%           'single-target', ...
%           nDecimals);
% showStats(time.responseTime.proportinTrialWith.manual.double, ...
%           'PROPORTION TRIALS WITH RESPONSE TIMES', ...
%           'manual search', ...
%           'double-target', ...
%           nDecimals);

%% Completed trials
showStats(completedTrials.visual.single, ...
          'COMPLETED TRIALS', ...
          'visual search', ...
          'single-target', ...
          nDecimals)
showStats(completedTrials.manual.single, ...
          'COMPLETED TRIALS', ...
          'manual search', ...
          'single-target', ...
          nDecimals)

showStats(completedTrials.visual.double, ...
          'COMPLETED TRIALS', ...
          'visual search', ...
          'double-target', ...
          nDecimals)
showStats(completedTrials.manual.double, ...
          'COMPLETED TRIALS', ...
          'manual search', ...
          'double-target', ...
          nDecimals)

%% Bonus payout
showStats(bonusPayout.visual.single, ...
          'BONUS PAYOUT', ...
          'visual search', ...
          'single-target', ...
          nDecimals);
showStats(bonusPayout.visual.double, ...
          'BONUS PAYOUT', ...
          'visual search', ...
          'double-target', ...
          nDecimals);

showStats(bonusPayout.manual.single, ...
          'BONUS PAYOUT', ...
          'manual search', ...
          'single-target', ...
          nDecimals);
showStats(bonusPayout.manual.double, ...
          'BONUS PAYOUT', ...
          'manual search', ...
          'double-target', ...
          nDecimals);

showStats(bonusPayout.visual.both, ...
          'BONUS PAYOUT', ...
          'visual search', ...
          'single- and double-target', ...
          nDecimals);
showStats(bonusPayout.manual.both, ...
          'BONUS PAYOUT', ...
          'manual search', ...
          'single- and double-target', ...
          nDecimals);

%% Discrimination performance
% Easy target
showStats(performance.discrimination.easy.visual.single, ...
          'PERCEPTUAL PERFORMANCE', ...
          'visual search', ...
          'single-target, easy target', ...
          nDecimals);
showStats(performance.discrimination.easy.manual.single, ...
          'PERCEPTUAL PERFORMANCE', ...
          'manual search', ...
          'single-target, easy target', ...
          nDecimals);

% Difficult target
showStats(performance.discrimination.difficult.visual.single, ...
          'PERCEPTUAL PERFORMANCE', ...
          'visual search', ...
          'single-target, difficult target', ...
          nDecimals);
showStats(performance.discrimination.difficult.manual.single, ...
          'PERCEPTUAL PERFORMANCE', ...
          'manual search', ...
          'single-target, difficult target', ...
          nDecimals);

%% Planning times
% Easy target
showStats(performance.search.planning.easy.visual.single, ...
          'PLANNING TIMES', ...
          'visual search', ...
          'single-target', ...
          0);
showStats(performance.search.planning.easy.manual.single, ...
          'PLANNING TIME', ...
          'manual search', ...
          'single-target', ...
          0);

% Difficult target
showStats(performance.search.planning.difficult.visual.single, ...
          'PLANNING TIME', ...
          'visual search', ...
          'single-target', ...
          0);
showStats(performance.search.planning.difficult.manual.single, ...
          'PLANNING TIME', ...
          'manual search', ...
          'single-target', ...
          0);

% Overall
% showStats(performance.search.planning.overall.visual.single, ...
%           'PLANNING TIME', ...
%           'visual search', ...
%           'single-target', ...
%           0);
% showStats(performance.search.planning.overall.manual.single, ...
%           'PLANNING TIME', ...
%           'manual search', ...
%           'single-target', ...
%           0);

%% Inspection times
% Easy target
showStats(performance.search.inspection.easy.visual.single, ...
          'INSPECTION TIME', ...
          'visual search', ...
          'single-target', ...
          0);
showStats(performance.search.inspection.easy.manual.single, ...
          'INSPECTION TIME', ...
          'manual search', ...
          'single-target', ...
          0);

% Difficult target
showStats(performance.search.inspection.difficult.visual.single, ...
          'INSPECTION TIME', ...
          'visual search', ...
          'single-target', ...
          0);
showStats(performance.search.inspection.difficult.manual.single, ...
          'INSPECTION TIME', ...
          'manual search', ...
          'single-target', ...
          0);

% Overall
% showStats(performance.search.inspection.overall.visual.single, ...
%           'INSPECTION TIME', ...
%           'visual search', ...
%           'single-target', ...
%           0);
% showStats(performance.search.inspection.overall.manual.single, ...
%           'INSPECTION TIME', ...
%           'manual search', ...
%           'single-target', ...
%           0);

%% Response times
% Easy target
showStats(performance.search.response.easy.visual.single, ...
          'RESPONSE TIME', ...
          'visual search', ...
          'single-target', ...
          0);
showStats(performance.search.response.easy.manual.single, ...
          'RESPONSE TIME', ...
          'manual search', ...
          'single-target', ...
          0);

% Difficult target
showStats(performance.search.response.difficult.visual.single, ...
          'RESPONSE TIME', ...
          'visual search', ...
          'single-target', ...
          0);
showStats(performance.search.response.difficult.manual.single, ...
          'RESPONSE TIME', ...
          'manual search', ...
          'single-target', ...
          0);

% Overall
% showStats(performance.search.response.overall.visual.single, ...
%           'RESPONSE TIME', ...
%           'visual search', ...
%           'single-target', ...
%           0);
% showStats(performance.search.response.overall.manual.single, ...
%           'RESPONSE TIME', ...
%           'manual search', ...
%           'single-target', ...
%           0);

%% Intercepts
showStats(performance.choice.intercept.visual.double, ...
          'INTERCEPTS', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.intercept.manual.double, ...
          'INTERCEPTS', ...
          'manual search', ...
          'double-target', ...
          2);

%% Slopes
showStats(performance.choice.slope.visual.double, ...
          'SLOPES', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.slope.manual.double, ...
          'SLOPES', ...
          'manual search', ...
          'double-target', ...
          2);

%% Means of sigmoids
showStats(performance.choice.mean.visual.double, ...
          'MEANS', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.mean.manual.double, ...
          'MEANS', ...
          'manual search', ...
          'double-target', ...
          2);

%% Standard deviations of sigmoids
showStats(performance.choice.std.visual.double, ...
          'STD', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.std.manual.double, ...
          'STD', ...
          'manual search', ...
          'double-target', ...
          2);

%% Proportion movements 
% To chosen target
showStats(performance.choice.sampling.onChosen.first.visual.double, ...
          'PROPORTION FIRST MOVEMENTS TO CHOSEN TARGET', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onChosen.second.visual.double, ...
          'PROPORTION SECOND MOVEMENTS TO CHOSEN TARGET', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onChosen.first.manual.double, ...
          'PROPORTION FIRST MOVEMENTS TO CHOSEN TARGET', ...
          'manual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onChosen.second.manual.double, ...
          'PROPORTION SECOND MOVEMENTS TO CHOSEN TARGET', ...
          'manual search', ...
          'double-target', ...
          2);

% To easy set
showStats(performance.choice.sampling.onEasy.first.visual.double, ...
          'PROPORTION FIRST MOVEMENTS TO EASY SET', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onEasy.second.visual.double, ...
          'PROPORTION SECOND MOVEMENTS TO EASY SET', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onEasy.first.manual.double, ...
          'PROPORTION FIRST MOVEMENTS TO EASY SET', ...
          'manual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onEasy.second.manual.double, ...
          'PROPORTION SECOND MOVEMENTS TO EASY SET', ...
          'manual search', ...
          'double-target', ...
          2);

% To smaller set
showStats(performance.choice.sampling.onSmaller.first.visual.double, ...
          'PROPORTION FIRST MOVEMENTS TO SMALLER SET', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onSmaller.second.visual.double, ...
          'PROPORTION SECOND MOVEMENTS TO SMALLER SET', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onSmaller.first.manual.double, ...
          'PROPORTION FIRST MOVEMENTS TO SMALLER SET', ...
          'manual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onSmaller.second.manual.double, ...
          'PROPORTION SECOND MOVEMENTS TO SMALLER SET', ...
          'manual search', ...
          'double-target', ...
          2);

% To closest stimulus
showStats(performance.choice.sampling.onClosest.first.visual.double, ...
          'PROPORTION FIRST MOVEMENTS TO CLOSEST STIMULUS', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onClosest.second.visual.double, ...
          'PROPORTION SECOND MOVEMENTS TO CLOSEST STIMULUS', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onClosest.first.manual.double, ...
          'PROPORTION FIRST MOVEMENTS TO CLOSEST STIMULUS', ...
          'manual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onClosest.second.manual.double, ...
          'PROPORTION SECOND MOVEMENTS TO CLOSEST STIMULUS', ...
          'manual search', ...
          'double-target', ...
          2);

% Mean proportion movements on chosen set
% Visual search
showStats(performance.choice.sampling.onChosen.allSets.visual.double, ...
          'PROPORTION OVERALL MOVEMENTS TO CHOSEN SET', ...
          'visual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onChosen.allSets.visual.model, ...
          'PROPORTION OVERALL MOVEMENTS TO CHOSEN SET', ...
          'visual search', ...
          'double-target', ...
          2);

[r, p, rl, ru] = ...
    corrcoef(mean(data.data.fixations.propFixOnChosenModelEval(:,:,2), 2, 'omitnan'), ...
             mean(data.probabilisticModel.pred.visual.propFixChosen, 2, 'omitnan'), ...
             "Rows", "Complete");
disp(strcat("r = ", num2str(round(r(1,2), nDecimals))));
disp(strcat("CI95%_lower = ", num2str(round(rl(1,2), nDecimals))));
disp(strcat("CI95%_upper = ", num2str(round(ru(1,2), nDecimals))));
disp(strcat("p = ", num2str(round(p(1,2), 3))));

% Manual search
showStats(performance.choice.sampling.onChosen.allSets.manual.double, ...
          'PROPORTION OVERALL MOVEMENTS TO CHOSEN SET', ...
          'manual search', ...
          'double-target', ...
          2);
showStats(performance.choice.sampling.onChosen.allSets.manual.model, ...
          'PROPORTION OVERALL MOVEMENTS TO CHOSEN SET', ...
          'manual search', ...
          'double-target', ...
          2);

[r, p, rl, ru] = ...
    corrcoef(mean(data.data.fixations.propFixOnChosenModelEval(:,:,4), 2, 'omitnan'), ...
             mean(data.probabilisticModel.pred.manual.propFixChosen, 2, 'omitnan'), ...
             "Rows", "Complete");
disp(strcat("r = ", num2str(round(r(1,2), nDecimals))));
disp(strcat("CI95%_lower = ", num2str(round(rl(1,2), nDecimals))));
disp(strcat("CI95%_upper = ", num2str(round(ru(1,2), nDecimals))));
disp(strcat("p = ", num2str(round(p(1,2), 3))));

%% Latencies of gaze shifts
showStats(performance.choice.sampling.latencies.first.visual.double, ...
          'LATENCIES FIRST MOVEMENTS', ...
          'visual search', ...
          'double-target', ...
          0);
showStats(performance.choice.sampling.latencies.second.visual.double, ...
          'LATENCIES SECOND MOVEMENTS', ...
          'visual search', ...
          'double-target', ...
          0);
showStats(performance.choice.sampling.latencies.first.manual.double, ...
          'LATENCIES FIRST MOVEMENTS', ...
          'manual search', ...
          'double-target', ...
          0);
showStats(performance.choice.sampling.latencies.second.manual.double, ...
          'LATENCIES SECOND MOVEMENTS', ...
          'manual search', ...
          'double-target', ...
          0);

%% Gain per time
showStats(performance.gainPerTime.visual.double, ...
          'GAIN PER TME', ...
          'visual search', ...
          'double-target', ...
          nDecimals);
showStats(performance.gainPerTime.manual.double, ...
          'GAIN PER TME', ...
          'manual search', ...
          'double-target', ...
          nDecimals);

showStats(performance.gainPerTime.visual.idealObserver, ...
          'GAIN PER TME', ...
          'visual search', ...
          'double-target', ...
          nDecimals);
showStats(performance.gainPerTime.manual.idealObserver, ...
          'GAIN PER TME', ...
          'manual search', ...
          'double-target', ...
          nDecimals);

showStats(performance.gainPerTime.visual.model, ...
          'GAIN PER TME', ...
          'visual search', ...
          'double-target', ...
          nDecimals);
showStats(performance.gainPerTime.manual.model, ...
          'GAIN PER TME', ...
          'manual search', ...
          'double-target', ...
          nDecimals);

% Correlation: model gain vs. empirical gain
% Visual search
[r, p, rl, ru] = corrcoef(data.probabilisticModel.pred.visual.performance, ...
                          data.data.performance.gainPerTime(:,2), ...
                          'Rows', 'Complete');
disp(strcat("r = ", num2str(round(r(1,2), nDecimals))));
disp(strcat("CI95%_lower = ", num2str(round(rl(1,2), nDecimals))));
disp(strcat("CI95%_upper = ", num2str(round(ru(1,2), nDecimals))));
disp(strcat("p = ", num2str(round(p(1,2), 3))));

% Manual search
[r, p, rl, ru] = corrcoef(data.probabilisticModel.pred.manual.performance, ...
                          data.data.performance.gainPerTime(:,4), ...
                          'Rows', 'Complete');
disp(strcat("r = ", num2str(round(r(1,2), nDecimals))));
disp(strcat("CI95%_lower = ", num2str(round(rl(1,2), nDecimals))));
disp(strcat("CI95%_upper = ", num2str(round(ru(1,2), nDecimals))));
disp(strcat("p = ", num2str(round(p(1,2), 3))));

%% Decision noise
showStats(proModel.noise.decision.visual, ...
          'DECISION NOISE', ...
          'visual search', ...
          'double-target', ...
          nDecimals);

showStats(proModel.noise.decision.manual, ...
          'DECISION NOISE', ...
          'manual search', ...
          'double-target', ...
          nDecimals);

%% Fixation noise
showStats(proModel.noise.fixation.visual, ...
          'FIXATION NOISE', ...
          'visual search', ...
          'double-target', ...
          nDecimals);

showStats(proModel.noise.fixation.manual, ...
          'FIXATION NOISE', ...
          'manual search', ...
          'double-target', ...
          nDecimals);