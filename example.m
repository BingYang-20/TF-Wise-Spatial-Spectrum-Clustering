
clc; clear;
load('x.mat'); % GT:90,230,315
[doa_est] = MSSL(x);
