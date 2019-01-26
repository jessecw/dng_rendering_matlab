function colorSpace = dng_space_sRGB()
% colorSpace = dng_space_sRGB()
% Author: Jesse Chen

colorSpace = ColorSpace_setMatrixToPCS([0.4361 0.3851 0.1431
									 0.2225 0.7169 0.0606
									 0.0139 0.0971 0.7141]);
