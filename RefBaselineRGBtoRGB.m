function rgb = RefBaselineRGBtoRGB(img, matrix)
% rgb = RefBaselineRGBtoRGB(img, matrix)
% Author: Jesse Chen

[img_h, img_w, ~] = size(img);

img = reshape(img, [img_h*img_w, 1, 3]);
img = squeeze(img);
rgb = matrix*(img');

rgb = reshape(rgb', [img_h, img_w, 3]);

rgb = min(max(rgb, 0), 1);
