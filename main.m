% Last modified: 09-Jun-2020

clear all
close all
clc

VIN = 1.8; %input voltage
VOUT = 0.5; %output voltage
VT_N = 0.5645; %NMOS threshold voltage
VT_P = -0.5424; %PMOS threshold voltage

VG1 = 0; %gate voltage for transistor 1
VG2 = 2; %gate voltage for transistor 2
VG3 = 1.4; %gate voltage for transistor 3
VG4 = 0; %gate voltage for transistor 4
VG5 = 1.4; %gate voltage for transistor 5
VG6 = 0.7; %gate voltage for transistor 6
VG7 = 0.7; %gate voltage for transistor 7

VGS1 = VG1 - VIN;
VGS2 = VG2 - 2/3*VIN;
VGS3 = VG3 - 1/3*VIN;
VGS4 = VG4 - 1/3*VIN;
VGS5 = VG5 - 1/3*VIN;
VGS6 = VG6;
VGS7 = VG7;

VGS_ideal_N = max([VGS2 VGS3 VGS5 VGS6 VGS7]); %NMOS ideal gate-to-source voltage
VGS_ideal_P = min([VGS1 VGS4]); %PMOS ideal gate-to-source voltage

mobility = 2; %mobility ratio (NMOS mobility over PMOS mobility)
W_total = (15+5+10+25+10+20+20)*10*10; % total width of all transistors in um

[R_optimized,d_optimized,status] = Req_optimization(VIN,VOUT,VT_N,VT_P,VGS_ideal_N,VGS_ideal_P,VG1,VG2,VG3,VG4,VG5,VG6,VG7,mobility);
W_optimized = optimized_width(W_total,R_optimized,mobility);

fprintf('\nOptimized widths:\nW1 = %f um\nW2 = %f um\nW3 = %f um\nW4 = %f um\nW5 = %f um\nW6 = %f um\nW7 = %f um\n',W_optimized(1),W_optimized(2),W_optimized(3),W_optimized(4),W_optimized(5),W_optimized(6),W_optimized(7));
fprintf('\nOptimized duty cycles:\nd1 = %f\nd2 = %f\n',d_optimized(1),d_optimized(2));

if(status == 1)
    fprintf('successful\n');
else
    fprintf('failed\n');
end