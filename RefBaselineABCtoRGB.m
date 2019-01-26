function rgb = RefBaselineABCtoRGB(img, cameraWhite, cameraToRGB)
% rgb = RefBaselineABCtoRGB(img, cameraWhite, cameraToRGB)
% Author: Jesse Chen

[img_h, img_w, ~] = size(img);

img(:,:,1) = min(img(:,:,1), cameraWhite(1));
img(:,:,2) = min(img(:,:,2), cameraWhite(2));
img(:,:,3) = min(img(:,:,3), cameraWhite(3));

img = reshape(img, [img_h*img_w, 1, 3]);
img = squeeze(img);
rgb = cameraToRGB*(img');

rgb = reshape(rgb', [img_h, img_w, 3]);

