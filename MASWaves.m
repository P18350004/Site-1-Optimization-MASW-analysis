clear all
close all
clc
%% DATA INPUT 
Filename = 'Site-1.dat';
HeaderLines = 7;
fs = 4000; % sampling frequency (Hz)
N = 24;   %number of geophones used
x1 = 10; % offset distance (m) 
dx = 1; % Geophone spacing (m)
Direction = 'forward';

[u,t,Tmax,L,x] = MASWaves_read_data(Filename,HeaderLines,fs,N,dx,x1,Direction);

%% PLOT DATA 
du = 1/50;   %wavefield plot scale
FigWidth = 10; % cm
FigHeight = 8; % cm
FigFontSize = 14; % pt

figure
MASWaves_plot_data(u,N,dx,x1,L,t,Tmax,du,FigWidth,FigHeight,FigFontSize)

%% DISPERSION 
cT_min = 0; % minimum Rayeigh wave velocity (m/s)
cT_max = 500; % maximum Rayleigh wave velocity (m/s)
delta_cT = 0.5; % m/s

[f,c,A] = MASWaves_dispersion_imaging(u,N,x,fs,cT_min,cT_max,delta_cT);

%% VELOCITY SPECTRA 2D
resolution = 100; 
fmin = 0; % minimum frequency limit of dispersion image (Hz)
fmax = 25; % maximum frequency limit of dispersion image (Hz)
FigWidth = 10; % cm
FigHeight = 10; % cm
FigFontSize = 8; % pt
figure
[fplot,cplot,Aplot] = MASWaves_plot_dispersion_image_2D(f,c,A,fmin,fmax,...
    resolution,FigWidth,FigHeight,FigFontSize);

%% VELOCITY SPECTRA 3D
fmin = 0; % Hz
fmax = 25; % Hz
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
 

%% Inversion from DE
c_test_min = 0; % m/s
c_test_max = 700; % m/s
delta_c_test = 0.5; % m/s
c_test = c_test_min:delta_c_test:c_test_max; % m/s

% Layer parameters
n = 5;
alpha =[1000 1000 1000 1000 1000 1000]; % P-wave velocity (m/s) 
 h = [1.6	2.1	1.2	2.2	3.0	14.4]; % soil layer thickness from DE algorithm 
 beta = [141	229	215	400	133	454];% shear wave velocity from DE algorithm
rho = [ 2000 2000 2000 2000 2000 2000]; % density (kg/m^3)

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

MASWaves_plot_inversion_results_one_iteation(c_t,f_curvet,...
    c_curve0,f_curve0,c_curve0_up,f_curve0_up,c_curve0_low,...
    f_curve0_low,n,beta,h,e,up_low_boundary,FigWidth,FigHeight,FigFontSize)