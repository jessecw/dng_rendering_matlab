function colorSpace = ColorSpace_setMatrixToPCS(M)
% colorSpace = ColorSpace_setMatrixToPCS(M)
% Author: JesseChen

W1 = M * [1.0; 1.0; 1.0];
W2 = PCStoXYZ();

s0 = W2(1) / W1(1);
s1 = W2(2) / W1(2);
s2 = W2(3) / W1(3);

S = [s0 0 0; 0 s1 0; 0 0 s2];
colorSpace.fMatrixToPCS = S * M;
colorSpace.fMatrixFromPCS = inv(colorSpace.fMatrixToPCS);



function xyz = PCStoXYZ()
% xyz = PCStoXYZ()
% Author: JesseChen

D50_xy = [0.3457; 0.3585];
xyz = XYtoXYZ(D50_xy);
