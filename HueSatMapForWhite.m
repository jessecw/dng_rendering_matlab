function hsv_map = HueSatMapForWhite(white, fHueSatDeltas1, fHueSatDeltas2, temperature1, temperature2)
% HueSatMapForWhite(fHueSatDeltas1, fHueSatDeltas2, temperature1, temperature2)
% Author: Jesse Chen

if (temperature1 <= 0) | (temperature2 <= 0) | (temperature1 == temperature2)
    hsv_map = fHueSatDeltas1;
end

reverseOrder = temperature1 > temperature2;

if reverseOrder
    temp  = temperature1;
    temperature1 = temperature2;
    temperature2 = temp;
end

td = find_dng_temperature(white);

if td.fTemperature <= temperature1
    g = 1.0;
else if td.fTemperature >= temperature2
        g = 0.0;
    else
		invT = 1.0 / td.fTemperature;
		
		g = (invT - (1.0 / temperature2)) / ((1.0 / temperature1) - (1.0 / temperature2));        
    end
end

if reverseOrder
    g = 1.0 - g;
end

hsv_map = hsv_map_interpolation(fHueSatDeltas1, fHueSatDeltas2, g);

function map = hsv_map_interpolation(map1, map2, weight1)
% map = hsv_map_interpolation(map1, map2, weight1)

if weight1 >= 1.0
    map = map1;
    return;
end

if weight1 <= 0.0
    map = map2;
    return;
end

map.fHueDivisions = map1.fHueDivisions;
map.fSatDivisions = map1.fSatDivisions;
map.fValDivisions = map1.fValDivisions;

w1 = weight1;
w2 = 1.0 - weight1;

Deltas1 = map1.Deltas;
Deltas2 = map2.Deltas;

map.Deltas = Deltas1*w1 + Deltas2*w2;

