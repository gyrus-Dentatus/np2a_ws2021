function U = triu(A, kIn)
%MATLAB Code Generation Library Function

%   Copyright 2018 The MathWorks, Inc.
%#codegen

narginchk(1,2);
coder.internal.assert(ismatrix(A), ...
    'Coder:MATLAB:triu_firstInputMustBe2D');


ONE = coder.internal.indexInt(1);
if nargin < 2
    k = coder.internal.indexInt(0);
else
    coder.internal.prefer_const(kIn);
    if issparse(kIn)
        U = triu(A, full(kIn));
        return;
    end  
    coder.internal.assert(coder.internal.isBuiltInNumeric(kIn) &&...
        isscalar(kIn) && isreal(kIn) && floor(kIn) == kIn, ...
        'MATLAB:triu:kthDiagInputNotInteger');
    
    k = coder.internal.indexInt(kIn);
end

U = coder.internal.sparse.spallocLike(A.m, A.n, nnz(A), A);
U.colidx(ONE) = ONE;
didx = ONE;
for col = ONE:coder.internal.indexInt(size(A, 2))
    ridx = A.colidx(col);
    colEnd = A.colidx(col+1);
    while(ridx < colEnd && A.rowidx(ridx) <= col-k)
        U.rowidx(didx) = A.rowidx(ridx);
        U.d(didx) = A.d(ridx);
        didx = didx+1;
        ridx = ridx+1;
    end
    U.colidx(col+1) = didx;
end

coder.internal.sparse.sanityCheck(U);
end