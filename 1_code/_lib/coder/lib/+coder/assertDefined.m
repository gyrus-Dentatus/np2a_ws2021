function assertDefined(~)
% CODER.ASSERTDEFINED marks memory as initialized.
%
%   CODER.ASSERTDEFINED(X) forces X to be treated as defined at this point
%   even if the analysis cannot prove it. CODER.ASSERTDEFINED preserves the
%   value currently in the variable.
%
%   Note: CODER.ASSERTDEFINED can result in unpredictable behavior if used
%   incorrectly.  This function overrides compiler checks designed to
%   prevent errors.  When possible, it is best to refactor your code to
%   avoid the need for CODER.ASSERTDEFINED.
%
%   Example:
%      if x > 1
%         w = 5;
%      end
%      ... Do something here ...
%      if x > 1
%         coder.assertDefined(w);
%         y = w + 1;
%      end
%   Without the use of coder.assertDefined, code generation would complain
%   that w may not be defined on all paths.
%
%
%   This is a code generation function.  It has no effect in MATLAB.
%
%   See also CODER.NULLCOPY

%  Copyright 2014-2019 The MathWorks, Inc.
