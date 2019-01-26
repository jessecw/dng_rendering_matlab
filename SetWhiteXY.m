function dng_white = SetWhiteXY(white, colorMatrix1, colorMatrix2)
% dng_white = SetWhiteXY(white, fColorMatrix1, fColorMatrix)
% Author: Jesse Chen

fWhiteXY = white;

colorMatrix = FindXYZtoCamera_colorMatrix(fWhiteXY, colorMatrix1, colorMatrix2);

fCameraWhite = colorMatrix * XYtoXYZ (fWhiteXY);

whiteScale = 1.0 / max(fCameraWhite);

fCameraWhite = fCameraWhite*whiteScale;

fCameraWhite = max(0.001, fCameraWhite);
dng_white.fCameraWhite = min(1.0, fCameraWhite);

fPCStoCamera = colorMatrix * MapWhiteMatrix(PCStoXY(), fWhiteXY);

scale = max(fPCStoCamera * PCStoXYZ());

dng_white.fPCStoCamera = fPCStoCamera/scale;

dng_white.fCameraToPCS = inv(dng_white.fPCStoCamera);


function xy = PCStoXY()
% xy = PCStoXY()

D50_xy = [0.3457; 0.3585];
xy = D50_xy;


function xyz = PCStoXYZ()
% xyz = PCStoXYZ()

D50_xy = [0.3457; 0.3585];
xyz = XYtoXYZ(D50_xy);