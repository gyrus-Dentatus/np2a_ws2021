function assert(cond, msgID, varargin)
%MATLAB Code Generation Private Function

%   Copyright 2011-2019 The MathWorks, Inc.

%MATLAB execution
if ~cond
    % Handle 'IfNotConst' arguments if present
    if numel(varargin) >= 2
        str = varargin{end-1};
    else
        str = '';
    end
    catalogID = msgID;
    reportedID = msgID;
    holeFillStart = 1;
    if strcmp(msgID, 'CatalogID') ...
            && numel(varargin)>=3 ...
            && ischar(varargin{2}) ...
            && strcmp(varargin{2}, 'ReportedID')

        catalogID = varargin{1};
        reportedID = varargin{3};
        holeFillStart = 4;
    end

    try
        if (ischar(str) && strcmp(str,'IfNotConst'))
            msg = message(catalogID, varargin{holeFillStart:end-2});
            assert(false, reportedID, '%s', msg.getString);
        else
            msg = message(catalogID, varargin{holeFillStart:end});
            assert(false, reportedID, '%s', msg.getString);
        end
    catch ME
        ME.throwAsCaller();
    end
end
