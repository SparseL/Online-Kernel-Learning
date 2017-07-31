function [err_count,loss_avg,loss_v, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] =perceptron(Y, X, id_list, options)
% Max_K_M: Perceptron based on max multiclass update (Koby Crammer and Yoram Singer. Ultraconservative online algorithms for multiclass problems. JMLR, 3:951?91, 2003.)
%--------------------------------------------------------------------------
% Input:
%        Y:    the column vector of lables, where Y(t) is the lable for t-th instance ;
%        X:    features;
%  id_list:    a random permutation of the 1,2,...,T;
%  options:    a struct containing C, rho, sigma, n_lable, t_tick;
% Output:
%   err_count:  total number of training errors
%    run_time:  time consumed by this algorithm at a time
%    mistakes:  a vector of online mistake rate
% mistake_idx:  a vector of index, in which every idex is a time and corresponds to a mistake rate in the vector above
%         SVs:  a vector recording the online number of support vectors for every idex in mistake_idx
%     size_SV:  the final size of the support vector set
%         TMs:  a vector recording the online time consumption
%--------------------------------------------------------------------------
%% initialize parameters
t_tick = options.t_tick;
epsl=options.epsl;
eta=options.eta_perceptron;
ID = id_list;
N= size(Y,1);

%% classifier
alpha = [];
SV = [];
%% evaluation
err_count = 0;
loss_avg=0;
size_SV=0;
mistakes = [];
mistakes_idx = [];
SVs = [];
TMs=[];
loss_v=[];
%% loop
tic
for t = 1:length(ID),
    id = ID(t);
    %% compute f_t(x_t)
    if (isempty(alpha)),
        f_t=0;
    else
        k_t = comp_K(X, options, id, SV);
        f_t=alpha*k_t;
    end
   %%

    y_t=Y(id);
    delt=y_t-f_t;
    loss_avg=loss_avg+delt^2;
    if (abs(delt)>epsl),
        err_count = err_count + 1;
        size_SV=size_SV+1;

        alpha = [alpha eta*sign(delt)];
        SV = [SV id];
    end



    %% record performance
    run_time = toc;
    if (mod(t,t_tick)==0),
        mistakes = [mistakes err_count/t];
        mistakes_idx = [mistakes_idx t];
        SVs = [SVs length(SV)];
        TMs=[TMs run_time];
        loss_v=[loss_v loss_avg/t];
    end
end

run_time = toc;
err_count=err_count/N;
loss_avg=loss_avg/N;
