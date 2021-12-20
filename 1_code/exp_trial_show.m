function epar = exp_trial_show(epar, tn)

    %% General settings
    epar.time = NaN(3, 1); % Assign memory for flip times
    Priority(2);           % Script execution priority


    %% Present fixation target
    exp_target_draw(epar.window, epar.fixLoc_px(1), epar.fixLoc_px(2), ...
                    epar.fixsize(2), epar.fixsize(1), epar.fixcol, epar.gray);
    epar.time(1) = Screen('Flip', epar.window);
    if epar.EL

        Eyelink('Message', 'FIX_ON');

    end


    %% Present stimuli
    % Draw the fixation cross
    exp_target_draw(epar.window, epar.x_center, epar.y_center, ...
                    epar.fixsize(2), epar.fixsize(1), epar.fixcol, epar.gray);

    % Draw target(s)
    if epar.expNo == 2 

        Screen('DrawTextures', epar.window, epar.stim.txt_disp_mask(end), [], ...
               epar.tex_rect(:, end));

    elseif epar.expNo == 3

        Screen('DrawTextures', epar.window, epar.stim.txt_disp_mask(end-1:end), [], ...
               epar.tex_rect(:, end-1:end));

    end

    % Draw rest
    epar.stim.txt_disp      = epar.stim.txt_disp(~isnan(epar.stim.txt_disp));
    epar.stim.txt_disp_mask = epar.stim.txt_disp_mask(~isnan(epar.stim.txt_disp_mask));

    exp_target_draw(epar.window, epar.fixLoc_px(1), epar.fixLoc_px(2), ...
                    epar.fixsize(2), epar.fixsize(1), epar.fixcol, epar.gray);

        Screen('DrawTextures', epar.window, epar.stim.txt_disp_mask(1:epar.trials.dist_num(tn)), [], ...
               epar.tex_rect(:, 1:epar.trials.dist_num(tn)));

    end

    epar.time(2) = Screen('Flip', epar.window, epar.time(1) + epar.stim_frame);
    if epar.EL

        Eyelink('Message', 'STIM_ON');

    end

    % Create screenshots of the search display
%     imageArray = Screen('GetImage', epar.window);
%     if epar.expNo == 2
% 
%         imwrite(imageArray, 'stimArray_exp2.jpg')
% 
%     elseif epar.expNo == 3
% 
%         imwrite(imageArray, 'stimArray_exp3.jpg')
% 
%     end

end