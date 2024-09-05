clc
clear all
close all

load data_benchmark

n_correct_maxtarget=zeros(35,5);
accuracy_weight=zeros(35,20);
for subs=1:1:35
fs=250;
eeg=squeeze(benchmark(subs,:,:,:,:));
[num_chans, num_samps, num_targs, num_trials] = size(eeg);
for targ_i=1:num_targs
    for chan_i=1:num_chans
        for tri_i=1:num_trials
x(:)=eeg(chan_i,:,targ_i,tri_i);
Wp=[8 88]/(fs/2);
Ws=[4 100]/(fs/2);
[n,Wp]=cheb1ord(Wp,Ws,3,20);
[B,A]=cheby1(n,3,Wp);
sub_data(chan_i,:,targ_i,tri_i)=filtfilt(B,A,x);
        end
    end
end
filtered_eeg=sub_data(:,161:410,:,:);%([48 54 55 56 57 58 61 62 63],:,:,:);%channel sample target trial
SSVEPdata=permute(filtered_eeg,[1 2 4 3]);
TW_p=[50 100 150 200 250];

TW=0.2:0.2:1;
%% construct individual template
for trial=1:num_trials
    idx_traindata=1:num_trials;
    idx_traindata(trial)=[];
    sum=0;
for i=1:(num_trials-1)
    sum=sum+filtered_eeg(:,:,:,idx_traindata(i));
end
temp(:,:,trial,:)=sum/(num_trials-1);
end
for tw_length=1:4
    for run=1:num_trials
        tic
              n_correct_maxtarget(subs,tw_length)=0;% before each run, set 0
              idx_traintrial=1:num_trials;
              idx_traintrial(run)=[];
              traindata=SSVEPdata(:,1:TW_p(tw_length),idx_traintrial,:);%select training trials
              model=train_improved_cca(traindata);% concatenate reference signal
              conti_model=train_continuous_trials(traindata);% concatenate training data
              train_trial=squeeze(conti_model.trains(:,:,1,:));
                %calculate filter W
                for targ_i=1:num_targs 
                    fprintf('Maxtarget Processing... Subject %d, TW %fs, No.crossvalidation %d, Target %d\n',subs, TW(tw_length),run,targ_i);  
                    idx_targ=1:num_targs;
                    idx_targ(targ_i)=[];
                    weight_value=6;
                                        fun = @(w)[-corr(train_trial(:,:,targ_i)'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(1))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(2))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(3))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(4))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(5))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(6))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(7))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(8))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(9))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(10))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(11))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(12))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(13))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(14))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(15))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(16))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(17))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(18))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(19))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(20))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(21))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(22))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(23))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(24))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(25))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(26))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(27))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(28))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(29))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(30))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(31))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(32))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(33))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(34))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(35))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(36))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(37))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(38))'*w,model.ref(:,:,targ_i)'*w)
                                        corr(train_trial(:,:,idx_targ(39))'*w,model.ref(:,:,targ_i)'*w)];   
             goal = [-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
             weight = [1/weight_value,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];     
             Aeq=[1,1,1,1,1,1,1,1,1];
             beq=0;
             w0 = -1+2*rand(9,1);
             [w,fval]= fgoalattain(fun,w0,goal,weight,[],[],Aeq,beq);
             fval
             W{targ_i}=w;
        end
toc
tic
        for j=1:num_targs
           r1=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{1},temp(:,1:TW_p(tw_length),run,1)'*W{1});
           r2=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{2},temp(:,1:TW_p(tw_length),run,2)'*W{2});
           r3=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{3},temp(:,1:TW_p(tw_length),run,3)'*W{3});
           r4=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{4},temp(:,1:TW_p(tw_length),run,4)'*W{4});
           r5=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{5},temp(:,1:TW_p(tw_length),run,5)'*W{5});
           r6=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{6},temp(:,1:TW_p(tw_length),run,6)'*W{6});
           r7=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{7},temp(:,1:TW_p(tw_length),run,7)'*W{7});
           r8=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{8},temp(:,1:TW_p(tw_length),run,8)'*W{8});
           r9=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{9},temp(:,1:TW_p(tw_length),run,9)'*W{9});
           r10=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{10},temp(:,1:TW_p(tw_length),run,10)'*W{10});
           r11=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{11},temp(:,1:TW_p(tw_length),run,11)'*W{11});
           r12=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{12},temp(:,1:TW_p(tw_length),run,12)'*W{12});
           r13=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{13},temp(:,1:TW_p(tw_length),run,13)'*W{13});
           r14=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{14},temp(:,1:TW_p(tw_length),run,14)'*W{14});
           r15=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{15},temp(:,1:TW_p(tw_length),run,15)'*W{15});
           r16=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{16},temp(:,1:TW_p(tw_length),run,16)'*W{16});
           r17=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{17},temp(:,1:TW_p(tw_length),run,17)'*W{17});
           r18=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{18},temp(:,1:TW_p(tw_length),run,18)'*W{18});
           r19=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{19},temp(:,1:TW_p(tw_length),run,19)'*W{19});
           r20=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{20},temp(:,1:TW_p(tw_length),run,20)'*W{20});
           r21=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{21},temp(:,1:TW_p(tw_length),run,21)'*W{21});
           r22=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{22},temp(:,1:TW_p(tw_length),run,22)'*W{22});
           r23=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{23},temp(:,1:TW_p(tw_length),run,23)'*W{23});
           r24=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{24},temp(:,1:TW_p(tw_length),run,24)'*W{24});
           r25=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{25},temp(:,1:TW_p(tw_length),run,25)'*W{25});
           r26=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{26},temp(:,1:TW_p(tw_length),run,26)'*W{26});
           r27=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{27},temp(:,1:TW_p(tw_length),run,27)'*W{27});
           r28=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{28},temp(:,1:TW_p(tw_length),run,28)'*W{28});
           r29=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{29},temp(:,1:TW_p(tw_length),run,29)'*W{29});
           r30=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{30},temp(:,1:TW_p(tw_length),run,30)'*W{30});
           r31=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{31},temp(:,1:TW_p(tw_length),run,31)'*W{31});
           r32=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{32},temp(:,1:TW_p(tw_length),run,32)'*W{32});
           r33=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{33},temp(:,1:TW_p(tw_length),run,33)'*W{33});
           r34=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{34},temp(:,1:TW_p(tw_length),run,34)'*W{34});
           r35=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{35},temp(:,1:TW_p(tw_length),run,35)'*W{35});
           r36=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{36},temp(:,1:TW_p(tw_length),run,36)'*W{36});
           r37=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{37},temp(:,1:TW_p(tw_length),run,37)'*W{37});
           r38=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{38},temp(:,1:TW_p(tw_length),run,38)'*W{38});
           r39=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{39},temp(:,1:TW_p(tw_length),run,39)'*W{39});
           r40=corr(SSVEPdata(:,1:TW_p(tw_length),run,j)'*W{40},temp(:,1:TW_p(tw_length),run,40)'*W{40});
           [v,idx]=max([max(r1),max(r2),max(r3),max(r4),max(r5),max(r6),max(r7),max(r8),max(r9),max(r10),max(r11),max(r12),max(r13),max(r14),max(r15),max(r16),max(r17),max(r18),max(r19),max(r20),max(r21),max(r22),max            (r23),max(r24),max(r25),max(r26),max(r27),max(r28),max(r29),max(r30),max(r31),max(r32),max(r33),max(r34),max(r35),max(r36),max(r37),max(r38),max(r39),max(r40)]);
            if idx==j
                n_correct_maxtarget(subs,tw_length)=n_correct_maxtarget(subs,tw_length)+1;
            end
        end%targets 
        toc
        accs_proposed(subs,tw_length,run)=n_correct_maxtarget(subs,tw_length)/num_targs*100;
        itrs(subs,tw_length,run) = itr(num_targs, accs_proposed(subs,tw_length,run)/100, TW(tw_length)+0.5);
    end%run
     accuracy_proposed(subs,tw_length)=mean(accs_proposed(subs,tw_length,:));
     itr_proposed(subs,tw_length)=mean(itrs(subs,tw_length,:));
end%tw_length
end%subs