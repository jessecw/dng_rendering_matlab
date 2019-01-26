function B = MapWhiteMatrix(white1, white2)
% B = MapWhiteMatrix(white1, white2)

% use the linearized Bradford adaption matrix
Mb = [
 0.8951   0.2664  -0.1614
-0.7502   1.7135   0.0367
 0.0389  -0.0685   1.0296    
];

w1 = Mb * XYtoXYZ(white1);
w2 = Mb * XYtoXYZ(white2);

w1 = max(w1, 0);
w2 = max(w2, 0);

A = zeros(3,3);

if w1(1) > 0
    a11 = w2(1)/w1(1);
else
    a11 = 10.0
end
a11 = max(0.1, a11);
a11 = min(a11, 10.0);

if w1(2) > 0
    a22 = w2(2)/w1(2);
else
    a22 = 10.0
end
a22 = max(0.1, a22);
a22 = min(a22, 10.0);

if w1(3) > 0
    a33 = w2(3)/w1(3);
else
    a33 = 10.0
end
a33 = max(0.1, a33);
a33 = min(a33, 10.0);

A(1,1) = a11;
A(2,2) = a22;
A(3,3) = a33;

B = inv(Mb)*A*Mb;


