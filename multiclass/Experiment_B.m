function  Experiment_B(dataset_name)
% Experiment of different budget size
%--------------------------------------------------------------------------
% Input:
%      dataset_name: the name of the dataset file
% Output:
%      a figure of online mistake rates for all the algorithms
%      a figure of online SV size for all the algorithms
%      a figure of online time consumption for all the algorithms
%      a table of the final mistake rates, SV size, time consumption for all the algorithms
%--------------------------------------------------------------------------

%% load dataset
load(sprintf('data/%s',dataset_name));
[n,d]= size(data);
Y=data(:,1);
X=data(:,2:end);
%% options
options.eta_fou=0.001;
options.C=10;
options.rho=0.2;% rho \in [0,1]
options.eta    =  0.5;%learning rate
options.k=0.2;
options.sigma=8;     %sigma: kernel width
options.n_label=max(Y);    %the number of possible label set
options.t_tick=round(n/10);   %the number of possible label set
options.lambda =  1/(n^2);
options.gamma  =  10;
options.rou_f=4;
options.C_BPAs = 1;
    ID = ID_list(2,:);
B=[10:10:70 100 150 200]
%% run experiments:

    % 1. Max perceptron
    [err_count, run_time, mistakes, mistakes_idx, SVs,size_SV, TMs] = perceptron(Y,X, ID,options);
    for j=1:size(B,2)

    err_MA(j) = err_count;
    time_MA(j) = run_time;
    end

    % 4. OGD
    [err_count, run_time, mistakes, mistakes_idx, SVs,size_SV, TMs] = ogd(Y,X, ID,options);
    for j=1:size(B,2)

    err_OGD(j) = err_count;
    time_OGD(j) = run_time;
    end
%     
    
    for i=1:size(B,2)
    ID = ID_list(1,:);
      options.Budget=B(i);
    i
    % 5. FouGD
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = FouGD(Y, X, ID, options);
    err_FG(i) = err_count;
    time_FG(i) = run_time;

    % 5. NyGD
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = NyGD(Y,X, ID, options);
    err_NY(i) = err_count;
    time_NY(i) = run_time;

    % 7. RBP
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = RBP(Y,X, ID, options);
    err_RBP(i) = err_count;
    time_RBP(i) = run_time;

    % 8. forgetron
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = forgetron(Y,X, ID, options);
    err_for(i) = err_count;
    time_for(i) = run_time;
    
        % 9. projectron
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = projectron(Y,X, ID, options);
    err_projectron(i) = err_count;
    time_projectron(i) = run_time;

    % 10. projectron++
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = proplus(Y,X, ID, options);
    err_plus(i) = err_count;
    time_plus(i) = run_time;
    
        % 11. BOGD
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = BOGD(Y,X, ID, options);

    err_BOGD(i) = err_count;
    time_BOGD(i) = run_time;
    %bPAS
    [err_count, run_time, mistakes, mistakes_idx, SVs, size_SV, TMs] = BPAs(Y,X, ID, options);

    err_bpas(i) = err_count;
    time_bpas(i) = run_time;



end
%% print and plot results
figure
plot(B, err_MA,'b.-');
hold on
plot(B, err_OGD,'b-v');
plot(B, err_RBP,'r-p');
plot(B, err_for,'r-x');
plot(B, err_projectron,'r-o');
plot(B, err_plus,'r-*');
plot(B,err_bpas,'r-s');
plot(B,err_BOGD,'r-^');
plot(B, err_FG,'m-d');
plot(B, err_NY,'m-<');
legend('Perceptron','OGD','RBP','forgetron','projectron','projectron++','BPAS','BOGD','FOGD','NOGD');
xlabel('Budget Size');
ylabel('Online average rate of mistakes')
grid
%saveas(gcf,'dna_mistake_100','fig')

figure
hold on
plot(B,log(time_MA)/log(10),'b.-');
plot(B,log(time_OGD)/log(10),'b-v');
plot(B, log(time_RBP)/log(10),'r-p');
plot(B, log(time_for)/log(10),'r-x');
plot(B, log(time_projectron)/log(10),'r-o');
plot(B, log(time_plus)/log(10),'r-*');
plot(B,log(time_bpas)/log(10),'r-s');
plot(B,log(time_BOGD)/log(10),'r-^');
plot(B, log(time_FG)/log(10),'m-d');
plot(B, log(time_NY)/log(10),'m-<');
legend('Perceptron','OGD','RBP','forgetron','projectron','projectron++','BPAS','BOGD','FOGD','NOGD');
xlabel('Budget Size');
ylabel('average time cost (log_{10} t)')
grid


