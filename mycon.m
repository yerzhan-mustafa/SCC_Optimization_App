function [c, ceq] = mycon(b,mobility)

c = [];
ceq1 = mobility/b(1)+1/b(2)+1/b(3)+mobility/b(4)+1/b(5)+1/b(6)+1/b(7)-(5+mobility*2);
ceq2 = b(8)+b(9)-1;
ceq = [ceq1; ceq2];

end