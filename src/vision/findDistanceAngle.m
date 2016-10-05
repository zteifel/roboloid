function [dist, angle, status, ball, robot] = findDistanceAngle(cam, camHeight, ballCol, robCol)
ballSize = 200;
robotSize = 1000;
status = '';
dist = -1;
angle = 999;
mapping = 1/(900*(camHeight/0.86));
ball = [0,0];
robot = [0,0];

im = snapshot(cam);

mask = maskImage(im, ballCol);
robotMask = maskImage(im, robCol);

CC_ball = bwconncomp(mask);
CC_robot = bwconncomp(robotMask);

ballCentr = regionprops(CC_ball, 'centroid');
ballAreaProps = regionprops(CC_ball, 'area');
ballCoords = cat(1, ballCentr.Centroid);
ballArea = cat(1, ballAreaProps.Area);

robotCentr = regionprops(CC_robot, 'centroid');
robotAreaProps = regionprops(CC_robot, 'area');
robotCoords = cat(1, robotCentr.Centroid);
robotArea = cat(1, robotAreaProps.Area);

[~, I] = sort(abs(robotArea-robotSize));
if size(I,1) > 0
    robotX = robotCoords(I(1),1);
    robotY = robotCoords(I(1),2);
    robot = [robotX, robotY];
else
    status = strcat(status, 'Cant see robot ');
end

[~, I] = sort(abs(ballArea-ballSize));
if size(I,1) > 0
    ballX = ballCoords(I(1),1);
    ballY = ballCoords(I(1),2);
    ball = [ballX, ballY];
else
    status = strcat(status, 'Cant see ball ');
end

if strcmp(status, '')
    v = [ballX - robotX, ballY-robotY];
    dist = mapping*norm(v);
    angle = atan2(v(1), v(2));
end



