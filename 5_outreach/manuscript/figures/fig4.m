clear all; close all; clc

%% Get data
% Set folder
folder.root = '/Users/ilja/Dropbox/12_work/mr_informationSamplingVisualManual/';
folder.data = strcat(folder.root, '2_data/');
folder.fig = strcat(folder.root, "5_outreach/manuscript/figures/fig4");

data = load(strcat(folder.data, 'data_newPipeline.mat'));

%% Plot settings
% Assemble data for plot
plotDat = cat(3, ...
              data.data.fixations.timecourse.onChosen(:,:,2), ...
              data.data.fixations.timecourse.onSmaller(:,:,2), ...
              data.data.fixations.timecourse.onClosest(:,:,2), ...
              data.data.fixations.timecourse.onChosen(:,:,4), ...
              data.data.fixations.timecourse.onSmaller(:,:,4), ...
              data.data.fixations.timecourse.onClosest(:,:,4));

% Define visuals
opt_visuals;
yLabels = repmat(["Prop. mov. [chosen set]", ...
                  "Prop. mov. [smaller set]", ...
                  "Prop. mov. [closest stim.]"], 1, 2);
axLimits = [0, 3, 0, 1];
lineCoordsY = repmat([[0.50, 0.50]; [0.25, 0.25]; [1/10, 1/10]], 2, 1);

%% Plot
hFig = figure;
tiledlayout(2, 3);
for p = 1:size(plotDat, 3) % Panel
    if any(p == 1:2)
        plt.color.condition = plt.color.green;
    else
        plt.color.condition = plt.color.purple;
    end
    xSubjects = 1:size(plotDat(:,:,p), 2);
    xMeans = linspace((xSubjects(1) - 0.25), (xSubjects(end) + 0.25), ...
                      xSubjects(end));

    nexttile;
    line(axLimits(1:2), lineCoordsY(p,:), ...
         'LineStyle', '--', ...
         'LineWidth', plt.line.widthThin, ...
         'Color', plt.color.gray(3,:), ...
         'HandleVisibility', 'off');
    hold on
    plot(xSubjects, plotDat(:,:,p), ...
         'o-', ...
         'MarkerSize', plt.marker.sizeSmall, ...
         'MarkerFaceColor', plt.color.condition(2,:), ...
         'MarkerEdgeColor', plt.color.white, ...
         'LineWidth', plt.line.widthThin, ...
         'Color', plt.color.condition(2,:));
    errorbar(xMeans, mean(plotDat(:,:,p), 1, 'omitnan'), ci_mean(plotDat(:,:,p)), ...
             'o', ...
             'MarkerSize', plt.marker.sizeLarge, ...
             'MarkerFaceColor', plt.color.condition(1,:), ...
             'MarkerEdgeColor', 'none', ...
             'LineWidth', plt.line.widthThin, ...
             'CapSize', 0, ...
             'Color', plt.color.condition(1,:), ...
             'HandleVisibility', 'off');
    hold off
    axis(axLimits, 'square');
    xlabel("# mov. after trial start");
    ylabel(yLabels(p));
    xticks(xSubjects);
    yticks(0:0.25:1);
    box off
end
sublabel([], -30, -40);
opt.size = [45, 30];
opt.imgname = folder.fig;
opt.save = true;
prepareFigure(hFig, opt);
close;