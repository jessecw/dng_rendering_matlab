function rgb = dng_gamma_2_2_mapping(img)
% rgb = dng_gamma_2_2_mapping(img)
% Author: Jesse Chen

[img_h, img_w, ~] = size(img);

rgb(:,:,1) = gamma_2_2_mapping(img(:,:,1));
rgb(:,:,2) = gamma_2_2_mapping(img(:,:,2));
rgb(:,:,3) = gamma_2_2_mapping(img(:,:,3));



function mapped = gamma_2_2_mapping(img_in)
% mapped = gamma_2_2_mapping(img_in)
% Author: Jesse Chen

x = linspace(0, 1, 1025);
y = gamma_2_2(x);

mapped = interp1(x, y, img_in);


