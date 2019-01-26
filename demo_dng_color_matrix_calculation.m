%% demo_dng_color_matrix_calculation.m
% Author: Jesse Chen
% This is a demo file for dng color matrix calculation.

%% colorMatrix
colorMatrix1 = [
      1.3488  -0.8849   0.0929
     -0.1484   0.7881   0.4303
     -0.0302   0.0979   0.5113    
];

colorMatrix2 = [
      0.8760  -0.2517  -0.0607
     -0.2745   1.0465   0.2644
     -0.0943   0.1792   0.5458 
];

%% AsShotNeutral
camera_neutral = [0.542939; 1.00; 0.538609];

%%
camera_neutral_xy = NeutralToXY(camera_neutral, colorMatrix1, colorMatrix2);
dng_white = SetWhiteXY(camera_neutral_xy, colorMatrix1, colorMatrix2);

%%
fCameraWhite = camera_neutral;
proPhoto = dng_space_ProPhoto();

fCameraToRGB = proPhoto.fMatrixFromPCS * dng_white.fCameraToPCS;
