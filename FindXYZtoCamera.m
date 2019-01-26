function colorMatrix = FindXYZtoCamera(white, fColorMatrix1, fColorMatrix2)
% colorMatrix = FindXYZtoCamera(white, fColorMatrix1, fColorMatrix2)
% Author: Jesse Chen

%%
fTemperature1 = 2850;
fTemperature2 = 6500;

%%
td = find_dng_temperature(white);

if td.fTemperature <= fTemperature1
    g = 1.0;
else if td.fTemperature >= fTemperature2
        g = 0.0;
    else
		invT = 1.0 / td.fTemperature;
		
		g = (invT - (1.0 / fTemperature2)) / ((1.0 / fTemperature1) - (1.0 / fTemperature2));        
    end
end

%%
if (g >= 1.0)
    colorMatrix = fColorMatrix1;
else if (g <= 0.0)
        colorMatrix = fColorMatrix2;
    else
        colorMatrix = fColorMatrix1*g + fColorMatrix2*(1.0 - g);
    end
end

