function [ball, robot, ballRaw, robotRaw, gamma] = findAtAngle(im, camAng, camH)

ballSize = 2000;
robotSize = 1000;

ballCol = [220, 50, 50];
robCol = [215,255,170];

xMax = 640;
yMax = 480;

ballRaw = findColorMarker(im, ballCol, ballSize);
robotRaw = findColorMarker(im, robCol, robotSize);

ball = xyToPos(ballRaw, camAng, camH, [xMax, yMax]);
[robot, gamma] = xyToPos(robotRaw, camAng, camH, [xMax, yMax]);








