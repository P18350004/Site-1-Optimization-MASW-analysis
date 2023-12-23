clear all
close all
clc
%% DATA INPUT 
Filename = 'shot_5mo_2dx_2_0.3s.dat';
HeaderLines = 7;
fs = 4000; % Hz
N = 24;
x1 = 10; % m
dx = 1; % m
Direction = 'forward';

[u,t,Tmax,L,x] = MASWaves_read_data(Filename,HeaderLines,fs,N,dx,x1,Direction);

%% PLOT DATA 
du = 1/10;
% du = 1/50;
FigWidth = 10; % cm
FigHeight = 8; % cm
FigFontSize = 14; % pt

figure
MASWaves_plot_data(u,N,dx,x1,L,t,Tmax,du,FigWidth,FigHeight,FigFontSize)

%% DISPERSION 
cT_min = 0; % m/s
cT_max = 1200; % m/s
delta_cT = 5; % m/s

[f,c,A] = MASWaves_dispersion_imaging(u,N,x,fs,cT_min,cT_max,delta_cT);

%% VELOCITY SPECTRA 2D
resolution = 100; 
fmin = 0; % Hz
fmax = 90; % Hz
FigWidth = 10; % cm
FigHeight = 10; % cm
FigFontSize = 8; % pt
figure
[fplot,cplot,Aplot] = MASWaves_plot_dispersion_image_2D(f,c,A,fmin,fmax,...
    resolution,FigWidth,FigHeight,FigFontSize);

%% VELOCITY SPECTRA 3D
fmin = 0; % Hz
fmax = 90; % Hz
FigWidth = 10; % cm
FigHeight = 10; % cm
FigFontSize = 8; % pt
figure
[fplot,cplot,Aplot] = MASWaves_plot_dispersion_image_3D(f,c,A,fmin,fmax,...
    FigWidth,FigHeight,FigFontSize);

%% SELECT POINTS 
f_receivers = 4.5; % Hz
 %select = 'mouse';
%  select = 'both';
select = 'numbers';
up_low_boundary = 'no'; 
p = 95; % Percentage
[f_curve0,c_curve0,lambda_curve0,...
    f_curve0_up,c_curve0_up,lambda_curve0_up,...
    f_curve0_low,c_curve0_low,lambda_curve0_low] = ...
    MASWaves_extract_dispersion_curve(f,c,A,fmin,fmax,f_receivers,...
    select,up_low_boundary,p);

%% DISPERSION CURVE GENERATION
FigWidth = 9; % cm
FigHeight = 6; % cm
FigFontSize = 8; % pt
type = 'f_c';
up_low_boundary = 'yes';
figure
MASWaves_plot_dispersion_curve(f_curve0,c_curve0,lambda_curve0,...
     f_curve0_up,c_curve0_up,lambda_curve0_up,f_curve0_low,c_curve0_low,...
     lambda_curve0_low,type,up_low_boundary,FigWidth,FigHeight,FigFontSize)

FigWidth = 7; % cm
FigHeight = 9; % cm
FigFontSize = 12; % pt
type = 'c_lambda';
up_low_boundary = 'yes';
figure
MASWaves_plot_dispersion_curve(f_curve0,c_curve0,lambda_curve0,...
     f_curve0_up,c_curve0_up,lambda_curve0_up,f_curve0_low,c_curve0_low,...
     lambda_curve0_low,type,up_low_boundary,FigWidth,FigHeight,FigFontSize)
 

%% Inversion
c_test_min = 0; % m/s
c_test_max = 1200; % m/s
delta_c_test = 5; % m/s
c_test = c_test_min:delta_c_test:c_test_max; % m/s

% Layer parameters
n = 8;
alpha =[1500 1500 1500 1500 1500 1500 1500 1500 1500]; % m/s  AL
% alpha = [1200	1200	1200 1200 1200	1200	1200	1200	1200	1200]; % m/s  model3
% alpha = [2000 2000	2000	2000 2000 2000	2000	2000	2000	2000]; % m/s  model3

% alpha = [1000 1000	1000	600	400	800	1200 1000 1000 800 300]; % m/s  model3
%   h = [2	2	3	1	1	3	7]; % model3
% h = [3	1	4	4	5	1	7	6	9	15];   
 h = [2	0.4	2	2	4	2	6	0.1	14]; % 2layer_homo_0.3sec

% beta = [375	273	260	250	426	500	500	500	258	500]; 
 beta = [391	357	479	505	630	663	455	560	660]; % m/s 2layer_0.3s
%  alpha = 2*beta;  % poisson ratio = 0.33
 % beta = [236	278	254	276	196	366	261]; % m/s soil_rock_2
% beta = [351	188	320	195	225	339	261]; % m/s soil_rock_1
% beta = [268	270	252	274	253	229	270]; % m/s soil_steel_1
%  beta = [394	120	309	120	785	266	333]; % m/s soil_steel_2
rho = [ 2000 2000 2000 2000 2000 2000 2000 2000 2000]; % kg/m^3

up_low_boundary = 'yes';
[c_t,lambda_t] = MASWaves_theoretical_dispersion_curve...
    (c_test,lambda_curve0,h,alpha,beta,rho,n);

up_low_boundary = 'yes';
FigWidth = 8; % cm
FigHeight = 10; % cm
FigFontSize = 12; % pt
f_curvet = f_curve0';
figure
MASWaves_plot_theor_exp_dispersion_curves(c_t,lambda_t,...
    c_curve0,lambda_curve0,c_curve0_up,lambda_curve0_up,...
    c_curve0_low,lambda_curve0_low,up_low_boundary,...
    FigWidth,FigHeight,FigFontSize)

e = MASWaves_misfit(c_t,c_curve0);



up_low_boundary = 'yes';
FigWidth = 16; % cm
FigHeight = 10; % cm
FigFontSize = 12; % pt
figure
% MASWaves_plot_inversion_results_one_iteation(c_t,lambda_t,...
%     c_curve0,lambda_curve0,c_curve0_up,lambda_curve0_up,c_curve0_low,...
%     lambda_curve0_low,n,beta,h,e,up_low_boundary,FigWidth,FigHeight,FigFontSize)
MASWaves_plot_inversion_results_one_iteation(c_t,f_curvet,...
    c_curve0,f_curve0,c_curve0_up,f_curve0_up,c_curve0_low,...
    f_curve0_low,n,beta,h,e,up_low_boundary,FigWidth,FigHeight,FigFontSize)