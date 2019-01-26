function XY = NeutralToXY(camera_neutral, fColorMatrix1, fColorMatrix2)
% XY = NeutralToXY(camera_neutral)

kMaxPasses = 30;

D50_xy = [0.3457; 0.3585];

last = D50_xy;
for pass = 1:kMaxPasses
    xyzToCamera = FindXYZtoCamera(last, fColorMatrix1, fColorMatrix2);
    
    next = XYZtoXY(inv(xyzToCamera) * camera_neutral);
    
    if ((abs(next(1) - last(1)) + abs(next(2) - last(2))) < 0.0000001)
        XY = next;
        return;
    end
        
    if pass == (kMaxPasses - 1)
        next = (last + next)*0.5;
    end
    
    last = next;
end

XY = last;