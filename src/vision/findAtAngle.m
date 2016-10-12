function [ball, robot, ballRaw, robotRaw] = findAtAngle(im, camAng, camH)

ballSize = 2000;
robotSize = 1000;

ballCol = [250, 50, 50];
robCol = [200,255,150];

xMax = 640;
yMax = 480;

ballRaw = findColorMarker(im, ballCol, ballSize);
robotRaw = findColorMarker(im, robCol, robotSize);

ball = xyToPos(ballRaw, camAng, camH, [xMax, yMax]);
robot = xyToPos(robotRaw, camAng, camH, [xMax, yMax]);








