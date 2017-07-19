function fs_print_bar(S, L)
if nargin < 1
    S = '=';
end
if nargin < 2
    L = 72;
end
fprintf([repmat(S,1,L) '\n\n'])