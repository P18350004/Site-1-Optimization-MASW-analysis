This manuscript presents the applicabilty of TLBO-KRSM optimization algorithm to estimate site-specific Vs profile along with the Vs profile from other optimization algorithms (PSO, ABCO, GA, DE) using MASW techniques.

Important: This Repository "Site-1-Optimization-MASW-analysis" is for generating the experimental fundamental mode dispersion curve from Site-1 data and obtaining the theoretical fundamental mode dispersion curve corresponding to the optimized Vs profile. 
         
Please adopt the following steps to run the code.

Guideline for quick test of Site-1 data
Step-1: Open MATLAB file "MASWaves".
Step-2: MASW data (wavefield) for Site-1 is given by file "Site-1.dat" and used it in "MASWaves.m" file. 
Step-3: Run the "MASWaves.m" code to obtian Dispersion image for Site-1 (Fig. 5c of Manuscript). 
Step-4: After click on Run, Maltlab code ask to input "Fundamental mode dispersion curve:". Input "1:6" in commond window.
Step-5: Save matlab file "c_curve0.mat" and "lambda_curve0" from workspace and use it in the ABCO, DE, GA, PSO and TLBO algorithm. There are 6 points on fundamental mode Disperison curve at Site-1. .
Step-6: The optimized Vs profile obtained from DE algorithm is already given in this "MASWaves" code. Click on Run "MASWaves.m" to generate the theoretical fundamental mode corresponding to optimized Vs profile.
Step-7: Repeat these Steps using the optimized Vs profiles obtained from other optimization algorithms.

The Optimized Vs profiles (of Site-1) obtained at 100th iteration from ABCO, DE, GA, PSO, and TLBO are presented in Fig. 7b and Fig. 7a (of manuscript) shows the comparison of experimental and theoretical fundamental mode dispersion curves. 
