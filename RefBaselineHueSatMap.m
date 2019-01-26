function mapped_rgb = RefBaselineHueSatMap(rgb, hsv_map)
% mapped_rgb = RefBaselineHueSatMap(rgb, hsv_map)
% Author: Jesse Chen

[h, w, ~] = size(rgb);

hueDivisions = double(hsv_map.fHueDivisions);
satDivisions = double(hsv_map.fSatDivisions);
valDivisions = double(hsv_map.fValDivisions);
table = hsv_map.Deltas;

if hueDivisions < 2
    hScale = 0.0;
else
    hScale = hueDivisions * (1.0 / 6.0);
end

sScale = (satDivisions - 1);
vScale =  (valDivisions - 1);

maxHueIndex0 = hueDivisions - 1;
maxSatIndex0 = satDivisions - 2;
maxValIndex0 = valDivisions - 2;

hueStep = satDivisions;
valStep = hueDivisions * hueStep;

% matlab 
% hsv_img = rgb2hsv(rgb);
% hsv_img(:,:,1) = hsv_img(:,:,1)*6;

% embedded C
hsv_img = dng_RGBtoHSV(rgb);


if valDivisions < 2
    
else
    h_img_scaled = hsv_img(:,:,1) * hScale;
    s_img_scaled= hsv_img(:,:,2) * sScale;
    v_img_scaled = hsv_img(:,:,3) * vScale;
    
    hIndex0 = int32(floor(h_img_scaled));
    sIndex0 = int32(floor(s_img_scaled));
    vIndex0 = int32(floor(v_img_scaled));
    
    sIndex0 = min(sIndex0, maxSatIndex0);
    vIndex0 = min(vIndex0, maxValIndex0);
    
    hIndex1 = hIndex0 + 1;
    hIndex1 = int32(hIndex0 >= maxHueIndex0).*int32(zeros(h,w)) + int32(hIndex0 < maxHueIndex0).*hIndex1;
    hIndex0 = int32(hIndex0 >= maxHueIndex0).*maxHueIndex0 + int32(hIndex0 < maxHueIndex0).*hIndex0;
    
    hFract1 = h_img_scaled - double(hIndex0);
    sFract1 = s_img_scaled - double(sIndex0);
    vFract1 = v_img_scaled - double(vIndex0);

    hFract0 = 1.0 - hFract1;
    sFract0 = 1.0 - sFract1;
    vFract0 = 1.0 - vFract1;
    
    entry00 = vIndex0 * valStep + hIndex0 * hueStep + sIndex0 + 1;
    entry01 = entry00 + (hIndex1 - hIndex0) * hueStep;
    entry10 = entry00 + valStep;
    entry11 = entry01 + valStep;
    
    entry00 = reshape(entry00, [h*w, 1]);
    entry01 = reshape(entry01, [h*w, 1]);
    entry10 = reshape(entry10, [h*w, 1]);
    entry11 = reshape(entry11, [h*w, 1]);
    
    table_entry00 = table(entry00, 1);
    table_entry01 = table(entry01, 1);
    table_entry10 = table(entry10, 1);
    table_entry11 = table(entry11, 1);
    
    table_entry00 = reshape(table_entry00, [h, w]);
    table_entry01 = reshape(table_entry01, [h, w]);
    table_entry10 = reshape(table_entry10, [h, w]);
    table_entry11 = reshape(table_entry11, [h, w]);
    
    hueShift0 = vFract0 .* (hFract0 .* table_entry00 + hFract1 .* table_entry01) + ...
		   vFract1 .* (hFract0 .*table_entry10 + hFract1 .* table_entry11);

    table_entry00 = table(entry00, 2);
    table_entry01 = table(entry01, 2);
    table_entry10 = table(entry10, 2);
    table_entry11 = table(entry11, 2);
    
    table_entry00 = reshape(table_entry00, [h, w]);
    table_entry01 = reshape(table_entry01, [h, w]);
    table_entry10 = reshape(table_entry10, [h, w]);
    table_entry11 = reshape(table_entry11, [h, w]);
    
    satScale0 = vFract0 .* (hFract0 .* table_entry00 + hFract1 .* table_entry01) + ...
		   vFract1 .* (hFract0 .*table_entry10 + hFract1 .* table_entry11);

    table_entry00 = table(entry00, 3);
    table_entry01 = table(entry01, 3);
    table_entry10 = table(entry10, 3);
    table_entry11 = table(entry11, 3);
    
    table_entry00 = reshape(table_entry00, [h, w]);
    table_entry01 = reshape(table_entry01, [h, w]);
    table_entry10 = reshape(table_entry10, [h, w]);
    table_entry11 = reshape(table_entry11, [h, w]);
       
    valScale0 = vFract0 .* (hFract0 .* table_entry00 + hFract1 .* table_entry01) + ...
		   vFract1 .* (hFract0 .*table_entry10 + hFract1 .* table_entry11);
       
   entry00 = entry00 + 1;
   entry01 = entry01 + 1;
   entry10 = entry10 + 1;
   entry11 = entry11 + 1;

    table_entry00 = table(entry00, 1);
    table_entry01 = table(entry01, 1);
    table_entry10 = table(entry10, 1);
    table_entry11 = table(entry11, 1);
    
    table_entry00 = reshape(table_entry00, [h, w]);
    table_entry01 = reshape(table_entry01, [h, w]);
    table_entry10 = reshape(table_entry10, [h, w]);
    table_entry11 = reshape(table_entry11, [h, w]);   
   
    hueShift1 =  vFract0 .* (hFract0 .* table_entry00 + hFract1 .* table_entry01) + ...
		   vFract1 .* (hFract0 .*table_entry10 + hFract1 .* table_entry11);

    table_entry00 = table(entry00, 2);
    table_entry01 = table(entry01, 2);
    table_entry10 = table(entry10, 2);
    table_entry11 = table(entry11, 2);
    
    table_entry00 = reshape(table_entry00, [h, w]);
    table_entry01 = reshape(table_entry01, [h, w]);
    table_entry10 = reshape(table_entry10, [h, w]);
    table_entry11 = reshape(table_entry11, [h, w]);   
    
    satScale1 = vFract0 .* (hFract0 .* table_entry00 + hFract1 .* table_entry01) + ...
		   vFract1 .* (hFract0 .*table_entry10 + hFract1 .* table_entry11);

    table_entry00 = table(entry00, 3);
    table_entry01 = table(entry01, 3);
    table_entry10 = table(entry10, 3);
    table_entry11 = table(entry11, 3);
    
    table_entry00 = reshape(table_entry00, [h, w]);
    table_entry01 = reshape(table_entry01, [h, w]);
    table_entry10 = reshape(table_entry10, [h, w]);
    table_entry11 = reshape(table_entry11, [h, w]);   
       
    valScale1 = vFract0 .* (hFract0 .* table_entry00 + hFract1 .* table_entry01) + ...
		   vFract1 .* (hFract0 .*table_entry10 + hFract1 .* table_entry11);
   
    hueShift = sFract0 .* hueShift0 + sFract1 .* hueShift1;
	satScale = sFract0 .* satScale0 + sFract1 .* satScale1;
	valScale = sFract0 .* valScale0 + sFract1 .* valScale1;
      
   hueShift = hueShift*(6.0/ 360.0); 
       
   hsv_img(:,:,1) = hsv_img(:,:,1) + reshape(hueShift, [h, w, 1]);
   hsv_img(:,:,2) = hsv_img(:,:,2).*reshape(satScale, [h, w, 1]);
   hsv_img(:,:,2) = min(hsv_img(:,:,2), 1);
   hsv_img(:,:,3) = hsv_img(:,:,3).*reshape(valScale, [h, w, 1]);
   hsv_img(:,:,3) = min(max(hsv_img(:,:,3),0), 1);
   
   % Matlab
    %hsv_img(:,:,1) = (hsv_img(:,:,1) < 0).*(hsv_img(:,:,1) +6.0) + (hsv_img(:,:,1) >= 0).*hsv_img(:,:,1);
    %hsv_img(:,:,1) = (hsv_img(:,:,1) >= 6).*(hsv_img(:,:,1) - 6.0) + (hsv_img(:,:,1) < 6).*hsv_img(:,:,1);
    %hsv_img(:,:,1) = hsv_img(:,:,1)/6.0;
    %mapped_rgb = hsv2rgb(hsv_img);

   % embedded C
   mapped_rgb = dng_HSVtoRGB(hsv_img);
   
   mapped_rgb = min(max(mapped_rgb, 0), 1);
end

