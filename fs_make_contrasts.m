function con = fs_make_contrasts(SPM)

fun = @(s,p)(~isempty(regexp(s, p, 'once')));

ri = cellfun(@(s)(fun(s, 'right index')), SPM.xX.name);
rr = cellfun(@(s)(fun(s, 'right ring')), SPM.xX.name);
li = cellfun(@(s)(fun(s, 'left index')), SPM.xX.name);
lr = cellfun(@(s)(fun(s, 'left ring')), SPM.xX.name);
bl = cellfun(@(s)(fun(s, 'baseline')), SPM.xX.name);

bl(SPM.Sess(1).col);

sess = cell(size(SPM.Sess));
for i = 1:length(SPM.Sess)    
    for j = 1:length(SPM.Sess(i).Fc)
        if fun(SPM.Sess(i).Fc(j).name, 'right')
            sess{i} = 'right';
            break;
        elseif fun(SPM.Sess(i).Fc(j).name, 'left')
            sess{i} = 'left';
            break;
        end
    end
end

% F contrasts
% Effects of interest
EOIR = [ri; rr];
EOIL = [li; lr]; %zeros(size(bl))
EOIA = EOIR+EOIL;   

% T1 contrasts
% Each finger separately
rb = zeros(size(bl));
rb([3+27*1 3+27*3]) = 1;
lb = zeros(size(bl));
lb([3+27*0 3+27*2]) = 1;

%rb = zeros(size(bl));
%rb([3+27*0 3+27*1]) = 1;
%lb = zeros(size(bl));
%lb([3+27*2 3+27*3]) = 1;

RI = ri/sum(ri) - rb/sum(rb);%bl/sum(bl);
RR = rr/sum(rr) - rb/sum(rb);%bl/sum(bl);
LI = li/sum(li) - lb/sum(lb);%bl/sum(bl);
LR = lr/sum(lr) - lb/sum(lb);%bl/sum(bl);

% Index vs. Ring
RIvsRR = ri/sum(ri) - rr/sum(rr);
RRvsRI = rr/sum(rr) - ri/sum(ri);
LIvsLR = li/sum(li) - lr/sum(lr);
LRvsLI = lr/sum(lr) - li/sum(li);

con(1).name    = 'Effects (All)';
con(1).weights = EOIA;
con(2).name    = 'Effects (Right)';
con(2).weights = EOIR;
con(3).name    = 'Effects (Left)';
con(3).weights = EOIL;

con(4).name    = 'Index (Right)';
con(4).weights = RI;
con(5).name    = 'Ring (Right)';
con(5).weights = RR;
con(6).name    = 'Index (Left)';
con(6).weights = LI;
con(7).name    = 'Ring (Left)';
con(7).weights = LR;

con(8).name    = 'Index > Ring (Right)';
con(8).weights = RIvsRR;
con(9).name    = 'Ring > Index (Right)';
con(9).weights = RRvsRI;
con(10).name    = 'Index > Ring (Left)';
con(10).weights = LIvsLR;
con(11).name    = 'Ring > Index (Left)';
con(11).weights = LRvsLI;

for c = 1:length(con)
    con(c).weights = double(con(c).weights);
end
