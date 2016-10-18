close all;
clear cam;
clear camobj;

ch = 1.30;
cam = webcam(1);
cam.resolution = '640x480';

cam.ExposureMode = 'manual';
cam.Exposure = -4;


figure()
hold on;
handle = imagesc(snapshot(cam));
axis([0,640,0,480]);

dim = [0.2 0.5 0.3 0.3];
dim2 = [0.2 0.4 0.3 0.3];
ann = annotation('textbox',dim,'String','  ','FitBoxToText','on');
ann2 = annotation('textbox',dim2,'String','1','FitBoxToText','on');
robHandle = plot(1,1,'r*');
ballHandle = plot(1,1,'g*');
ballArrow = plot([0 0], [0 0]);
lastPoint = [0,0];
dt = 1;
filterLen = 8;
ballSpeedFilter = zeros(filterLen,2);
filterInd = 1;
while true
    tic
    pic = snapshot(cam);
    [ball, robot, ballRaw, robotRaw] = findAtAngle(pic, 50, ch);
    
    goalLine = robot(2);
    ballSpeed = (ball - lastPoint) / dt;
    lastPoint = ball;
    filterInd = filterInd + 1;
    ballSpeedFilter(mod(filterInd, filterLen)+1,:) = ballSpeed;
    avgBallSpeed = mean(ballSpeedFilter,1);
    dist = norm(robot - ball);
    
    set(handle, 'CData', pic);
    set(ann, 'String', dist);
    
    set(robHandle, 'XData', robotRaw(1));
    set(robHandle, 'YData', robotRaw(2));
    set(ballHandle, 'XData', ballRaw(1));
    set(ballHandle, 'YData', ballRaw(2));
    if size(avgBallSpeed,2) ~=0
        set(ballArrow, 'XData', [ballRaw(1), ballRaw(1)+100*avgBallSpeed(1)]);
        set(ballArrow, 'YData', [ballRaw(2), ballRaw(2)-100*avgBallSpeed(2)]);
    end
    drawnow();
    
    dt = toc;
    
end
