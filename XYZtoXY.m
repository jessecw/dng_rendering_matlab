function xy = XYZtoXY(coord)
% xy = XYZtoXY(coord)
% Author: Jesse Chen

X = coord(1);
Y = coord(2);
Z = coord(3);

total = X + Y +Z;

if total > 0.0
    xy = [X/total; Y/total];
else
    xy = [0.3457; 0.3585];
end