function [goalLx, goalLy, goalRx, goalRy] = findGoal(im, camH, camAng)
color = [50, 80, 100];
mask = maskImage(im, color);
GP1 = findColorMarker(im, color, 64);

im(GP1(1)-10:GP1(1)+10, GP1(2)-10:GP1(2)+10) = 0;

GP2 = findColorMarker(im, color, 64);

if GP1(1) < GP2(1)
    goalLx = GP1(1);
    goalLy = GP1(2);
    
    goalRx = GP2(1);
    goalRy = GP2(2);
else
    goalLx = GP2(1);
    goalLy = GP2(2);
    
    goalRx = GP1(1);
    goalRy = GP1(2);
end

[goalLx, goalLy] = xyToPos( [goalLx, goalLy], camAng, camH, [xMax, yMax]);
[goalRx, goalRy] = xyToPos([goalRx, goalRy], camAng, camH, [xMax, yMax]);
