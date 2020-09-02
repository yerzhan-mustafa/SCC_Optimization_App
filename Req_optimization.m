function [R_optimized,d_optimized,status] = Req_optimization(VIN,VOUT,VT_N,VT_P,VGS_ideal_N,VGS_ideal_P,VG1,VG2,VG3,VG4,VG5,VG6,VG7,mobility)
status = 1; %successful
termination = 300; %max number of iterations allowed

b0 = [1;1;1;1;1;1;1;0.5;0.5];

A = [
-1  0  0  0  0  0  0  0  0;
0  -1  0  0  0  0  0  0  0;
0  0  -1  0  0  0  0  0  0;
0  0  0  -1  0  0  0  0  0;
0  0  0  0  -1  0  0  0  0;
0  0  0  0  0  -1  0  0  0;
0  0  0  0  0  0  -1  0  0;
0  0  0  0  0  0  0  -1  0;
0  0  0  0  0  0  0  0  -1];
B = [0;  0;  0;  0;  0;  0;  0;  0;  0];

K = [1;1;1;1;1;1;1];
VS = [0;0;0;0;0;0;0];
options = optimoptions('fmincon','Algorithm','interior-point');

error = 1e-4;
stop = 0;
counter = 0;

while(stop == 0)
Kold = K;
    
VC1 = (2*K(3)*b0(3)*VIN*b0(9) + K(7)*b0(7)*VIN*b0(9) + K(1)*b0(1)*VOUT*b0(9) + K(2)*b0(2)*VOUT*b0(8) - 2*K(3)*b0(3)*VOUT*b0(9) + K(4)*b0(4)*VOUT*b0(9) + K(5)*b0(5)*VOUT*b0(8) + K(6)*b0(6)*VOUT*b0(8) - 2*K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
VC2 = (K(2)*b0(2)*VIN*b0(8) + 2*K(3)*b0(3)*VIN*b0(9) + K(5)*b0(5)*VIN*b0(8) + K(6)*b0(6)*VIN*b0(8) + K(7)*b0(7)*VIN*b0(9) + 2*K(1)*b0(1)*VOUT*b0(9) - K(2)*b0(2)*VOUT*b0(8) + 2*K(3)*b0(3)*VOUT*b0(9) + 2*K(4)*b0(4)*VOUT*b0(9) - K(5)*b0(5)*VOUT*b0(8) - K(6)*b0(6)*VOUT*b0(8) - K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));

fprintf('VC1 = %f\tVC2 = %f\n',VC1,VC2);

VS(1) = VIN;
VS(2) = (2*K(3)*b0(3)*VIN*b0(9) + K(5)*b0(5)*VIN*b0(8) + K(7)*b0(7)*VIN*b0(9) + 2*K(1)*b0(1)*VOUT*b0(9) + 2*K(2)*b0(2)*VOUT*b0(8) + 2*K(3)*b0(3)*VOUT*b0(9) + 2*K(4)*b0(4)*VOUT*b0(9) - K(5)*b0(5)*VOUT*b0(8) + 2*K(6)*b0(6)*VOUT*b0(8) - K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
VS(3) = VOUT;
VS(4) = (2*K(3)*b0(3)*VIN*b0(9) + K(4)*b0(4)*VIN*b0(9) + K(1)*b0(1)*VOUT*b0(9) + K(2)*b0(2)*VOUT*b0(8) - 2*K(3)*b0(3)*VOUT*b0(9) - 2*K(4)*b0(4)*VOUT*b0(9) + K(5)*b0(5)*VOUT*b0(8) + K(6)*b0(6)*VOUT*b0(8) + K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
VS(5) = VOUT;
VS(6) = -(K(6)*b0(6)*b0(8)*(VIN - 3*VOUT))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
VS(7) = -(K(7)*b0(7)*(VIN*b0(9) - 3*VOUT*b0(9)))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));


fprintf('VS1 = %f\tVS2 = %f\tVS3 = %f\tVS4 = %f\tVS5 = %f\tVS6 = %f\tVS7 = %f\n',VS(1),VS(2),VS(3),VS(4),VS(5),VS(6),VS(7));


K(1) = (abs(VGS_ideal_P)-abs(VT_P))/(abs(VG1-VS(1))-abs(VT_P));
K(2) = (VGS_ideal_N-VT_N)/(VG2-VS(2)-VT_N);
K(3) = (VGS_ideal_N-VT_N)/(VG3-VS(3)-VT_N);
K(4) = (abs(VGS_ideal_P)-abs(VT_P))/(abs(VG4-VS(4))-abs(VT_P));
K(5) = (VGS_ideal_N-VT_N)/(VG5-VS(5)-VT_N);
K(6) = (VGS_ideal_N-VT_N)/(VG6-VS(6)-VT_N);
K(7) = (VGS_ideal_N-VT_N)/(VG7-VS(7)-VT_N);

fprintf('K1 = %f\tK2 = %f\tK3 = %f\tK4 = %f\tK5 = %f\tK6 = %f\tK7 = %f\n',K(1),K(2),K(3),K(4),K(5),K(6),K(7));

Req = myfun(b0,K);
fprintf('Req = %f\n',Req);

if(abs(Kold(1)-K(1))<error && abs(Kold(2)-K(2))<error && abs(Kold(3)-K(3))<error && abs(Kold(4)-K(4))<error && abs(Kold(5)-K(5))<error && abs(Kold(6)-K(6))<error && abs(Kold(7)-K(7))<error)
    stop = 1;
end

counter = counter + 1;
if(counter == termination)
    stop = 1;
    status = 0; %failed
    fprintf('failed1\n');
end
end
fprintf('Number of iterations = %d\n',counter);

stop = 0;
counter = 0;
if(status == 1)
    while(stop == 0)
    Kold = K;

    b0 = fmincon(@(b) myfun(b,K),b0,A,B,[],[],[],[],@(b) mycon(b,mobility),options);
    fprintf('R1 = %f\tR2 = %f\tR3 = %f\tR4 = %f\tR5 = %f\tR6 = %f\tR7 = %f\td1 = %f\td2 = %f\n',b0(1),b0(2),b0(3),b0(4),b0(5),b0(6),b0(7),b0(8),b0(9));

    Req = myfun(b0,K);
    fprintf('Req = %f\n',Req);

    VC1 = (2*K(3)*b0(3)*VIN*b0(9) + K(7)*b0(7)*VIN*b0(9) + K(1)*b0(1)*VOUT*b0(9) + K(2)*b0(2)*VOUT*b0(8) - 2*K(3)*b0(3)*VOUT*b0(9) + K(4)*b0(4)*VOUT*b0(9) + K(5)*b0(5)*VOUT*b0(8) + K(6)*b0(6)*VOUT*b0(8) - 2*K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
    VC2 = (K(2)*b0(2)*VIN*b0(8) + 2*K(3)*b0(3)*VIN*b0(9) + K(5)*b0(5)*VIN*b0(8) + K(6)*b0(6)*VIN*b0(8) + K(7)*b0(7)*VIN*b0(9) + 2*K(1)*b0(1)*VOUT*b0(9) - K(2)*b0(2)*VOUT*b0(8) + 2*K(3)*b0(3)*VOUT*b0(9) + 2*K(4)*b0(4)*VOUT*b0(9) - K(5)*b0(5)*VOUT*b0(8) - K(6)*b0(6)*VOUT*b0(8) - K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));

    fprintf('VC1 = %f\tVC2 = %f\n',VC1,VC2);

    VS(1) = VIN;
    VS(2) = (2*K(3)*b0(3)*VIN*b0(9) + K(5)*b0(5)*VIN*b0(8) + K(7)*b0(7)*VIN*b0(9) + 2*K(1)*b0(1)*VOUT*b0(9) + 2*K(2)*b0(2)*VOUT*b0(8) + 2*K(3)*b0(3)*VOUT*b0(9) + 2*K(4)*b0(4)*VOUT*b0(9) - K(5)*b0(5)*VOUT*b0(8) + 2*K(6)*b0(6)*VOUT*b0(8) - K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
    VS(3) = VOUT;
    VS(4) = (2*K(3)*b0(3)*VIN*b0(9) + K(4)*b0(4)*VIN*b0(9) + K(1)*b0(1)*VOUT*b0(9) + K(2)*b0(2)*VOUT*b0(8) - 2*K(3)*b0(3)*VOUT*b0(9) - 2*K(4)*b0(4)*VOUT*b0(9) + K(5)*b0(5)*VOUT*b0(8) + K(6)*b0(6)*VOUT*b0(8) + K(7)*b0(7)*VOUT*b0(9))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
    VS(5) = VOUT;
    VS(6) = -(K(6)*b0(6)*b0(8)*(VIN - 3*VOUT))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));
    VS(7) = -(K(7)*b0(7)*(VIN*b0(9) - 3*VOUT*b0(9)))/(K(1)*b0(1)*b0(9) + K(2)*b0(2)*b0(8) + 4*K(3)*b0(3)*b0(9) + K(4)*b0(4)*b0(9) + K(5)*b0(5)*b0(8) + K(6)*b0(6)*b0(8) + K(7)*b0(7)*b0(9));

    fprintf('VS1 = %f\tVS2 = %f\tVS3 = %f\tVS4 = %f\tVS5 = %f\tVS6 = %f\tVS7 = %f\n',VS(1),VS(2),VS(3),VS(4),VS(5),VS(6),VS(7));

    K(1) = (abs(VGS_ideal_P)-abs(VT_P))/(abs(VG1-VS(1))-abs(VT_P));
    K(2) = (VGS_ideal_N-VT_N)/(VG2-VS(2)-VT_N);
    K(3) = (VGS_ideal_N-VT_N)/(VG3-VS(3)-VT_N);
    K(4) = (abs(VGS_ideal_P)-abs(VT_P))/(abs(VG4-VS(4))-abs(VT_P));
    K(5) = (VGS_ideal_N-VT_N)/(VG5-VS(5)-VT_N);
    K(6) = (VGS_ideal_N-VT_N)/(VG6-VS(6)-VT_N);
    K(7) = (VGS_ideal_N-VT_N)/(VG7-VS(7)-VT_N);

    fprintf('K1 = %f\tK2 = %f\tK3 = %f\tK4 = %f\tK5 = %f\tK6 = %f\tK7 = %f\n',K(1),K(2),K(3),K(4),K(5),K(6),K(7));


    if(abs(Kold(1)-K(1))<error && abs(Kold(2)-K(2))<error && abs(Kold(3)-K(3))<error && abs(Kold(4)-K(4))<error && abs(Kold(5)-K(5))<error && abs(Kold(6)-K(6))<error && abs(Kold(7)-K(7))<error)
        stop = 1;
    end
    
    counter = counter + 1;
    if(counter == termination)
        stop = 1;
        status = 0;
        fprintf('failed2\n');
    end
    
    end
    fprintf('Number of iterations = %d\n',counter);
end

R_optimized = b0(1:7);
d_optimized = b0(8:9);

end