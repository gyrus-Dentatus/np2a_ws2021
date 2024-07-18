close all; clear all; clc;

%% Load settings
settings_exper;
settings_figure;
settings_analysis;
settings_screen;
settings_log;

addpath(exper.path.ANALYSIS);
addpath(strcat(exper.path.ANALYSIS, "model"));
cd(exper.path.ROOT);

%% Extract data from files
data.log = getLogFiles(exper, anal, logCol);
data.gaze = getDatFiles(exper, screen, anal, data.log.nCompletedTrials);
data.badTrials = ...
    getBadTrials(exper, data.log.nCompletedTrials, exper.path.DATA);

%% Asses data quality
quality.excludedTrials = ...
    getExcludeTrials(exper, ...
                     anal, ...
                     data.log.error.fixation.online, ...
                     data.gaze.error.fixation.offline, ... 
                     data.gaze.error.dataLoss, ...
                     data.gaze.error.eventMissing, ...
                     data.badTrials);
[quality.proportionValidTrials, quality.nValidTrials] = ...
    getProportionValidTrials(exper, anal, data.log.nCompletedTrials, ...
                             quality.excludedTrials);

%% Drop excluded trials from variables
% Log files contain all trials, and thus, do not yet account for excluded
% trials. This step is not necessary for everything but the stuff from log
% files, because functions are designed to skip over excluded trials
data.log.hitOrMiss = ...
    dropTrials(exper, anal, data.log.hitOrMiss, quality.excludedTrials);
data.log.nDistractors.easy.trialwise = ...
    dropTrials(exper, anal, data.log.nDistractors.easy.trialwise, quality.excludedTrials);
data.log.nDistractors.difficult.trialwise = ...
    dropTrials(exper, anal, data.log.nDistractors.difficult.trialwise, quality.excludedTrials);

%% Get screen coordinates of stimuli
data.stimulusCoordinates = getStimCoord(exper, anal, logCol, data.log.files);

%% Get gaze shifts
data.gaze.gazeShifts = ...
    getGazeShifts(exper, anal, data.gaze, data.log.nCompletedTrials, ...
                  quality.excludedTrials);

% Map trialwise variables to detected gaze shifts
data.log.nDistractors.easy.gazeShiftWise = ...
    trialwise2gazeShiftWise(exper, anal, ...
                            data.log.nCompletedTrials, ...
                            data.gaze.gazeShifts.trialMap, ...
                            data.log.nDistractors.easy.trialwise);
data.log.nDistractors.difficult.gazeShiftWise = ...
    trialwise2gazeShiftWise(exper, anal, ...
                            data.log.nCompletedTrials, ...
                            data.gaze.gazeShifts.trialMap, ...
                            data.log.nDistractors.difficult.trialwise);

%% Get fixated areas of interest
data.fixations = ...
    getFixatedAois(exper, screen, anal, data.gaze, ...
                   data.stimulusCoordinates, ...
                   data.log.nCompletedTrials, ...
                   quality.excludedTrials, ...
                   fig.toggle.debug.SHOW_FIXATIONS);
data.fixations.propTrialOneAoiFix = ...
    getProportions(exper, anal, data.fixations.atLeastOneFixatedAoi, ....
                   quality.nValidTrials, []);

%% Analyse choice behavior
% Get chosen target
data.choice = getChoices(exper, anal, logCol, data.log, data.gaze, ...
                         data.fixations, quality.excludedTrials);
[~, data.choice.target.proportionEasy] = ...
    getAvg(exper, anal, data.choice.target.easy, ...
           data.choice.target.id, ...
           [], ...
           data.log.nDistractors.easy.trialwise, [], 'mean', 'mean');

% Test influence of difficult and set size on choices
% Do this by fitting a linear regression, and inspecting slope (set size)
% and intercepts (difficult)
data.choice.regressionFit = ...
    fitRegression(exper, anal, data.choice.target.proportionEasy, ...
                  data.log.nDistractors.easy.trialwise);

%% Analyse fixated AOIs over the course of a trial
% Timelock (valid) fixations to trial start
data.fixations.timelock = ...
    timelockGazeShifts(exper, anal, data.log.nCompletedTrials, ...
                       quality.excludedTrials, ...
                       data.gaze.gazeShifts.trialMap, ...
                       data.fixations.fixatedAois.groupIds, ...
                       data.fixations.subset);

% Check if specific areas of interest where fixated
data.fixations.wentToChosen = ...
    onChosenSet(anal, exper, ...
                data.log.nCompletedTrials, ...
                data.gaze.gazeShifts.trialMap, ...
                quality.excludedTrials, ...
                data.fixations.fixatedAois.groupIds, ...
                data.choice.target.id);
data.fixations.wentToSmallerSet = ...
    onSmallerSet(anal, exper, ...
                 data.log.nCompletedTrials, ...
                 data.gaze.gazeShifts.trialMap, ...
                 quality.excludedTrials, ...
                 data.fixations.fixatedAois.groupIds, ...
                 data.log.nDistractors.easy.trialwise, ...
                 data.log.nDistractors.difficult.trialwise);
data.fixations.wentToClosestStimulus = ...
    onClosestStimulus(anal, exper, ...
                      data.log.nCompletedTrials, ...
                      data.gaze.gazeShifts.trialMap, ...
                      quality.excludedTrials, ...
                      data.fixations.fixatedAois.uniqueIds, ...
                      data.stimulusCoordinates, ...
                      data.gaze.gazeShifts.onsets);

% Get proportion gaze shifts on AOIs at different points in a trial
data.fixations.timecourse.onChosen = ...
    getFixationTimeCourse(exper, ...                                
                          anal, ...
                          data.fixations.timelock, ...
                          1:2, ...
                          data.fixations.wentToChosen, ...
                          data.log.nDistractors.easy.gazeShiftWise, ...
                          false);
data.fixations.timecourse.onSmaller = ...
    getFixationTimeCourse(exper, ...                                
                          anal, ...
                          data.fixations.timelock, ...
                          1:2, ...
                          data.fixations.wentToSmallerSet, ...
                          data.log.nDistractors.easy.gazeShiftWise, ...
                          true);
data.fixations.timecourse.onClosest = ...
    getFixationTimeCourse(exper, ...                                
                          anal, ...
                          data.fixations.timelock, ...
                          1:2, ...
                          data.fixations.wentToClosestStimulus, ...
                          data.log.nDistractors.easy.gazeShiftWise, ...
                          false);

% Get average proportion fixations to elements from the chosen set
% This variable is calculated based on a specific subset of fixations (see
% doc), and only used for model evaluation (i.e., used to calculate RSS)
data.fixations.subsetModelEvaluation = ...
    selectFixationSubsetForModelEval(anal, exper, ...
                                     data.log.nCompletedTrials, ...
                                     data.gaze.gazeShifts.trialMap, ...
                                     quality.excludedTrials, ...
                                     data.fixations.fixatedAois.uniqueIds, ...
                                     data.fixations.subset);
[~, data.fixations.propFixOnChosenModelEval] = ...
    getAvg(exper, anal, ...
           data.fixations.wentToChosen, ...
           data.choice.target.id, ...
           [], ...
           data.log.nDistractors.easy.gazeShiftWise, ...
           data.fixations.subsetModelEvaluation, 'mean', 'mean');

% Get timecourse of movement latencies
data.fixations.latenciesFirstGazeShift = ...
    getLatenciesTimeCourse(exper, ...                                
                           anal, ...
                           data.fixations.timelock, ...
                           1, ...
                           data.gaze.gazeShifts.latency, ...
                           data.log.nDistractors.easy.gazeShiftWise, ...
                           data.log.nDistractors.difficult.gazeShiftWise, ...
                           "median", ...
                           "median");

%% Get time-related variables
data.time = getTimes(exper, anal, data.log.nCompletedTrials, ...
                     data.gaze, ...
                     data.fixations, ...
                     quality.excludedTrials, ...
                     true);

% Planning time
data.time.planning.mean.easy = ...
    getAvg(exper, anal, data.time.planning.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.EASY, ...
           data.log.nDistractors.easy.trialwise, [], 'median', 'median');
data.time.planning.mean.difficult = ...
    getAvg(exper, anal, data.time.planning.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.DIFFICULT, ...
           data.log.nDistractors.difficult.trialwise, [], 'median', 'median');
data.time.planning.mean.overall = ...
    getAvg(exper, anal, data.time.planning.trialwise, ...
           data.choice.target.id, ...
           [], ...
           data.log.nDistractors.easy.trialwise, [], 'median', 'median');

% Inspection time
data.time.inspection.mean.easy = ...
    getAvg(exper, anal, data.time.inspection.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.EASY, ...
           data.log.nDistractors.easy.trialwise, [], 'median', 'median');
data.time.inspection.mean.difficult = ...
    getAvg(exper, anal, data.time.inspection.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.DIFFICULT, ...
           data.log.nDistractors.difficult.trialwise, [], 'median', 'median');
data.time.inspection.mean.overall = ...
    getAvg(exper, anal, data.time.inspection.trialwise, ...
           data.choice.target.id, ...
           [], ...
           data.log.nDistractors.difficult.trialwise, [], 'median', 'median');

% Response time
data.time.response.mean.easy = ...
    getAvg(exper, anal, data.time.response.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.EASY, ...
           data.log.nDistractors.easy.trialwise, [], 'median', 'median');
data.time.response.mean.difficult = ...
    getAvg(exper, anal, data.time.response.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.DIFFICULT, ...
           data.log.nDistractors.difficult.trialwise, [], 'median', 'median');
data.time.response.mean.overall = ...
    getAvg(exper, anal, data.time.response.trialwise, ...
           data.choice.target.id, ...
           [], ...
           data.log.nDistractors.difficult.trialwise, [], 'median', 'median');

% Non-search time
data.time.nonSearch.mean.easy = ...
    getAvg(exper, anal, data.time.nonSearch.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.EASY, ...
           data.log.nDistractors.easy.trialwise, [], 'median', 'median');
data.time.nonSearch.mean.difficult = ...
    getAvg(exper, anal, data.time.nonSearch.trialwise, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.DIFFICULT, ...
           data.log.nDistractors.difficult.trialwise, [], 'median', 'median');

% Trial durations
data.time.trialDurations = ...
    getTrialDurations(exper, anal, data.log.nCompletedTrials, data.gaze);

% Time lost due to exclusion of trials
% Calculate time lost due to excluded trials and store # excluded trials
data.time.lostTime = ...
    getLostTime(exper, anal, quality.excludedTrials, data.time.trialDurations);

%% Get performance measures
% Target discrimination performance
data.performance.proportionCorrect.easy = ...
    getAvg(exper, anal, ...
           data.log.hitOrMiss, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.EASY, ...
           data.log.nDistractors.easy.trialwise, [], 'mean', 'mean');
data.performance.proportionCorrect.difficult = ...
    getAvg(exper, anal, ...
           data.log.hitOrMiss, ...
           data.choice.target.id, ...
           exper.stimulus.id.target.DIFFICULT, ...
           data.log.nDistractors.difficult.trialwise, [], 'mean', 'mean');

% Final score at the end of conditions
data.performance.finalScores = getFinalScore(exper, anal, data.log.scores);
data.performance.gainPerTime = ...
    getEmpiricalGainPerTime(exper, anal, data.time.lostTime, ...
                            data.performance.finalScores, ...
                            quality.excludedTrials);

%% Get ideal observer predictions
idealObserver.opt = ...
    initIdealObserverModel(data.performance.proportionCorrect, ...
                           data.time.inspection.mean, ...
                           data.time.nonSearch.mean);
[idealObserver.gain.abs, idealObserver.gain.relative, ...
 idealObserver.proChoices.easy, idealObserver.performance] = ...
    getIdealObserverPredictions(exper, idealObserver.opt);

%% Fit generative probabilistic model
probabilisticModel = initProbabilisticModel(exper);

% Visual search
[probabilisticModel.pred.visual.propChoicesEasy, ...
 probabilisticModel.pred.visual.propFixChosen, ...
 probabilisticModel.pred.visual.nFix, ...
 probabilisticModel.pred.visual.freeParameter] = ...
    fitProbabilisticModel(exper, ...
                          anal, ...
                          data.choice.target.proportionEasy(:,:,2), ...
                          data.fixations.propFixOnChosenModelEval(:,:,2), ...
                          idealObserver.gain.relative(:,:,1), ...
                          probabilisticModel);
probabilisticModel.pred.visual.performance = ...
    getProbabilisticGain(exper, ...
                         idealObserver.opt.payoff, ...
                         [idealObserver.opt.input.accuracy.easy(:,1), ...
                          idealObserver.opt.input.accuracy.difficult(:,1)], ....
                         [idealObserver.opt.input.inspectionTime.easy(:,1), ...
                          idealObserver.opt.input.inspectionTime.difficult(:,1)], ....
                         [idealObserver.opt.input.nonSearchTime.easy(:,1), ...
                          idealObserver.opt.input.nonSearchTime.difficult(:,1)], ...
                         probabilisticModel.pred.visual.propChoicesEasy, ...
                         probabilisticModel.pred.visual.nFix, ...
                         probabilisticModel.CORRECT_TARGET_FIX);

% Manual search
[probabilisticModel.pred.manual.propChoicesEasy, ...
 probabilisticModel.pred.manual.propFixChosen, ...
 probabilisticModel.pred.manual.nFix, ...
 probabilisticModel.pred.manual.freeParameter] = ...
    fitProbabilisticModel(exper, ...
                          anal, ...
                          data.choice.target.proportionEasy(:,:,4), ...
                          data.fixations.propFixOnChosenModelEval(:,:,4), ...
                          idealObserver.gain.relative(:,:,3), ...
                          probabilisticModel);
probabilisticModel.pred.manual.performance = ...
    getProbabilisticGain(exper, ...
                         idealObserver.opt.payoff, ...
                         [idealObserver.opt.input.accuracy.easy(:,3), ...
                          idealObserver.opt.input.accuracy.difficult(:,3)], ....
                         [idealObserver.opt.input.inspectionTime.easy(:,3), ...
                          idealObserver.opt.input.inspectionTime.difficult(:,3)], ....
                         [idealObserver.opt.input.nonSearchTime.easy(:,3), ...
                          idealObserver.opt.input.nonSearchTime.difficult(:,3)], ...
                         probabilisticModel.pred.manual.propChoicesEasy, ...
                         probabilisticModel.pred.manual.nFix, ...
                         probabilisticModel.CORRECT_TARGET_FIX);

%% Export data for stats
% Completed trials
exportShort(data.log.nCompletedTrials, ...
            ["single_visual", "double_visual", ...
             "single_manual",  "double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/completedTrials_short.csv"));

% Bonus payout
exportShort(data.performance.finalScores, ...
            ["single_visual", "double_visual", ...
             "single_manual",  "double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/bonusPayout_short.csv"));

% Regression parameter
exportShort([data.choice.regressionFit(:,:,2), ...
             data.choice.regressionFit(:,:,4)], ...
            ["intercepts_visual", "slopes_visual", ...
             "intercepts_manual",  "slopes_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/regressionPar_short.csv"));

% Gain per time
exportShort([data.performance.gainPerTime, ...
             idealObserver.performance], ...
            ["emp_single_visual", "emp_double_visual", ...
             "emp_single_manual", "emp_double_manual", ...
             "idealObs_single_visual", "idealObs_double_visual", ...
             "idealObs_single_manual", "idealObs_double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/gainPerTime_short.csv"));

% Perceptual performance
exportShort([data.performance.proportionCorrect.easy(:,[1,3]), ...
             data.performance.proportionCorrect.difficult(:,[1,3]), ...
             transformDv(exper, anal, data.performance.proportionCorrect.easy(:,[1,3]), "arcsin"), ...
             transformDv(exper, anal, data.performance.proportionCorrect.difficult(:,[1,3]), "arcsin")], ...
            ["easy_single_visual", "easy_single_manual", ...
             "difficult_single_visual",  "difficult_single_manual",  ...
             "trans_easy_single_visual", "trans_easy_single_manual", ...
             "trans_difficult_single_visual", "trans_difficult_single_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/perceptualPerformance_short.csv"));
exportLong(exper, ...
           ["SubNo", "Exp", "Targ", "Dv"], ...
           strcat(exper.path.ANALYSIS, "statistics/perceptualPerformance_long.csv"), ...
           [data.performance.proportionCorrect.easy(:,1), ...
            data.performance.proportionCorrect.difficult(:,1), ...
            data.performance.proportionCorrect.easy(:,3), ...
            data.performance.proportionCorrect.difficult(:,3)], ...
           [1; 1; 2; 2], ...
           [1; 2; 1; 2]);

% Planning time
exportShort([data.time.planning.mean.easy(:,[1,3]), ...
             data.time.planning.mean.difficult(:,[1,3])], ...
            ["easy_single_visual", "easy_single_manual", ...
             "difficult_single_visual",  "difficult_single_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/planningTime_short.csv"));
exportLong(exper, ...
           ["SubNo", "Exp", "Targ", "Dv"], ...
           strcat(exper.path.ANALYSIS, "statistics/planningTime_long.csv"), ...
           [data.time.planning.mean.easy(:,1), ...
            data.time.planning.mean.difficult(:,1), ...
            data.time.planning.mean.easy(:,3), ...
            data.time.planning.mean.difficult(:,3)], ...
           [1; 1; 2; 2], ...
           [1; 2; 1; 2]);

% Inspection time
exportShort([data.time.inspection.mean.easy(:,[1,3]), ...
             data.time.inspection.mean.difficult(:,[1,3])], ...
            ["easy_single_visual", "easy_single_manual", ...
             "difficult_single_visual",  "difficult_single_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/inspectionTime_short.csv"));
exportLong(exper, ...
           ["SubNo", "Exp", "Targ", "Dv"], ...
           strcat(exper.path.ANALYSIS, "statistics/inspectionTime_long.csv"), ...
           [data.time.inspection.mean.easy(:,1), ...
            data.time.inspection.mean.difficult(:,1), ...
            data.time.inspection.mean.easy(:,3), ...
            data.time.inspection.mean.difficult(:,3)], ...
           [1; 1; 2; 2], ...
           [1; 2; 1; 2]);

% Response time
exportShort([data.time.response.mean.easy(:,[1,3]), ...
             data.time.response.mean.difficult(:,[1,3])], ...
            ["easy_single_visual", "easy_single_manual", ...
             "difficult_single_visual",  "difficult_single_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/responseTime_short.csv"));
exportLong(exper, ...
           ["SubNo", "Exp", "Targ", "Dv"], ...
           strcat(exper.path.ANALYSIS, "statistics/responseTime_long.csv"), ...
           [data.time.response.mean.easy(:,1), ...
            data.time.response.mean.difficult(:,1), ...
            data.time.response.mean.easy(:,3), ...
            data.time.response.mean.difficult(:,3)], ...
           [1; 1; 2; 2], ...
           [1; 2; 1; 2]);

% Proportion movements on chosen
exportShort([data.fixations.timecourse.onChosen(:,:,2), ...
             data.fixations.timecourse.onChosen(:,:,4), ...
             transformDv(exper, anal, data.fixations.timecourse.onChosen(:,:,2), "arcsin"), ...
             transformDv(exper, anal, data.fixations.timecourse.onChosen(:,:,4), "arcsin")], ...
            ["first_double_visual", "second_double_visual", ...
             "first_double_manual",  "second_double_manual", ...
             "trans_first_double_visual", "trans_second_double_visual", ...
             "trans_first_double_manual", "trans_second_double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/propOnChosen_short.csv"));
exportLong(exper, ...
           ["SubNo", "Exp", "Targ", "Dv"], ...
           strcat(exper.path.ANALYSIS, "statistics/propOnChosen_long.csv"), ...
           [data.fixations.timecourse.onChosen(:,:,2), ...
            data.fixations.timecourse.onChosen(:,:,4)], ...
           [1; 1; 2; 2], ...
           [1; 2; 1; 2]);

% Proportion movements on smaller
exportShort([data.fixations.timecourse.onSmaller(:,:,2), ...
             data.fixations.timecourse.onSmaller(:,:,4), ...
             transformDv(exper, anal, data.fixations.timecourse.onSmaller(:,:,2), "arcsin"), ...
             transformDv(exper, anal, data.fixations.timecourse.onSmaller(:,:,4), "arcsin")], ...
            ["first_double_visual", "second_double_visual", ...
             "first_double_manual",  "second_double_manual", ...
             "trans_first_double_visual", "trans_second_double_visual", ...
             "trans_first_double_manual", "trans_second_double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/propOnSmaller_short.csv"));
exportLong(exper, ...
           ["SubNo", "Exp", "Targ", "Dv"], ...
           strcat(exper.path.ANALYSIS, "statistics/propOnSmaller_long.csv"), ...
           [data.fixations.timecourse.onSmaller(:,:,2), ...
            data.fixations.timecourse.onSmaller(:,:,4)], ...
           [1; 1; 2; 2], ...
           [1; 2; 1; 2]);

% Proportion movements on closer
exportShort([data.fixations.timecourse.onClosest(:,:,2), ...
             data.fixations.timecourse.onClosest(:,:,4), ...
             transformDv(exper, anal, data.fixations.timecourse.onClosest(:,:,2), "arcsin"), ...
             transformDv(exper, anal, data.fixations.timecourse.onClosest(:,:,4), "arcsin")], ...
            ["first_double_visual", "second_double_visual", ...
             "first_double_manual",  "second_double_manual", ...
             "trans_first_double_visual", "trans_second_double_visual", ...
             "trans_first_double_manual", "trans_second_double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/propOnClosest_short.csv"));
exportLong(exper, ...
           ["SubNo", "Exp", "Targ", "Dv"], ...
           strcat(exper.path.ANALYSIS, "statistics/propOnClosest_long.csv"), ...
           [data.fixations.timecourse.onClosest(:,:,2), ...
             data.fixations.timecourse.onClosest(:,:,4)], ...
           [1; 1; 2; 2], ...
           [1; 2; 1; 2]);

% Decision noise
exportShort([probabilisticModel.pred.visual.freeParameter(:,2), ...
             probabilisticModel.pred.manual.freeParameter(:,2)], ...
            ["double_visual", "double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/decisionNoise_short.csv"));

% Fixation noise
exportShort([probabilisticModel.pred.visual.freeParameter(:,1), ...
             probabilisticModel.pred.manual.freeParameter(:,1)], ...
            ["double_visual", "double_manual"], ...
            strcat(exper.path.ANALYSIS, "statistics/fixationNoise_short.csv"));

%% Store data
save(strcat(exper.path.DATA, "data_newPipeline.mat"));

%% Create plots
if fig.toggle.SAVE
    plotGazeShiftMetrics(exper, anal, ...
                         data.fixations.subset, ...
                         data.gaze.gazeShifts.amplitudes, ...
                         data.gaze.gazeShifts.duration, ...
                         data.gaze.gazeShifts.latency, ...
                         data.gaze.gazeShifts.meanGazePos, ...
                         data.gaze.gazeShifts.idx, ...
                         data.log.nCompletedTrials)
    plotTemporalMeasures(exper, anal, ...
                         data.fixations.subset, ...
                         data.time.planning.trialwise, ...
                         data.time.inspection.trialwise, ...
                         data.time.dwell.trialwise, ...
                         data.time.response.trialwise, ...
                         data.gaze.gazeShifts.idx, ...
                         data.log.nCompletedTrials)
end

%% DEBUG: check whether results from new match old pipeline
% Check which version of old pipeline data to load
oldDataVersion = "_allExclusions";

% For check of gaze data matrix: can run with bad trials excluded, because
% those are taken care of within the checkPipelines function
% 
% For check of individual variables: needs to run without bad trials
% exclusion, because this was not taken into account in the old pipeline,
% and thus, the data from there does not match
% 
% For latency timecourse:
% due to a bug in the old pipeline, the results of the two pipelines will
% always differ (bug was fixed in new pipeline)
checkPipelines(exper, anal, logCol, data.log, data.gaze, ...
               data.fixations, data.time, data.choice, ...
               data.badTrials, quality.excludedTrials, oldDataVersion);
compareVariableOfInterest(quality.proportionValidTrials, ...
                          "proportionValid", oldDataVersion);
compareVariableOfInterest(data.time.propTrialsWithResp, ...
                          "proportionTrialsWithResponse", oldDataVersion);
compareVariableOfInterest(data.time.lostTime, ...
                          "timeLostExcldTrials", oldDataVersion);
compareVariableOfInterest(data.fixations.propTrialOneAoiFix, ...
                          "aoiFix", oldDataVersion);
compareVariableOfInterest(data.performance.proportionCorrect.easy, ...
                          "propCorrectEasy", oldDataVersion);
compareVariableOfInterest(data.performance.proportionCorrect.difficult, ...
                          "propCorrectDifficult", oldDataVersion);
compareVariableOfInterest(data.time.planning.mean.easy, ...
                          "planningTimeEasy", oldDataVersion);
compareVariableOfInterest(data.time.planning.mean.difficult, ...
                          "planningTimeDifficult", oldDataVersion);
compareVariableOfInterest(data.time.inspection.mean.easy, ...
                          "inspectionTimeEasy", oldDataVersion);
compareVariableOfInterest(data.time.inspection.mean.difficult, ...
                          "inspectionTimeDifficult", oldDataVersion);
compareVariableOfInterest(data.time.response.mean.easy, ...
                          "responseTimeEasy", oldDataVersion);
compareVariableOfInterest(data.time.response.mean.difficult, ...
                          "responseTimeDifficult", oldDataVersion);
compareVariableOfInterest(data.choice.target.proportionEasy(:,:,[2,4]), ...
                          "proportionEasyChoices", oldDataVersion);
compareVariableOfInterest(data.choice.regressionFit(:,:,[2,4]), ...
                          "regression", oldDataVersion);
compareVariableOfInterest(data.fixations.timecourse.onChosen(:,:,[2,4]), ...
                          "propGsOnChosen", oldDataVersion);
compareVariableOfInterest(data.fixations.timecourse.onSmaller(:,:,[2,4]), ...
                          "propGsOnSmaller", oldDataVersion);
compareVariableOfInterest(data.fixations.timecourse.onClosest, ...
                          "propGsOnClosest", oldDataVersion);
compareVariableOfInterest(data.fixations.propFixOnChosenModelEval, ...
                          "propGsOnChosenModel", oldDataVersion);
compareVariableOfInterest(data.time.nonSearch.mean.easy, ...
                          "nonSearchTimeEasy", oldDataVersion);
compareVariableOfInterest(data.time.nonSearch.mean.difficult, ...
                          "nonSearchTimeDifficult", oldDataVersion);
compareVariableOfInterest(idealObserver.gain.abs, ...
                          "gainAbsolut", oldDataVersion);
compareVariableOfInterest(idealObserver.proChoices.easy, ...
                          "predPropChoicesEasy", oldDataVersion);
compareVariableOfInterest(data.performance.gainPerTime, ...
                          "empGainPerTime", oldDataVersion);
compareVariableOfInterest(idealObserver.performance, ...
                          "predPerformance", oldDataVersion);
compareVariableOfInterest(data.fixations.latenciesFirstGazeShift, ...
                          "latencyTimecourse", oldDataVersion);

%% How much time participants spent searching for targets
sacc.time.search_reg_coeff = NaN(exper.num.subNo, 2, exper.num.condNo);
sacc.time.search_confInt   = NaN(2, 2, exper.num.subNo, exper.num.condNo);
sacc.time.search_ss        = NaN(exper.num.subNo, 9, exper.num.condNo);
for c = 1:exper.num.condNo % Condition

    for s = 1:exper.num.subNo % Subject

        thisSubject   = exper.num.subs(s);
        searchTime = sacc.time.search{thisSubject, c};
        if ~isempty(searchTime)

            searchTime = sacc.time.search{thisSubject, c}(:, 4);
            noDis_sub  = [stim.no_easyDis{thisSubject, c} stim.no_hardDis{thisSubject, c}];
            no_ss      = unique(noDis_sub(~isnan(noDis_sub(:, 1)), 1));
            for ss = 1:numel(no_ss) % Set size

                switch c

                    case 1
                        li_trials = any(noDis_sub == no_ss(ss), 2);

                    case 2
                        li_trials = noDis_sub(:, 1) == no_ss(ss);

                end

                sacc.time.search_ss(thisSubject, ss, c) = mean(searchTime(li_trials), 'omitnan');
                clear li_trials

            end
            clear no_ss ss noDis_sub

            % Regression over mean inspection time for different set sizes
            reg_predictor = (0:8)';
            reg_criterion = sacc.time.search_ss(thisSubject, :, c)';

            [sacc.time.search_reg_coeff(thisSubject, :, c), sacc.time.search_confInt(:, :, thisSubject, c)] = ...
                regress(reg_criterion, [ones(numel(reg_predictor), 1) reg_predictor]);
            clear reg_predictor reg_criterion

        end
        clear thisSubject searchTime

    end
    clear s

end
clear c
