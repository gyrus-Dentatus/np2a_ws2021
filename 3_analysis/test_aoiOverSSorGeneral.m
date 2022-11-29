cond_idx = [ones(1, 5) ones(1, 5)+1];
stim_idx = [(1:5) (1:5)];
% test     = squeeze(mean(sacc.propGs.onAOI_ss, 2, 'omitnan'));
test     = squeeze(mean(sacc.propGs.onAOI_ss(:, 2:end, :, :), 2, 'omitnan'));

close all
for sp = 1:10
    subplot(2, 5, sp)
    plot((1:2)+0.20, ...
         [sacc.propGs.onAOI(:, stim_idx(sp), cond_idx(sp)) test(:, stim_idx(sp), cond_idx(sp))], ...
         '-o')
    hold on
    plot(1:2, ...
         mean([sacc.propGs.onAOI(:, stim_idx(sp), cond_idx(sp)) test(:, stim_idx(sp), cond_idx(sp))], 'omitnan'), ...
         '-o', ...
         'MarkerFaceColor', [0 0 0], ...
         'MarkerEdgeColor', 'none', ...
         'LineWidth', 2)
    hold off
    axis([0 3 0 1])
    xticks(1:1:2)
    xticklabels({'Over all' 'Over ss'})
end

figure
plot((1:2)+0.20, ...
 [sacc.propGs.onAOI(:, 5, 1) test(:, 5, 1)], ...
 '-o')