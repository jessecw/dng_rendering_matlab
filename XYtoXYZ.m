function xyz = XYtoXYZ(coord)
% xyz = XYtoXYZ(coord)
% Author: Jesse Chen

x = coord(1);
y = coord(2);

x = min(0.9, max(0.000001, x));
y = min(0.9, max(0.000001, y));

if ((x + y) > 0.999999)
    scale = 0.999999/(x + y);
    x = x * scale;
    y = y * scale;
end

xyz(1) = x/y;
xyz(2) = 1.0;
xyz(3) = (1.0 - x - y)/y;

xyz = xyz';